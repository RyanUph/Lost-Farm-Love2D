function love.load()
    require('src/player')
    require('src/loadMap')
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

        drawStone(500, 500)
        drawStone(500, 100)
        drawStone(100, 500)
        drawStone(800, 700)

        player.draw()
        world:draw()
    cam:detach()
end

-- Functions
function drawStone(x, y)
    stone = {}
    stone.x = x
    stone.y = y
    love.graphics.draw(sprites.stone, stone.x, stone.y, nil, nil, nil, 64, 64)

    table.insert(stones, stone)
end