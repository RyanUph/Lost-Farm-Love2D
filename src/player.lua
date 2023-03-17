player = {}
bullets = {}
anim8 = require('libraries/anim8')

function player.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    player.x = 540
    player.y = 400
    player.speed = 500
    player.spriteSheet = love.graphics.newImage('sprites/Player/player.png')
    player.actionSheet = love.graphics.newImage('sprites/Player/playerActions.png')
    player.grid = anim8.newGrid(48, 48, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.actionGrid = anim8.newGrid(48, 48, player.actionSheet:getWidth(), player.actionSheet:getHeight())

    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-4', 1), 0.1)
    player.animations.right = anim8.newAnimation(player.grid('1-4', 4), 0.1)
    player.animations.up = anim8.newAnimation(player.grid('1-4', 2), 0.1)
    player.animations.left = anim8.newAnimation(player.grid('1-4', 3), 0.1)
    player.animations.axeDown = anim8.newAnimation(player.actionGrid('1-2', 5), 0.1)
    player.animations.axeUp = anim8.newAnimation(player.actionGrid('1-2', 6), 0.1)
    player.animations.axeRight = anim8.newAnimation(player.actionGrid('1-2', 8), 0.1)
    player.animations.axeLeft = anim8.newAnimation(player.actionGrid('1-2', 7), 0.1)
    player.anim = player.animations.down

    facingRight = false
    facingLeft = false
    facingDown = true
    facingUp = false
end

function player.update(dt)
    playerMovement(dt)
    bulletMovement(dt)
    destroyBullet(dt)

    destroyStone(dt)
    destroyLog(dt)
end

function player.draw()
   player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 24, 24)

   for i, bullet in ipairs(bullets) do
        love.graphics.rectangle('fill', bullet.x, bullet.y, 10, 10)
   end
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

        facingRight = true
        facingDown = false
        facingLeft = false
        facingUp = false
    end

    if love.keyboard.isDown("a") then
        vX = player.speed * -1
        player.anim = player.animations.left
        isMoving = true

        facingRight = false
        facingDown = false
        facingLeft = true
        facingUp = false
    end

    if love.keyboard.isDown("s") then
        vY = player.speed
        player.anim = player.animations.down
        isMoving = true

        facingRight = false
        facingDown = true
        facingLeft = false
        facingUp = false
    end

    if love.keyboard.isDown("w") then
        vY = player.speed * -1
        player.anim = player.animations.up
        isMoving = true

        facingRight = false
        facingDown = false
        facingLeft = false
        facingUp = true
    end

    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    -- Updating animations
    -- Updating colliders position
    player.anim:update(dt)
    player.collider:setLinearVelocity(vX, vY)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
end

-- Bullet functions

function spawnBullet()
    local bullet = {}
    bullet.x = player.x
    bullet.y = player.y
    bullet.speed = 800
    bullet.dead = false

    if facingRight then bullet.direction = 1 end
    if facingLeft then bullet.direction = 2 end
    if facingDown then bullet.direction = 3 end
    if facingUp then bullet.direction = 4 end

    table.insert(bullets, bullet)
end

function bulletMovement(dt)
    for i, bullet in ipairs(bullets) do
        if bullet.direction == 1 then bullet.x = bullet.x + bullet.speed * dt end
        if bullet.direction == 2 then bullet.x = bullet.x - bullet.speed * dt end
        if bullet.direction == 3 then bullet.y = bullet.y + bullet.speed * dt end
        if bullet.direction == 4 then bullet.y = bullet.y - bullet.speed * dt end
    end
end

function destroyBullet(dt)
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        local gx, gy = cam:worldCoords(0, 0)
        local gw, gh = cam:worldCoords(love.graphics.getWidth(), love.graphics.getHeight())
        if b.x < gx - 10 or b.y < gy - 10 or b.x > gw + 10 or b.y > gh + 10 then
            table.remove(bullets, i)
        end
    end
end

-- Stone functions

function destroyStone(dt)
    for i, bullet in ipairs(bullets) do
        for j, stone in ipairs(stones) do
            if distanceBetween(bullet.x, bullet.y, stone.x, stone.y) < 30 then
                bullet.dead = true
                stone.dead = true
            end
        end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then table.remove(bullets, i) end
    end

    for i = #stones, 1, -1 do
        local s = stones[i]
        if s.dead == true then
            table.remove(stones, i)
            s.collider:destroy()
        end
    end
end

-- Logs functions

function destroyLog(dt)
    for i, bullet in ipairs(bullets) do
        for j, log in ipairs(logs) do
            if distanceBetween(bullet.x, bullet.y, log.x, log.y) < 30 then
                bullet.dead = true
                log.dead = true
            end
        end
    end

    for i = #bullets, 1, -1 do
        local b = bullets[i]
        if b.dead == true then table.remove(bullets, i) end
    end

    for i = #logs, 1, -1 do
        local l = logs[i]
        if l.dead == true then
            table.remove(logs, i)
            l.collider:destroy()
        end
    end
end