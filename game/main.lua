require "lib/livecode"

function love.load()
    init()
    reset()
end

function love.livereload()
    init()
    reset()
end

function init()
    love.filesystem.load("lib/vector.lua")()
    love.filesystem.load("buttons/anims.lua")()
    love.filesystem.load("buttons/buttons.lua")()

    initScreen()

    Buttons.init()
end

function initScreen()
    ScreenSize = Vector(400,300)
    if love.graphics.getWidth() ~= 400 or love.graphics.getHeight() ~= 300 then
        love.window.setMode(400,300)
    end
end

function reset()
    Buttons.reset()
end

function love.update(dt)
    Buttons.update(dt)
end

function love.draw()
    -- draw top
    love.graphics.setColor(128,128,128)
    love.graphics.rectangle("fill",0,0,400,128)

    -- draw bottom
    love.graphics.setColor(32, 32, 32)
    love.graphics.rectangle("fill",0,128,400,172)


    Buttons.draw()
end

function love.mousepressed(x,y)
    Buttons.pressAt(Vector(x,y))
end

function love.mousereleased(x,y)
    Buttons.release()
end