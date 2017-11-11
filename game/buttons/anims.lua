Anims = Anims or {}

local function animReset(self)
    self.timer = 0
    self.frame = 0
end

local function animUpdate(self, dt)
    self.timer = self.timer + dt
    while self.timer > self.frameDelay do
        self.timer = self.timer - self.frameDelay
        self.frame = (self.frame % self.frameCount) + 1
    end
end

function Anims.create(frameDelay, frameCount)
    local newAnim = {
        timer = 0,
        frame = 1,
        frameDelay = frameDelay,
        frameCount = frameCount,
        update = animUpdate,
        reset = animReset
    }

    return newAnim
end

local function animDraw(self, x, y)
    self.batch:clear()
    self.batch:add(self.sprites[self.frame])
    love.graphics.draw(self.batch, x, y)
end

function Anims.createWSprite(imgFile, fw, fh, frameDelay)
    local img = love.graphics.newImage(imgFile)
    local batch = love.graphics.newSpriteBatch( img, 1000 )
    local sprites = {}

    local xc = math.floor(img:getWidth() / fw)
    local yc = math.floor(img:getHeight() / fh)

    for y=0,yc-1 do
        for x=0,xc-1 do
            table.insert(sprites,
                love.graphics.newQuad(x*fw, y*fh, fw, fh, img:getWidth(), img:getHeight()))
        end
    end

    local an = Anims.create(frameDelay, #sprites)

    an.batch = batch
    an.sprites = sprites
    an.draw = animDraw

    return an
end