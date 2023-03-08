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
            stone = world:newBSGRectangleCollider(obj.x, obj.y, obj.width, obj.height, 40)
            stone:setType('static')
            table.insert(stones, stone)
        end
    end
end