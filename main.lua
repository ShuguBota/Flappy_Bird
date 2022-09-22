push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'
require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/EndState'
require 'states/CountDownState'

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
        ['play'] = function() return PlayState() end,
        ['end'] = function() return EndState() end,
        ['countdown'] = function() return CountDownState() end
    } 
    gStateMachine:change('title')

    sounds = {
        ['explosion'] = love.audio.newSource('resources/sounds/explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('resources/sounds/hurt.wav', 'static'),
        ['jump'] = love.audio.newSource('resources/sounds/jump.wav', 'static'),
        ['score'] = love.audio.newSource('resources/sounds/score.wav', 'static'),
        ['marios_way'] = love.audio.newSource('resources/sounds/marios_way.mp3', 'stream')
    }

    sounds['marios_way']:setLooping(true)
    sounds['marios_way']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    
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

function love.mousepressed(x, y, button, istouch, presses)
    love.mouse.keysPressed[button] = true
end

-- function to check if we pressed a key
function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.draw()
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    -- takes a drawable, and the position we want to draw it at
    love.graphics.draw(background, -backgroundScroll, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)
    push:finish()
end

function love.update(dt)
    -- making the image to move
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED) % GROUND_LOOPING_POINT
    
    gStateMachine:update(dt)

    -- reseting the table so we don't have anything from last update
    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
end