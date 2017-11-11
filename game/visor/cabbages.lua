Cabbages = Cabbages or {}

function Cabbages.init()
    local img = love.graphics.newImage("img/cabbages.png")
    Cabbages.sprites = {}
    Cabbages.layers = {
        {
            batch = love.graphics.newSpriteBatch( img, 1000 ),
            ndxs = {1,2,5,6},
            x = 0,
            speed = 180,
        },
        {
            batch = love.graphics.newSpriteBatch( img, 1000 ),
            ndxs = {3,4},
            x = 0,
            speed = 210,
        },
    }

    local fw, fh = 64, 64
    local xc = math.floor(img:getWidth() / fw)
    local yc = math.floor(img:getHeight() / fh)

    for y=0,yc-1 do
        for x=0,xc-1 do
            table.insert(Cabbages.sprites,
                love.graphics.newQuad(x*fw, y*fh, fw, fh, img:getWidth(), img:getHeight()))
        end
    end
end

function Cabbages.reset()
    local taboo = {}

    local function getNewPos()
        local tries = 40
        local pos = false
        while not pos do
            tries = tries - 1
            pos = Vector(math.random(400) - 32, math.random(128) - 32)
            for _,tb in ipairs(taboo) do
                if BoxFromVectors(pos, pos + Vector(64, 64)):intersects(tb) then
                    pos = false
                    break
                end
            end

            if tries <= 0 then return false end
        end

        return pos
    end

    for li,l in ipairs(Cabbages.layers) do
        l.batch:clear()
        for i=1,li * 3 + 2 do
            local f = l.ndxs[math.random(#l.ndxs)]

            local pos = getNewPos()

            if pos then
                l.batch:add(Cabbages.sprites[f], pos.x, pos.y)
                table.insert(taboo, BoxFromVectors(pos, pos + Vector(64,64)))
            end
        end
    end
end

function Cabbages.update(dt)
    for _,l in ipairs(Cabbages.layers) do
        l.x = l.x - l.speed * dt
        if l.x < -400 then l.x = l.x + 400 end
    end
end

function Cabbages.draw()
    love.graphics.setColor(255,255,255)
    for _,l in ipairs(Cabbages.layers) do
        love.graphics.draw(l.batch, l.x)
        love.graphics.draw(l.batch, l.x + 400)
    end
end
