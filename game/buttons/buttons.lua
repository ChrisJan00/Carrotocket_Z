Buttons = Buttons or {}

function Buttons.init()
    Buttons.refs = {}

    -- special: button 1 is destruction!
    Buttons.loadButton("img/bigbutton.png")
    Buttons.loadButton("img/butt1_var1.png")
    Buttons.loadButton("img/butt1_var2.png")
    Buttons.loadButton("img/butt2_sheet_var1.png")
    Buttons.loadButton("img/butt2_sheet_var2.png")
    Buttons.loadButton("img/butt3_var1.png")
    Buttons.loadButton("img/butt3_var2.png")
    Buttons.loadButton("img/butt4_var1.png")
    Buttons.loadButton("img/butt4_var2.png")

    Buttons.vibration = {
        amp = 0,
        phase = 0,
        freq = 0.01,
        -- maximum = 15,
        maximum = 1,
        last = Vector(0,0),
        frameCount = 2,
        frame = 0
    }

    Buttons.bg = love.graphics.newImage("img/bottomBG.png")
end

function Buttons.reset()
    Buttons.list = {}
    Buttons.vibration.amp = 0

    -- special: insert button 1, and then not again
    table.insert(Buttons.list, Buttons.spawnOne(1))
    Buttons.list[1].pos.x = 200 - 64
    Buttons.list[1].pos.y = (172-96) / 2 + 128
    Buttons.list[1].autodestroy = true

    for i = 1,20 do
        local newB =  Buttons.spawnOne()
        if newB then
            table.insert(Buttons.list, newB)
        end
    end

    Buttons.resetBlinkLogic()
end

function Buttons.loadButton(imgFile)
    local img = love.graphics.newImage(imgFile)
    local w = img:getWidth() / 8
    local h = img:getHeight()
    local sprites = {}
    for i=0,7 do
        sprites[i+1] =  love.graphics.newQuad(i*w, 0, w, h, img:getWidth(), img:getHeight())
    end

    local buttonDef = {
        img = img,
        size = Vector(w,h),
        sprites = sprites
    }

    table.insert(Buttons.refs, buttonDef)
end

function Buttons.spawnOne(desired)
    local yofs = Buttons.vibration.maximum
    local function collides(topleft, bottomrt)
        local box = BoxFromVectors(topleft, bottomrt)
        for _,b in ipairs(Buttons.list) do
            if BoxFromVectors(b.pos, b.pos + b.size):intersects(box) then return true end
        end
        return false
    end

    local function getNewButtonPos(sz)
        local maxtries = 40
        local pos = false
        while not pos do
            pos = Vector(math.random(400 - sz.x), math.random(172 - sz.y - yofs) + 128 + yofs)
            if collides(pos, pos+sz) then
                pos = false
            end
            maxtries = maxtries - 1
            if maxtries <= 0 then
                return false
            end
        end
        return pos
    end

    -- spawn button
    local ndx = desired or (1 + math.random(#Buttons.refs - 1))
    local ref = Buttons.refs[ndx]
    local pos = getNewButtonPos(ref.size)
    if not pos then return false end

    local newButton = {
        img = ref.img,
        pos = pos,
        size = ref.size,
        sprites = ref.sprites,
        isPressed = false,
        isBlinking = false,
        anim = Anims.create(0.15, 6),
        frame = 1,

        update = function(self, dt)
            self.anim:update(dt)
            if self.isPressed then
                self.frame = 2
            elseif self.isBlinking then
                self.frame = 2 + self.anim.frame
            else
                self.frame = 1
            end
        end,
        draw = function(self)
                love.graphics.draw(self.img, self.sprites[self.frame], self.pos.x, self.pos.y)
            end,
        }

    return newButton
end

function Buttons.update(dt)
    for _,button in ipairs(Buttons.list) do
        button:update(dt)
    end

    Buttons.updateBlink(dt)
end

function Buttons.draw()
    love.graphics.setScissor(0, ViewSize.y * 128 / ScreenSize.y, ViewSize.x, ViewSize.y * 172 / ScreenSize.y)
    -- vibrate!
    love.graphics.push()
    Buttons.vibration.frame = Buttons.vibration.frame + 1
    if Buttons.vibration.frame >= Buttons.vibration.frameCount then
        local a = math.floor(Buttons.vibration.amp)
        Buttons.vibration.last = Vector(math.random(a*2) - a, math.random(a*2) - a)
        Buttons.vibration.frame = 0
    end

    love.graphics.translate(Buttons.vibration.last.x, Buttons.vibration.last.y)


    -- button background
    love.graphics.setColor(255,255,255)
    love.graphics.draw(Buttons.bg, -100, 128 - (260 - 172) * 0.5)

    love.graphics.setColor(255,255,255)
    for _,button in ipairs(Buttons.list) do
        button:draw()
    end

    love.graphics.pop()
    love.graphics.setScissor()
end

function Buttons.whichPressed(pos)
    for _,button in ipairs(Buttons.list) do
        if pos.x >= button.pos.x and pos.x <= button.pos.x + button.size.x and pos.y >= button.pos.y and pos.y <= button.pos.y + button.size.y then
            return button
        end
    end
    return nil
end

function Buttons.pressAt(pos)
    Buttons.release()
    local btn = Buttons.whichPressed(pos)
    if btn then
        Buttons.lastPressed = btn
        btn.isPressed = true
        if btn.autodestroy then
            General.doGameover()
        end

        Buttons.blinkPressed(btn)
    end
end

function Buttons.release()
    if Buttons.lastPressed then
        Buttons.lastPressed.isPressed = false
        Buttons.lastPressed = nil
    end
end

-------------------------------

function Buttons.resetBlinkLogic()
    -- we want more and more buttons to blink over time
    Buttons.blinkList = {}
    Buttons.nonBlinkList = {}

    -- skip button 1 (destruction)
    for i = 2,#Buttons.list do
        local b = Buttons.list[i]
        table.insert(Buttons.nonBlinkList, b)
    end

    -- so the period has to start hi, get smaller over time, but we want to breath in between so...
    Buttons.blinkControl = {
        timer = 0,
        nextTimeout = 2,
        amp = 5,
    }

end

function Buttons.updateBlink(dt)
    local bk = Buttons.blinkControl
    bk.timer = bk.timer + dt
    if bk.timer >= bk.nextTimeout then

        -- reset blink control
        bk.timer = 0
        bk.amp = bk.amp * 0.92
        bk.nextTimeout = (0.5 + bk.amp) * ((math.random() - 0.5) * 0.3 + 0.85)

        -- choose botan
        if #Buttons.nonBlinkList > 0 then
            local nubut = table.remove(Buttons.nonBlinkList, math.random(#Buttons.nonBlinkList))
            table.insert(Buttons.blinkList, nubut)
            nubut.isBlinking = true
            nubut.anim:reset()
        end
    end

end

function Buttons.blinkPressed(btn)
    if btn.isBlinking then
        btn.isBlinking = false
        Visor.deblinked()
    end

    for i=1,#Buttons.blinkList do
        if Buttons.blinkList[i] == btn then
            table.remove(Buttons.blinkList, i)
            table.insert(Buttons.nonBlinkList, btn)
            break
        end
    end
end

function Buttons.updateVibration(percent)
    Buttons.vibration.amp = Buttons.vibration.maximum * percent
end
