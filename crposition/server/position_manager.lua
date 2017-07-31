playersLocationCache = {}

function positionMapToString(positionMap)
  return "{" .. positionMap.x .. ", " .. positionMap.y .. ",  " .. positionMap.z .. ", " .. positionMap.h .. "}"
end

function stringToPositionMap(positionMapString)
  local posArray = json.decode(positionMapString)
  return {['x'] = posArray[1], ['y'] = posArray[2], ['z'] = posArray[3], ['h'] = posArray[4]}
end

function savePlayerPosition(identifier, positionMap)
  MySQL.Async.execute("update users set cr_player_position=@player_position WHERE identifier = @identifier", {
      ['@player_position'] = positionMapToString(positionMap),
      ['@identifier'] = identifier}, function (result)
  end)
end

function getPlayerPosition(identifier, callback)
  MySQL.Async.fetchScalar("SELECT cr_player_position FROM users WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (result)
      if result ~= nil then
        callback(stringToPositionMap(result))
      else
        callback(nil)
      end
  end)
end

function saveCachedPlayerLocation(identifier)
    if (playersLocationCache[identifier] ~= nil) then
      savePlayerPosition(identifier, playersLocationCache[identifier])
      playersLocationCache[identifier] = nil
      debugp(identifier .. " location saved")
    end
end

AddEventHandler('cr:playerSignedIn', function(identifier, record, src)
    if (record.cr_player_position) then
      local pos = stringToPositionMap(record.cr_player_position)
      TriggerClientEvent('cr:movePlayer', src, pos)
      playersLocationCache[identifier] = pos
    end
end)

AddEventHandler('cr:playerLoggedOff', function(identifier)
    saveCachedPlayerLocation(identifier)
end)