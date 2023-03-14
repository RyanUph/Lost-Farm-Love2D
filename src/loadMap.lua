sti = require('libraries/sti')

function loadMap(mapName)
    gameMap = sti('maps/' .. mapName .. '.lua')

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
            local stone = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 40)
            print(stone:getX(), stone:getY(), obj.width, obj.height)
            stone:setType('static')
            stone.x = obj.x
            stone.y = obj.y
            stone.w = obj.width
            stone.h = obj.height
            stone.salvage = {}
            stone.salvage[SALVAGE_TYPES.ROCKS] = 5
            stone.salvage[SALVAGE_TYPES.DIRT] = 2
            table.insert(stones, stone)
        end
    end
end