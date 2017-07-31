RegisterServerEvent('cr:savePlayerLocation')
AddEventHandler('cr:savePlayerLocation', function(posMap)
    local identifier = getPlayerIDFromSource(source)
    playersLocationCache[identifier] = posMap
    savePlayerPosition(identifier, posMap)
end)

RegisterServerEvent('cr:playerLocationUpdated')
AddEventHandler('cr:playerLocationUpdated', function(posMap)
    local identifier = getPlayerIDFromSource(source)
    playersLocationCache[identifier] = posMap
end)