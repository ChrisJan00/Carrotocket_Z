General = General or {}

function General.init()
    -- General.ovrb4 = love.graphics.newImage("img/overlay.png")
    -- General.ovraf = love.graphics.newImage("img/overlay_after.png")
    General.overlay = love.graphics.newImage("img/overlay2.png")


    General.gameoverAnim = Anims.createWSprite("img/sheet_explosiongameover.png", 400, 300, 0.05)
    General.gameoverStatic = love.graphics.newImage("img/gameover.png")
    General.gameoverAnim.onEndCallback = function()
        General.animGameover = false
        General.showGameoverStatic = true
        General.gameEnded = true
    end
end

function General.reset()
    General.showGameover = false
    General.animGameover = false
    General.showGameoverStatic = false

    General.gameEnded = false
end

function General.doGameover()
    General.showGameover = true
    General.animGameover = true
    General.showGameoverStatic = false
    General.gameoverAnim:reset()
end

function General.update(dt)
    -- General.timer = General.timer - dt

    if General.animGameover then
        General.gameoverAnim:update(dt)
    end
end

function General.draw()
end


function General.drawGameOver()
    -- if General.done then
    --     love.graphics.setColor(255,255,255)
    --     love.graphics.draw(General.gameover)
    -- end

    love.graphics.setColor(255,255,255)
    if General.showGameover then
        if General.animGameover then
            General.gameoverAnim:draw()
        elseif General.showGameoverStatic then
            love.graphics.draw(General.gameoverStatic)
        end
    end
end

function General.drawOverlay()
    love.graphics.setColor(255,255,255)
    -- if General.timer > 0 then
    --     love.graphics.draw(General.ovrb4)
    -- else
    --     love.graphics.draw(General.ovraf)
    -- end
    love.graphics.draw(General.overlay)
end