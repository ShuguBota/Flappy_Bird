TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Welcome to Flappy Bird', 0, VIRTUAL_HEIGHT/2 - 20, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to play', 0, VIRTUAL_HEIGHT/2 + 20, VIRTUAL_WIDTH, 'center')
end