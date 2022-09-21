PlayState = Class{__includes = BaseState}

-- timer for when to spawn the pipes
local spawnTimer = 0

pipePairs = {}
lastY = -PIPE_HEIGHT + math.random(80) + 20

score = 0

function PlayState:update(dt)
    spawnTimer = spawnTimer + dt

    checkColission()

    if spawnTimer > 2  then
        tempY = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = tempY
        spawnTimer = 0
        -- adding a new Pipe to the table of pipes
        table.insert(pipePairs, PipePair(tempY))
        spawnTimer = 0
    end

    for k, pipes in pairs(pipePairs) do
        pipes:update(dt)
        -- make sure we delete those out of the screen
        if pipes.remove == true then
            table.remove(pipes, k)
        end
    end 

    bird:update(dt)
end

function PlayState:render()
    for k, pipes in pairs(pipePairs) do
        pipes:render()
    end

    bird:render()

    --showing the score
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(score), 0, 0, VIRTUAL_WIDTH, 'left')
end

function checkColission()
    -- colission with top screen
    if bird.y < 0 then
        --print("Bird hit top")
        sounds['hurt']:play()
        gStateMachine:change('end')
    end

    if bird.y > VIRTUAL_HEIGHT - bird.height then
        --print("Bird hit bottom")
        sounds['hurt']:play()
        gStateMachine:change('end')
    end

    for k, pipes in pairs(pipePairs) do
        if bird:collide(pipes.pipes['upper']) or bird:collide(pipes.pipes['lower']) then
            --print("Bird hit pipe")
            sounds['hurt']:play()
            gStateMachine:change('end')
        end
    end
end