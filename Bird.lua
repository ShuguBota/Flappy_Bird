Bird = Class{}

local birdImage = love.graphics.newImage('resources/images/bird.png')

function Bird:init(x, y)
    self.x = x
    self.y = y

    --Velocity
    self.dx = 100
    self.dy = 50
end

function Bird:reset()
end

function Bird:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Bird:render()
    love.graphics.draw(birdImage, self.x, self.y)
end

function Bird:collide(pipe)
end