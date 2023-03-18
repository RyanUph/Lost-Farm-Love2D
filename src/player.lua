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
    player.animations.axeDown = anim8.newAnimation(player.actionGrid('1-2', 5), 0.1, function() attack = false player.anim = player.animations.down player.anim:gotoFrame(1) end)
    player.animations.axeUp = anim8.newAnimation(player.actionGrid('1-2', 6), 0.1, function() attack = false player.anim = player.animations.up player.anim:gotoFrame(1) end)
    player.animations.axeRight = anim8.newAnimation(player.actionGrid('1-2', 8), 0.1, function() attack = false player.anim = player.animations.right player.anim:gotoFrame(1) end)
    player.animations.axeLeft = anim8.newAnimation(player.actionGrid('1-2', 7), 0.1, function() attack = false player.anim = player.animations.left player.anim:gotoFrame(1) end)
    player.anim = player.animations.down

    facingRight = false
    facingLeft = false
    facingDown = true
    facingUp = false
    attack = false

    player.attackHitbox = {x = player.x, y = player.y + 48 * 5, w = 50, h = 50}
end

function player.update(dt)
    playerMovement(dt)
    bulletMovement(dt)
    destroyBullet(dt)

    destroyStone(dt)
    destroyLog(dt)
end

function player.draw()
   if player.anim == player.animations.down or
   player.anim == player.animations.right or
   player.anim == player.animations.up or
   player.anim == player.animations.left then
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, 5, nil, 24, 24)
   else
    player.anim:draw(player.actionSheet, player.x, player.y, nil, 5, nil, 24, 24)
   end

   if attack then
       local prevr, prevg, prevb, preva = love.graphics.getColor()
       love.graphics.setColor(1,0,0,1)
       love.graphics.rectangle("line", player.attackHitbox.x, player.attackHitbox.y, player.attackHitbox.w, player.attackHitbox.h)
       love.graphics.setColor(prevr, prevg, prevb, preva)
    end

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
        if not attack then player.anim = player.animations.right end
        isMoving = true

        facingRight = true
        facingDown = false
        facingLeft = false
        facingUp = false
    end

    if love.keyboard.isDown("a") then
        vX = player.speed * -1
        if not attack then player.anim = player.animations.left end
        isMoving = true

        facingRight = false
        facingDown = false
        facingLeft = true
        facingUp = false
    end

    if love.keyboard.isDown("s") then
        vY = player.speed
        if not attack then player.anim = player.animations.down end
        isMoving = true

        facingRight = false
        facingDown = true
        facingLeft = false
        facingUp = false
    end

    if love.keyboard.isDown("w") then
        vY = player.speed * -1
        if not attack then player.anim = player.animations.up end
        isMoving = true

        facingRight = false
        facingDown = false
        facingLeft = false
        facingUp = true
    end

    if isMoving == false and not attack then
        player.anim:gotoFrame(1)
    end

    
    if attack then checkCollisionsAttack() end

    -- Updating animations
    -- Updating colliders position
    local mag = math.sqrt(vX * vX + vY * vY)
    if mag ~= 0 then vX, vY = vX/mag, vY/mag end
    player.anim:update(dt)
    player.collider:setLinearVelocity(vX * player.speed, vY * player.speed)
    player.x = player.collider:getX()
    player.y = player.collider:getY()

    if facingRight and attack then player.attackHitbox = {x = player.x + 44, y = player.y - 24, w = 50, h = 50} player.anim = player.animations.axeRight end
    if facingLeft and attack then player.attackHitbox = {x = player.x - 94, y = player.y - 24, w = 50, h = 50} player.anim = player.animations.axeLeft end
    if facingDown and attack then player.attackHitbox = {x = player.x - 24, y = player.y + 48, w = 50, h = 50} player.anim = player.animations.axeDown end
    if facingUp and attack then player.attackHitbox = {x = player.x - 24, y = player.y - 98, w = 50, h = 50} player.anim = player.animations.axeUp end
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


local function _checkHitboxAttack(a)
    if a.x + a.w > player.attackHitbox.x and
    a.y + a.h > player.attackHitbox.y and
    a.x < player.attackHitbox.x + player.attackHitbox.w and
    a.y < player.attackHitbox.y + player.attackHitbox.h then
        return true
    end
end

function checkCollisionsAttack()
    for i, stone in ipairs(stones) do
        if _checkHitboxAttack(stone) then stone.dead = true end
    end
    for i, log in ipairs(logs) do
        if _checkHitboxAttack(log) then log.dead = true end
    end
end

-- Logs functions
function destroyStone(dt)
    for i = #stones, 1, -1 do
        local s = stones[i]
        if s.dead == true then
            s.collider:destroy()
            table.remove(stones, i)
        end
    end
end

function destroyLog(dt)
    for i = #logs, 1, -1 do
        local l = logs[i]
        if l.dead == true then
            l.collider:destroy()
            table.remove(logs, i)
        end
    end
end