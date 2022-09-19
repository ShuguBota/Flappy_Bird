push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'

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

local pipes = {}

function love.load()
    -- for the image to not be blury
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

    love.window.setTitle('Flappy bird')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

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

    bird:render()

    for k, pipe in pairs(pipes) do
        pipe:render()
    end

    push:finish()
end

function love.update(dt)
    -- making the image to move
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED) % GROUND_LOOPING_POINT

    spawnTimer = spawnTimer + dt

    if spawnTimer > 2  then
        spawnTimer = 0
        -- adding a new Pipe to the table of pipes
        table.insert(pipes, Pipe())
        spawnTimer = 0
    end

    for k, pipe in pairs(pipes) do
        pipe:update(dt)
        -- make sure we delete those out of the screen
        if pipe.x < - pipe.width then
            table.remove(pipes, k)
        end
    end

    bird:update(dt)
    -- reseting the table so we don't have anything from last update
    love.keyboard.keysPressed = {}
end