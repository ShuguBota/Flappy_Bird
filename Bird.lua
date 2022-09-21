Bird = Class{}

local GRAVITY = 1.5

function Bird:init()
    self.image = love.graphics.newImage('resources/images/bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = (VIRTUAL_WIDTH - self.width)/2
    self.y = (VIRTUAL_HEIGHT - self.height)/2

    --Velocity
    self.dy = 0
end

function Bird:reset()
    self.x = (VIRTUAL_WIDTH - self.width)/2
    self.y = (VIRTUAL_HEIGHT - self.height)/2
    self.dy = 0

    pipePairs = {}
    spawnTimer = 0
    lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function Bird:update(dt)
    -- in order to make it jump and fall again we can make the gravity in the beginning negative and at some point it will fall again
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        sounds['jump']:play()
        self.dy = -0.5
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collide(pipe)
    -- 4 and 2 are put so the colliding box is smaller than the bird, so the game is more forgiving
    if self.x + 2  <= pipe.x + pipe.width and
       self.x + self.width - 2 >= pipe.x and
       self.y + 4 <= pipe.y + pipe.height and
       self.y + self.height - 4 >= pipe.y then
        return true
    else
        return false
    end
end