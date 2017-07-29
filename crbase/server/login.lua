RegisterServerEvent('cr:playerFirstSpawned')
AddEventHandler('cr:playerFirstSpawned', function()
    local playerSrc = source
    local identifier = getPlayerIDFromSource(source)
    getPlayerPosition(identifier, function(pos)
        if(pos ~= nil)then
          TriggerClientEvent('cr:movePlayer', playerSrc, pos)
        else
          MySQL.Async.execute("INSERT INTO users (identifier, player_position) VALUES (@identifier, @player_position)",
            { ['@identifier'] = identifier, ['@player_position'] = positionMapToString(defaultPosition)})
          TriggerClientEvent('cr:movePlayer', playerSrc, defaultPosition)
        end
    end)
end)