require('src/player')
require('src/loadMap')

function love.load()
    acc = 0
    love.graphics.setDefaultFilter('nearest', 'nearest')
    wf = require('libraries/windfield')
    camera = require('libraries/camera')
    lockCamera = false

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
    world:update(dt)
    player.update(dt)
    cam:lookAt(player.x, player.y)
    if lockCamera then
        local sw, sh = love.graphics.getWidth(), love.graphics.getHeight()
        local mapw, maph = gameMap.width * gameMap.tilewidth, gameMap.height * gameMap.tileheight
        if cam.x < sw/2 then cam.x = sw/2 end
        if cam.y < sh/2 then cam.y = sh/2 end
        if cam.x > mapw + gameMap.tilewidth + 32 then cam.x = mapw + gameMap.tilewidth + 32 end
        if cam.y > maph + gameMap.tileheight + 32 then cam.y = maph + gameMap.tileheight + 32 end
    end
    acc = acc + dt
    if acc > 1 then
        acc = acc - 1
        print(cam:worldCoords(love.mouse.getPosition()))
    end
end

function love.draw()
    cam:attach()
        gameMap:drawLayer(gameMap.layers['Grass'])
        gameMap:drawLayer(gameMap.layers['Path'])
        gameMap:drawLayer(gameMap.layers['Fences'])
        gameMap:drawLayer(gameMap.layers['Water'])

        for _, stone in ipairs(stones) do
            love.graphics.draw(sprites.stone, stone:getX(), stone:getY(), 0, 1, 1, sprites.stone:getWidth()/2, sprites.stone:getHeight()/2)
        end

        player.draw()
        world:draw()
    cam:detach()
end

function love.keypressed(key)
    if key == "c" then
        lockCamera = not lockCamera
        print(lockCamera)
    end
    if key == "m" then
        print(gameMap.width, gameMap.height, gameMap.tilewidth, gameMap.tileheight)
    end
    if key == "r" then
        addStone(cam:worldCoords(love.mouse.getPosition()))
    end
end

function addStone(x, y, width, height)
    local x, y, width, height = x or 0, y or 0, width or 128, height or 128
    stone = world:newBSGRectangleCollider(x, y, width, height, 40)
    print(stone:getX(), stone:getY())
    stone:setType('static')
    table.insert(stones, stone)
end