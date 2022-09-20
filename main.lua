push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

--local variables can only be accessed in this fil 
local background = love.graphics.newImage('resources/images/background.png')
local ground = love.graphics.newImage('resources/images/ground.png')

-- Used in order to make the image in the background move
local backgroundScroll = 0
local groundScroll = 0

local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60

local BACKGROUND_LOOPING_POINT = 413
local GROUND_LOOPING_POINT = 512

-- timer for when to spawn the pipes
local spawnTimer = 0

local pipePairs = {}
local lastY = -PIPE_HEIGHT + math.random(80) + 20

local gameOver = false

function love.load()
    -- for the image to not be blury
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flappy bird')

    -- fonts
    smallFont = love.graphics.newFont('resources/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('resources/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('resources/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('resources/fonts/flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['play'] = function() return PlayState() end
    } 
    gStateMachine:change('title')

    love.keyboard.keysPressed = {}
    
    bird = Bird()
end

function love.resize(width, height)
    push:resize(width, height)
end

function love.keypressed(key)
    -- we store the key pressed into a table
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

-- function to check if we pressed a key
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    push:start()
    -- takes a drawable, and the position we want to draw it at
    love.graphics.draw(background, -backgroundScroll, 0)
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    for k, pipes in pairs(pipePairs) do
        pipes:render()
    end

    bird:render()

    push:finish()
end

function love.update(dt)
    -- making the image to move
    if gameOver == false then
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED) % GROUND_LOOPING_POINT

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

    -- reseting the table so we don't have anything from last update
    love.keyboard.keysPressed = {}
end

function checkColission()
    -- colission with top screen
    if bird.y < 0 then
        print("Bird hit top")
        gameOver = true
    end

    if bird.y > VIRTUAL_HEIGHT - bird.height then
        print("Bird hit bottom")
        gameOver = true
    end

    for k, pipes in pairs(pipePairs) do
        if bird:collide(pipes.pipes['upper']) or bird:collide(pipes.pipes['lower']) then
            print("Bird hit pipe")
            gameOver = true
        end
    end
end