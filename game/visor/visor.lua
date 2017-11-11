Visor = Visor or {}

function Visor.init()
    Visor.rocket = {
        anim = Anims.createWSprite("img/rocket_sheet_vert.png", 150, 64, 0.075),
        fall = {
            current = 0,
            dest = 0,
            speed = 50,
            punish = 3,
            reward = 30,
            maximum = 136
        },
    }

    Visor.bgLayers = {
        {
            img = love.graphics.newImage("img/top_bgloop.png"),
            x = 0,
            speed = 150,
        }
    }

    for i=1,#Visor.bgLayers do
        local l = Visor.bgLayers[i]
        l.w = l.img:getWidth()
    end

end

function Visor.reset()
    Visor.rocket.anim:reset()
end

function Visor.update(dt)
    -- animations
    Visor.rocket.anim:update(dt)

    for i=1,#Visor.bgLayers do
        local l = Visor.bgLayers[i]
        l.x = l.x - l.speed * dt
        while l.x < -l.w do
            l.x = l.x + l.w
        end
    end

    -- rocket height
    local f = Visor.rocket.fall

    -- compute loss
    f.dest = f.dest + f.punish * #Buttons.blinkList * dt

    -- animate fall
    if f.dest < f.current then
        -- raising
        f.current = math.max(f.current - f.speed * dt, f.dest)
        Buttons.updateVibration(f.current / f.maximum)
    elseif f.dest > f.current then
        -- falling
        f.current = math.min(f.current + f.speed * dt, f.dest)
        Buttons.updateVibration(f.current / f.maximum)

        -- game over?
        if f.current > f.maximum then
            launchGameover()
        end
    end

end

function Visor.deblinked()
    Visor.rocket.fall.dest = math.max(Visor.rocket.fall.dest - Visor.rocket.fall.reward, 0)
end

function Visor.draw()
    love.graphics.setScissor(0,0, ViewSize.x, ViewSize.y / ScreenSize.y * 128)
    love.graphics.setColor(255,255,255)

    for i=1,#Visor.bgLayers do
        local l = Visor.bgLayers[i]
        love.graphics.draw(l.img, l.x + l.w)
        love.graphics.draw(l.img, l.x)
    end

    Visor.rocket.anim:draw(0, Visor.rocket.fall.current)

    love.graphics.setScissor()

end

function love.keypressed(key)
    if key == "down" then Visor.rocket.fall.dest = Visor.rocket.fall.dest + 50 end
    if key == "up" then Visor.rocket.fall.dest = Visor.rocket.fall.dest - 50 end

end