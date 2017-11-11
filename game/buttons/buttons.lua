Buttons = Buttons or {}

function Buttons.init()
    Buttons.refs = {}

    Buttons.loadButton("img/example_button.png")
end

function Buttons.reset()
    Buttons.list = {}

    for i = 1,10 do
        table.insert(Buttons.list, Buttons.spawnOne())
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

function Buttons.spawnOne()
    local function collides(topleft, bottomrt)
        local box = BoxFromVectors(topleft, bottomrt)
        for _,b in ipairs(Buttons.list) do
            if BoxFromVectors(b.pos, b.pos + b.size):intersects(box) then return true end
        end
        return false
    end

    local function getNewButtonPos(sz)
        local pos = false
        while not pos do
            pos = Vector(math.random(400 - sz.x), math.random(172 - sz.y) + 128)
            if collides(pos, pos+sz) then
                pos = false
            end
        end
        return pos
    end

    -- spawn button
    local ndx = math.random(#Buttons.refs)
    local ref = Buttons.refs[ndx]
    local pos = getNewButtonPos(ref.size)
    local newButton = {
        img = ref.img,
        pos = pos,
        size = ref.size,
        sprites = ref.sprites,
        isPressed = false,
        isBlinking = false,
        anim = Anims.create(0.3, 6),
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
    love.graphics.setColor(255,255,255)
    for _,button in ipairs(Buttons.list) do
        button:draw()
    end
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

    for _,b in ipairs(Buttons.list) do
        table.insert(Buttons.nonBlinkList, b)
    end

    -- so the period has to start hi, get smaller over time, but we want to breath in between so...
    Buttons.blinkControl = {
        timer = 0,
        nextTimeout = 10,
        amp = 10,
    }

end

function Buttons.updateBlink(dt)
    local bk = Buttons.blinkControl
    bk.timer = bk.timer + dt
    if bk.timer >= bk.nextTimeout then

        -- reset blink control
        bk.timer = 0
        bk.amp = bk.amp * 0.95
        bk.nextTimeout = (1.5 + bk.amp) * ((math.random() - 0.5) * 0.3 + 0.85)

        -- choose botan
        if #Buttons.nonBlinkList > 0 then
            local nubut = table.remove(Buttons.nonBlinkList, math.random(#Buttons.nonBlinkList))
            table.insert(Buttons.blinkList, nubut)
            nubut.isBlinking = true
        end
    end

end

function Buttons.blinkPressed(btn)
    if btn.isBlinking then
        btn.isBlinking = false
    end

    for i=1,#Buttons.blinkList do
        if Buttons.blinkList[i] == btn then
            table.remove(Buttons.blinkList, i)
            table.insert(Buttons.nonBlinkList, btn)
            break
        end
    end
end

