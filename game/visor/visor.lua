Visor = Visor or {}

function Visor.init()
    Visor.rocket = {
        anim = Anims.createWSprite("img/rocket_sheet_vert.png", 150, 64, 0.075),
        fall = {
            current = 0,
            dest = 0,
            speed = 50,
            punish = 5,
            reward = 25,
            maximum = 116
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

    Cabbages.init()

    -- Visor.stripes = {
    --     Anims.createWSprite("img/speedstripe1.png", 400, 20, 0.05),
    --     Anims.createWSprite("img/speedstripe2.png", 400, 20, 0.05),
    --     Anims.createWSprite("img/speedstripe1.png", 400, 20, 0.05),
    --     Anims.createWSprite("img/speedstripe2.png", 400, 20, 0.05),
    --     Anims.createWSprite("img/speedstripe1.png", 400, 20, 0.05),
    --     Anims.createWSprite("img/speedstripe2.png", 400, 20, 0.05),

    --     resetTimer = function()
    --         Visor.stripes.timer = 0
    --         Visor.stripes.delay = math.random()*0.8 + 0.05
    --     end
    -- }
    -- for i=1,#Visor.stripes do
    --     Visor.stripes[i].onEndCallback = function(self)
    --         self.visible = false
    --     end
    -- end

end

function Visor.reset()
    Visor.rocket.anim:reset()
    Visor.rocket.fall =  {
            current = 0,
            dest = 0,
            speed = 50,
            punish = 3,
            reward = 20,
            maximum = 136
        }

    Cabbages.reset()

    -- for _,stripe in ipairs(Visor.stripes) do
    --     stripe.visible = false
    -- end

    -- Visor.stripes.resetTimer()
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
    f.dest = math.min(f.dest + f.punish * #Buttons.blinkList * dt, f.maximum)

    -- animate fall
    if f.dest < f.current then
        -- raising
        f.current = math.max(f.current - f.speed * dt, f.dest)
        Buttons.setCurrentVibration(f.current / f.maximum)
    elseif f.dest > f.current then
        -- falling
        f.current = math.min(f.current + f.speed * dt, f.dest)
        Buttons.setCurrentVibration(f.current / f.maximum)

        -- game over?
        if f.current >= f.maximum then
            General.doGameover()
        end
    end


    Cabbages.update(dt)
    -- Visor.updateStripes(dt)
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

    Cabbages.drawBack()

    Visor.rocket.anim:draw(0, Visor.rocket.fall.current)

    Cabbages.drawFront()

    -- Visor.drawStripes()

    love.graphics.setScissor()
end

-- function Visor.updateStripes(dt)
--     for _,stripe in ipairs(Visor.stripes) do
--         if stripe.visible then
--             stripe:update(dt)
--         end
--     end

--     Visor.stripes.timer = Visor.stripes.timer + dt
--     if Visor.stripes.timer >= Visor.stripes.delay then
--         local pool = {}
--         for i = 1,#Visor.stripes do
--             if not Visor.stripes[i].visible then
--                 table.insert(pool, i)
--             end
--         end

--         if #pool > 0 then
--             local ndx = pool[math.random(#pool)]
--             Visor.stripes[ndx].visible = true
--             Visor.stripes[ndx]:reset()
--             Visor.stripes[ndx].y = math.random(128 - 20)
--         end

--         Visor.stripes.resetTimer()
--     end
-- end

-- function Visor.drawStripes()
--     -- love.graphics.setColor(255,255,255,128)
--     for _,stripe in ipairs(Visor.stripes) do
--         if stripe.visible then
--             stripe:draw(0, stripe.y)
--         end
--     end
-- end
