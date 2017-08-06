carriedWeapons = {}
armory = {}

function TableSize(map)
  local count = 0
  if map ~= nil then
    for _ in pairs(map) do
      count = count + 1
    end
  end
  return count
end

local function SavePlayerWeaponInventory(identifier, carried)
  local jsonString = '{}'
  if TableSize(carried) > 0 then
    jsonString = json.encode(carried)
  end
  debugp(jsonString)
  MySQL.Async.execute("update users set cr_carried_weapons=@carried WHERE identifier = @identifier", {
      ['@carried'] = jsonString,
      ['@identifier'] = identifier}, function (result)
  end)
end

local function StreamWeaponPrices(src)
  debugp(kWeaponPrices["WEAPON_PISTOL"][1] .. " streamed")
  TriggerClientEvent('cr:receiveWeaponPrices', src, kWeaponPrices)
end

function UpdatePlayerCarriedWeapons(identifier, carried)
  for k in pairs(carriedWeapons[identifier]) do
    carriedWeapons[identifier][k] = nil
  end
  for k, v in pairs(carried) do
    carriedWeapons[identifier][k] = v
  end
  SavePlayerWeaponInventory(identifier, carried)
end

AddEventHandler('ws:giveweapons', function(src)
    TriggerClientEvent('cr:removeAllWeapons', src)
    if carriedWeapons[identifier] then
      local identifier = getPlayerIDFromSource(src)
      for k, v in pairs(carriedWeapons[identifier]) do
        carriedWeapons[identifier][k] = v
        TriggerClientEvent('cr:giveAmmo', src, k, v)
      end
    end
end)

AddEventHandler('cr:playerSignedIn', function(identifier, record, src)
    TriggerClientEvent('cr:removeAllWeapons', src)
    carriedWeapons[identifier] = {}
    if (record.cr_carried_weapons) then
      local carried = json.decode(record.cr_carried_weapons)
      if carried then
        for k, v in pairs(carried) do
          carriedWeapons[identifier][k] = v
          TriggerClientEvent('cr:giveAmmo', src, k, v)
        end
      end
    end
    StreamWeaponPrices(src)
end)

AddEventHandler('cr:playerLoggedOff', function(identifier)
    SavePlayerWeaponInventory(identifier, carriedWeapons[identifier])
    carriedWeapons[identifier] = {}
end)