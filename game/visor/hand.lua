Hand = Hand or {}

function Hand.init()
    Hand.pos = Vector(200, 128 + 172 / 2)

    Hand.img = love.graphics.newImage("img/placeholder-hand.png")

    Hand.ofs = Vector(64, 24)
    Hand.dir = Vector(0, 0)
    Hand.speed = 120
    Hand.vel = Vector(0,0)
    Hand.inertia = 0.8

    Hand.pressing = false

    Hand.idleAnim = Anims.createWSprite("img/hand_idle.png", 128, 256, 0.1)
    Hand.pushAnim = Anims.createWSprite("img/hand_push.png", 128, 256, 0.05)
    Hand.pushAnim.onEndCallback = function()
        Hand.pressing = false
        Buttons.release()
    end
end

function Hand.reset()
    Hand.dir = Vector(0, 0)
    Hand.vel = Vector(0,0)
end

function Hand.update(dt)
    -- position

    Hand.vel = Hand.vel * math.pow(Hand.inertia, dt*60) + Hand.dir * Hand.speed * dt
    Hand.pos = Hand.pos + Hand.vel
    if Hand.pos.x < 0 then
        Hand.pos.x = 0
    end

    if Hand.pos.x > 400 then
        Hand.pos.x = 400
    end

    if Hand.pos.y < 132 then
        Hand.pos.y = 132
    end

    if Hand.pos.y > 300 then
        Hand.pos.y = 300
    end

    -- animations
    if Hand.pressing then
        Hand.pushAnim:update(dt)
    else
        Hand.idleAnim:update(dt)
    end

end

function Hand.draw()
    love.graphics.setColor(255,255,255)
    -- love.graphics.draw(Hand.img, Hand.pos.x - Hand.ofs.x, Hand.pos.y - Hand.ofs.y)
    local x,y = Hand.pos.x - Hand.ofs.x, Hand.pos.y - Hand.ofs.y
    if Hand.pressing then
        Hand.pushAnim:draw(x, y)
    else
        Hand.idleAnim:draw(x, y)
    end
end

function Hand.keypressed(key)
    if key == "up" then
        Hand.dir.y = -1
    end

    if key == "down" then
        Hand.dir.y = 1
    end

    if key == "left" then
        Hand.dir.x = -1
    end

    if key == "right" then
        Hand.dir.x = 1
    end

    Hand.dir = Hand.dir:norm()

    if key == "space" and not Hand.pressing then
        local btn = Buttons.pressAt(Hand.pos)
        if btn and btn.isPressed then
            Hand.pressing = true
            Hand.pushAnim:reset()
        end
    end

end

function Hand.keyreleased(key)
    if key == "up" and Hand.dir.y < 0 then
        Hand.dir.y = 0
    end

    if key == "down" and Hand.dir.y > 0 then
        Hand.dir.y = 0
    end

    if key == "left" and Hand.dir.x < 0 then
        Hand.dir.x = 0
    end

    if key == "right" and Hand.dir.x > 0 then
        Hand.dir.x = 0
    end

    Hand.dir = Hand.dir:norm()

    -- if key == "space" then
    --     Buttons.release()
    -- end

end

