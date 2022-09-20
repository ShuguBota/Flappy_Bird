EndState = Class{__includes = BaseState}

function EndState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
        -- reset the stuff for a new run?
        score = 0
        bird:reset()
    end
end

function EndState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oh no, you hit something', 0, VIRTUAL_HEIGHT/2 - 40, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to play again', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Your score: ' .. tostring(score), 0, VIRTUAL_HEIGHT/2 + 40, VIRTUAL_WIDTH, 'center')
end