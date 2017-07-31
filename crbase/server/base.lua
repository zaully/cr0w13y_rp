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

function getPlayerData(source, callback)
  getPlayerDataFromDB(getPlayerIDFromSource(source), callback)
end

function getPlayerDataFromDB(identifier, callback)
  MySQL.Async.fetchAll("SELECT * FROM " .. kTableName .. " WHERE identifier = @identifier", { ['@identifier'] = identifier}, function (result)
      if callback then
        callback(result[1])
      end
  end)
end