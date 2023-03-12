require('src/player')
require('src/loadMap')
stones = {}
logs = {}

function love.load()
    wf = require('libraries/windfield')
    camera = require('libraries/camera')

    gameState = 2

    world = wf.newWorld(0, 0)
    cam = camera()
    loadMap('testMap')
    player.load()

    -- Player colliders
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    sprites = {}
    sprites.stone = love.graphics.newImage('sprites/stone.png')
    sprites.log = love.graphics.newImage('sprites/log.png')

    createStone(500, 500)
    createStone(800, 700)
    createLog(700, 900)
    createLog(1000, 800)
end

function love.update(dt)
    if gameState == 2 then
        player.update(dt)
        cam:lookAt(player.x, player.y)
        world:update(dt)
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
            love.graphics.draw(sprites.stone, stone.x, stone.y, nil, nil, nil, 128, 128)
        end

        for i, log in ipairs(logs) do
            love.graphics.draw(sprites.log, log.x, log.y, nil, nil, nil, 128, 128)
        end

        player.draw()
        world:draw()
    cam:detach()
    end
end

-- Functions

function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1) ^ 2 + (y2 - y1) ^ 2)
end

-- Resources

function createStone(x, y)
    local stone = {}
    stone.x = x
    stone.y = y
    stone.dead = false
    stone.collider = world:newBSGRectangleCollider(stone.x - 64, stone.y - 64, 128, 128, 40)
    stone.collider:setType('static')
    table.insert(stones, stone)
end

function createLog(x, y)
    local log = {}
    log.x = x
    log.y = y
    log.dead = false
    log.collider = world:newBSGRectangleCollider(log.x - 32, log.y - 5, 80, 25, 10)
    log.collider:setType('static')
    table.insert(logs, log)
end