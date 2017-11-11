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