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
    love.filesystem.load("lib/box.lua")()
    love.filesystem.load("buttons/anims.lua")()
    love.filesystem.load("buttons/buttons.lua")()
    love.filesystem.load("visor/visor.lua")()

    initScreen()

    Buttons.init()
    Visor.init()
end

function initScreen()
    ScreenSize = Vector(400,300)
    -- ViewSize = Vector(1200, 900)
    ViewSize = Vector(800, 600)
    -- ViewSize = Vector(400,300)
    if love.graphics.getWidth() ~= ViewSize.x or love.graphics.getHeight() ~= ViewSize.y then
        love.window.setMode(ViewSize.x,ViewSize.y)
    end
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function reset()
    math.randomseed( os.time() )
    for i=1,10 do
        math.random()
    end

    Buttons.reset()
    Visor.reset()
end

function love.update(dt)
    Buttons.update(dt)
    Visor.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(ViewSize.x / ScreenSize.x, ViewSize.y / ScreenSize.y)
        -- draw top
        Visor.draw()

        -- draw bottom
        love.graphics.setColor(32, 32, 32)
        love.graphics.rectangle("fill",0,128,400,172)


        Buttons.draw()

    love.graphics.pop()
end

function love.mousepressed(x,y)
    Buttons.pressAt(Vector(x,y) ^ ScreenSize / ViewSize)
end

function love.mousereleased(x,y)
    Buttons.release()
end