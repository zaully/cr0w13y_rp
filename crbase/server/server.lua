function getPlayerIDFromSource(strSource)
    local identifiers = GetPlayerIdentifiers(tonumber(strSource))
    local identifier = getIdentifiant(identifiers)
    return identifier
end

function getIdentifiant(ids)
    for _, v in ipairs(ids) do
        return v
    end
end

function debugp(log)
  print("----------" .. log .. "----------")
end

RegisterServerEvent('playerDropped')
AddEventHandler('playerDropped', function()
    local identifier = getPlayerIDFromSource(source)
    saveCachedPlayerLocation(identifier)
    debugp(identifier .. " logged off")
end)

RegisterServerEvent('cr:log')
AddEventHandler('cr:log', function(log)
    debugp(log)
end)