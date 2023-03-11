require('src/player')
require('src/loadMap')
stones = {}

function love.load()
    wf = require('libraries/windfield')
    camera = require('libraries/camera')

    world = wf.newWorld(0, 0)
    cam = camera()
    loadMap('lostFarm1')
    player.load()

    -- Player colliders
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    sprites = {}
    sprites.stone = love.graphics.newImage('sprites/stone.png')

    createStone(500, 500)
    createStone(800, 700)
end

function love.update(dt)
    player.update(dt)
    cam:lookAt(player.x, player.y)
    world:update(dt)
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Grass'])
        gameMap:drawLayer(gameMap.layers['Path'])
        gameMap:drawLayer(gameMap.layers['Fences'])
        gameMap:drawLayer(gameMap.layers['Water'])

        for i, stone in ipairs(stones) do
            love.graphics.draw(sprites.stone, stone.x, stone.y, nil, nil, nil, 64, 64)
        end

        player.draw()
        world:draw()
    cam:detach()
end

-- Functions

function createStone(x, y)
    local stone = {}
    stone.x = x
    stone.y = y
    stone.collider = world:newBSGRectangleCollider(stone.x, stone.y, 128, 128, 40)
    stone.collider:setType('static')
    print(stone.x, stone.y)
    table.insert(stones, stone)
end

function love.keypressed(key)
    if key == 'space' then
        createStone()
    end
end