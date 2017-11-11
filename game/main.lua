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
    rerandomize()
    love.filesystem.load("lib/vector.lua")()
    love.filesystem.load("lib/box.lua")()
    love.filesystem.load("buttons/anims.lua")()
    love.filesystem.load("buttons/buttons.lua")()
    love.filesystem.load("visor/visor.lua")()
    love.filesystem.load("visor/hand.lua")()
    love.filesystem.load("visor/cabbages.lua")()
    love.filesystem.load("general/general.lua")()

    initScreen()

    Buttons.init()
    Visor.init()
    Hand.init()
    General.init()
end

function initScreen()
    ScreenSize = Vector(400,300)
    -- ViewSize = Vector(800, 600)
    ViewSize = Vector(400,300)
    ViewSize = Vector(1200, 900)
    if love.graphics.getWidth() ~= ViewSize.x or love.graphics.getHeight() ~= ViewSize.y then
        love.window.setMode(ViewSize.x,ViewSize.y)
    end
    love.graphics.setDefaultFilter("nearest", "nearest")
end

function rerandomize()
    math.randomseed( os.time() )
    for i=1,10 do
        math.random()
    end
end

function reset()
    rerandomize()

    Buttons.reset()
    Visor.reset()
    Hand.reset()
    General.reset()
end

function love.update(dt)
    Buttons.update(dt)
    Visor.update(dt)
    Hand.update(dt)
    General.update(dt)
end

function love.draw()
    love.graphics.push()
    love.graphics.scale(ViewSize.x / ScreenSize.x, ViewSize.y / ScreenSize.y)
        -- draw top
        Visor.draw()

        -- draw bottom
        Buttons.draw()
        Hand.draw()

        General.drawOverlay()

    love.graphics.pop()
end

function love.mousepressed(x,y)
    Buttons.pressAt(Vector(x,y) ^ ScreenSize / ViewSize)
end

function love.mousereleased(x,y)
    Buttons.release()
end

function launchGameover()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
        return
    end

    Hand.keypressed(key)
end

function love.keyreleased(key)
    Hand.keyreleased(key)
end

