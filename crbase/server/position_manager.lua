local playersLocationCache = {}


function positionMapToString(positionMap)
  return "{" .. positionMap.x .. ", " .. positionMap.y .. ",  " .. positionMap.z .. ", " .. positionMap.h .. "}"
end

function stringToPositionMap(positionMapString)
  local posArray = json.decode(positionMapString)
  return {['x'] = posArray[1], ['y'] = posArray[2], ['z'] = posArray[3], ['h'] = posArray[4]}
end

function savePlayerPosition(identifier, positionMap)
  MySQL.Async.execute("update users set player_position=@player_position WHERE identifier = @identifier", {
      ['@player_position'] = positionMapToString(positionMap),
      ['@identifier'] = identifier}, function (result)
  end)
end

function getPlayerPosition(identifier, callback)
  MySQL.Async.fetchScalar("SELECT player_position FROM users WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (result)
      if result ~= nil then
        callback(stringToPositionMap(result))
      else
        callback(nil)
      end
  end)
end

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

function saveCachedPlayerLocation(identifier)
    if (playersLocationCache[identifier] ~= nil) then
      savePlayerPosition(identifier, playersLocationCache[identifier])
      playersLocationCache[identifier] = nil
      debugp(identifier .. " location saved")
    end
end