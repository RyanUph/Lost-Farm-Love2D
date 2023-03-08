player = {}
anim8 = require('libraries/anim8')

function player.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    player.x = 540
    player.y = 400
    player.speed = 400
    player.spriteSheet = love.graphics.newImage('sprites/player.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.1)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 4), 0.1)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 2), 0.1)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 3), 0.1)
    player.anim = player.animations.down
end

function player.update(dt)
    playerMovement(dt)
end

function player.draw()
   player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 24, 24)
end

-- Player functions
function playerMovement(dt)
    local isMoving = false
    local vX = 0
    local vY = 0

    if love.keyboard.isDown("d") then
        vX = player.speed
        player.anim = player.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("a") then
        vX = player.speed * -1
        player.anim = player.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("s") then
        vY = player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("w") then
        vY = player.speed * -1
        player.anim = player.animations.up
        isMoving = true
    end

    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    player.anim:update(dt)
    player.collider:setLinearVelocity(vX, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end