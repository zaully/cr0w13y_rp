function createUser(identifier, callback)
    MySQL.Async.execute("INSERT INTO " .. kTableName .. " (identifier) VALUES (@identifier)",
      { ['@identifier'] = identifier }, function()
        getPlayerDataFromDB(identifier, callback)
    end)
end

RegisterServerEvent('cr:playerFirstSpawned')
AddEventHandler('cr:playerFirstSpawned', function()
    local playerSrc = source
    local identifier = getPlayerIDFromSource(source)
    getPlayerDataFromDB(identifier, function(record)
        if(record)then
          TriggerEvent('cr:playerSignedIn', identifier, record, playerSrc)
        else
          createUser(identifier, function(record)
              TriggerEvent('cr:playerSignedIn', identifier, record, playerSrc)
          end)
        end
    end)
end)

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    local identifier = getPlayerIDFromSource(source)
    TriggerEvent('cr:playerLoggedOff', identifier)
    debugp(identifier .. " logged off")
end)

RegisterServerEvent('cr:log')
AddEventHandler('cr:log', function(log)
    debugp(log)
end)