function love.load()
    require('src/player')
    wf = require('libraries/windfield')
    sti = require('libraries/sti')
    camera = require('libraries/camera')

    world = wf.newWorld(0, 0)
    cam = camera()
    player.load()

    -- Player collider
    player.collider = world:newBSGRectangleCollider(player.x, player.y, 55, 80, 10)
    player.collider:setFixedRotation(true)
end

function love.update(dt)
    player.update(dt)
    cam:lookAt(player.x, player.y)
    world:update(dt)
end

function love.draw()
    cam:attach()
        player.draw()
        world:draw()
    cam:detach()
end