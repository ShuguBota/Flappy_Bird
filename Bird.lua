Bird = Class{}

local GRAVITY = 1.5

function Bird:init()
    self.image = love.graphics.newImage('resources/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH - self.width)/2
    self.y = (VIRTUAL_HEIGHT - self.height)/2

    --Velocity
    --self.dx = 100
    self.dy = 0
end

function Bird:reset()
end

function Bird:update(dt)
    -- in order to make it jump and fall again we can make the gravity in the beginning negative and at some point it will fall again
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -0.5
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collide(pipe)
end