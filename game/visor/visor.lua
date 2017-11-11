Visor = Visor or {}

function Visor.init()
    Visor.rocket = {
        anim = Anims.createWSprite("img/rocket_sheet_vert.png", 150, 64, 0.075)
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
    Visor.rocket.anim:update(dt)

    for i=1,#Visor.bgLayers do
        local l = Visor.bgLayers[i]
        l.x = l.x - l.speed * dt
        while l.x < -l.w do
            l.x = l.x + l.w
        end
    end
end

function Visor.draw()
    love.graphics.setColor(255,255,255)

    for i=1,#Visor.bgLayers do
        local l = Visor.bgLayers[i]
        love.graphics.draw(l.img, l.x + l.w)
        love.graphics.draw(l.img, l.x)
    end

    Visor.rocket.anim:draw(0,20)
end