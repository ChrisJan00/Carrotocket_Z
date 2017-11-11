Buttons = Buttons or {}

function Buttons.init()
    Buttons.refs = {}

    Buttons.loadButton("img/example_button.png")
end

function Buttons.reset()
    Buttons.list = {}

    for i = 1,1 do
        table.insert(Buttons.list, Buttons.spawn())
    end
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
        w = w,
        h = h,
        sprites = sprites
    }

    table.insert(Buttons.refs, buttonDef)
end

function Buttons.spawn()
        -- spawn button
    local ndx = math.random(#Buttons.refs)
    local ref = Buttons.refs[ndx]
    local newButton = {
        img = ref.img,
        x = 100,
        y = 100,
        w = ref.w,
        h = ref.h,
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
                love.graphics.draw(self.img, self.sprites[self.frame], self.x, self.y)
            end,
        }

    return newButton
end

function Buttons.update(dt)
    for _,button in ipairs(Buttons.list) do
        button:update(dt)
    end
end

function Buttons.draw()
    love.graphics.setColor(255,255,255)
    for _,button in ipairs(Buttons.list) do
        button:draw()
    end
end

function Buttons.whichPressed(pos)
    for _,button in ipairs(Buttons.list) do
        if pos.x >= button.x and pos.x <= button.x + button.w and pos.y >= button.y and pos.y <= button.y + button.h then
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
    end
end

function Buttons.release()
    if Buttons.lastPressed then
        Buttons.lastPressed.isPressed = false
        Buttons.lastPressed = nil
    end
end

