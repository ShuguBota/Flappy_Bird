PipePair = Class{}

require 'Pipe'

local PIPE_GAP = 110

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + PIPE_GAP)
    }

    self.remove = false
    self.point = false
end

function PipePair:update(dt)
    if self.x > - PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
    
    if self.x <= VIRTUAL_WIDTH/2 - 32 and self.point == false then
        self.point = true
        score = score + 1
        sounds['score']:play()
    end
end

function PipePair:render()
    for k, pipe in pairs(self.pipes) do
        pipe:render()
    end
end