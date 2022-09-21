CountDownState = Class{__includes = BaseState}

local time = 0

function CountDownState:update(dt)
    if time > 3 then
        gStateMachine:change('play')
        time = 0
    end

    time = time + dt
end

function CountDownState:render()
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(3 - math.ceil(time) + 1), 0, VIRTUAL_HEIGHT/2 - 20, VIRTUAL_WIDTH, 'center')
end