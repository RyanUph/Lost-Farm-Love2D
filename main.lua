function love.load()
    require('src/player')
    wf = require('libraries/windfield')
    sti = require('libraries/sti')
    camera = require('libraries/camera')

    world = wf.newWorld(0, 0)
    gameMap = sti('maps/lostFarm1.lua')
    cam = camera()
    player.load()

    -- Player colliders
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)

    -- Border colliders
    borders = {}
    if gameMap.layers["Borders"] then
        for i, obj in pairs(gameMap.layers["Borders"].objects) do
            border = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            border:setType('static')
            table.insert(borders, border)
        end
    end

    stones = {}
    if gameMap.layers["Stones"] then
        for i, obj in pairs(gameMap.layers["Stones"].objects) do
            stone = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 40)
            stone:setType('static')
            table.insert(stones, stone)
        end
    end

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