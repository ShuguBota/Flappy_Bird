EndState = Class{__includes = BaseState}

local scoreReward = {
    ['gold'] = love.graphics.newImage('resources/images/gold.png'),
    ['silver'] = love.graphics.newImage('resources/images/silver.png'),
    ['bronze'] = love.graphics.newImage('resources/images/bronze.png')
}

function EndState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        -- reset the stuff for a new run?
        score = 0
        bird:reset()

        gStateMachine:change('countdown')
    end
end

function EndState:render()
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Oh no, you hit something', 0, VIRTUAL_HEIGHT/2 - 80, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to play again', 0, VIRTUAL_HEIGHT/2 - 60, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Here is your reward', 0, VIRTUAL_HEIGHT/2 - 40, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Your score: ' .. tostring(score), 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')

    if score < 10 then
        love.graphics.draw(scoreReward['bronze'], VIRTUAL_WIDTH/2 - 30, VIRTUAL_HEIGHT/2 + 30, 0, 0.1, 0.1, 0, 0)
    elseif score < 20 then
        love.graphics.draw(scoreReward['silver'], VIRTUAL_WIDTH/2 - 30, VIRTUAL_HEIGHT/2 + 30, 0, 0.1, 0.1, 0, 0)
    else
        love.graphics.draw(scoreReward['gold'], VIRTUAL_WIDTH/2 - 30, VIRTUAL_HEIGHT/2 + 30, 0, 0.1, 0.1, 0, 0)
    end  
end