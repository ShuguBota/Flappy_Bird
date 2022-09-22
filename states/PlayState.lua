PlayState = Class{__includes = BaseState}

-- timer for when to spawn the pipes
local spawnTimer = 0

pipePairs = {}
lastY = -PIPE_HEIGHT + math.random(80) + 20
timeToSpawn = math.random(2, 5)

score = 0

local pause = false

function PlayState:update(dt)
    if love.keyboard.wasPressed('p') then
        if pause == true then
            pause = false
        else
            pause = true
        end
    end
    
    if pause == false then
        spawnTimer = spawnTimer + dt

        checkColission()

        if spawnTimer > timeToSpawn  then
            tempY = math.max(-PIPE_HEIGHT + 10, math.min(lastY + math.random(-40, 40), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
            lastY = tempY
            spawnTimer = 0
            -- adding a new Pipe to the table of pipes
            table.insert(pipePairs, PipePair(tempY))
            spawnTimer = 0
            timeToSpawn = math.random(2, 5)
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
end

function PlayState:render()
    for k, pipes in pairs(pipePairs) do
        pipes:render()
    end

    bird:render()

    --showing the score
    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(score), 0, 0, VIRTUAL_WIDTH, 'left')
    
    if pause == true then
        love.graphics.setFont(mediumFont)
        love.graphics.printf('Game has been paused. Press P to play', 0, VIRTUAL_HEIGHT / 2 - 5, VIRTUAL_WIDTH, 'center')
    end
end

function checkColission()
    -- colission with top screen
    if bird.y < 0 then
        --print("Bird hit top")
        sounds['hurt']:play()
        sounds['explosion']:play()
        gStateMachine:change('end')
    end

    if bird.y > VIRTUAL_HEIGHT - bird.height then
        --print("Bird hit bottom")
        sounds['hurt']:play()
        sounds['explosion']:play()
        gStateMachine:change('end')
    end

    for k, pipes in pairs(pipePairs) do
        if bird:collide(pipes.pipes['upper']) or bird:collide(pipes.pipes['lower']) then
            --print("Bird hit pipe")
            sounds['hurt']:play()
            sounds['explosion']:play()
            gStateMachine:change('end')
        end
    end
end