General = General or {}

function General.init()
    General.ovrb4 = love.graphics.newImage("img/overlay.png")
    General.ovraf = love.graphics.newImage("img/overlay_after.png")
end

function General.reset()
    General.timer = 6
end

function General.update(dt)
    General.timer = General.timer - dt
end

function General.draw()

end

function General.drawOverlay()
    love.graphics.setColor(255,255,255)
    if General.timer > 0 then
        love.graphics.draw(General.ovrb4)
    else
        love.graphics.draw(General.ovraf)
    end
end