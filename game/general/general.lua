General = General or {}

function General.init()
    General.overlay = love.graphics.newImage("img/overlay2.png")

    General.gameoverAnim = Anims.createWSprite("img/explosion_gameover.png", 400, 300, 0.05, 17)
    General.gameoverStatic = love.graphics.newImage("img/gameover.png")
    General.gameoverAnim.onEndCallback = function()
        General.animGameover = false
        General.showGameoverStatic = true
        General.gameEnded = true
    end

    General.startOverlayDelay = 1.5
end

function General.reset()
    General.showGameover = false
    General.animGameover = false
    General.showGameoverStatic = false

    General.gameEnded = false

    General.startOverlayTimer = General.startOverlayDelay
end

function General.doGameover()
    General.showGameover = true
    General.animGameover = true
    General.showGameoverStatic = false
    General.gameoverAnim:reset()
end

function General.update(dt)

    if General.animGameover then
        General.gameoverAnim:update(dt)
    end

    if General.startOverlayTimer > 0 then
        General.startOverlayTimer = General.startOverlayTimer - dt
    end
end

function General.draw()
end


function General.drawGameOver()

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
    love.graphics.draw(General.overlay)

    if General.startOverlayTimer > 0 then
        love.graphics.setColor(0,0,0,General.startOverlayTimer / General.startOverlayDelay * 255)
        love.graphics.rectangle("fill",0,0,400,300)
    end
end