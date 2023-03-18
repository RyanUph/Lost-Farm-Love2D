stones = {}
logs = {}

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    require('src/player')
    require('src/loadMap')
    wf = require('libraries/windfield')
    camera = require('libraries/camera')

    gameState = 1

    world = wf.newWorld(0, 0)
    cam = camera()
    loadMap('testMap')
    player.load()

    -- Player colliders
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    sprites = {}
    sprites.stone = love.graphics.newImage('sprites/Objects/stone.png')
    sprites.log = love.graphics.newImage('sprites/Objects/log.png')
    sprites.background = love.graphics.newImage('sprites/UI/background.png')

    -- Resources
    createStone(500, 500)
    createStone(800, 700)
    createLog(700, 900)
    createLog(1000, 800)

    -- GUI
    font = love.graphics.newFont('fonts/pixel.ttf', 30)
    startText1 = love.graphics.newText(font, "USE 'WASD' to move")
    startText2 = love.graphics.newText(font, "Use 'E' to destroy")
    startText3 = love.graphics.newText(font, "Use 'ESCAPE' to exit")
    startText4 = love.graphics.newText(font, "Press 'SPACE' to start'")
end

function love.update(dt)
    if gameState == 2 then
        world:update(dt)
        player.update(dt)
        cam:lookAt(player.x, player.y)
    end
end

function love.draw()
    if gameState == 2 then
        cam:attach()
        gameMap:drawLayer(gameMap.layers['Grass'])
        gameMap:drawLayer(gameMap.layers['Fences'])
        gameMap:drawLayer(gameMap.layers['Path'])
        gameMap:drawLayer(gameMap.layers['Water'])

        for i, stone in ipairs(stones) do
            love.graphics.draw(sprites.stone, stone.x + 64, stone.y + 64, nil, nil, nil, 128, 128)
        end

        for i, log in ipairs(logs) do
            love.graphics.draw(sprites.log, log.x + 32, log.y + 5, nil, nil, nil, 128, 128)
        end

        player.draw()
        world:draw()
    cam:detach()
    end

    if gameState == 1 then
        love.graphics.draw(sprites.background, 0, 0, nil, 3)
        love.graphics.draw(startText1, 300, 250, nil, 2)
        love.graphics.draw(startText2, 300, 300, nil, 2)
        love.graphics.draw(startText3, 275, 400, nil, 2)
        love.graphics.draw(startText4, 250, 450, nil, 2)
    end
end

-- Functions

function love.keypressed(key)
    if key == 'space' and gameState == 1 then gameState = 2 end
    if key == 'escape' then love.event.quit() end
    if key == 'e' and not attack then attack = true end
end

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- Resources

function createStone(x, y)
    local stone = {}
    stone.x = x
    stone.y = y
    stone.w = 128
    stone.h = 128
    stone.dead = false
    stone.collider = world:newBSGRectangleCollider(stone.x, stone.y, 128, 128, 40)
    stone.collider:setType('static')
    table.insert(stones, stone)
end

function createLog(x, y)
    local log = {}
    log.x = x
    log.y = y
    log.w = 80
    log.h = 25
    log.dead = false
    log.collider = world:newBSGRectangleCollider(log.x, log.y, 80, 25, 10)
    log.collider:setType('static')
    table.insert(logs, log)
end