kWeaponPrices = {
  ["WEAPON_KNIFE"] = 20,
  ["WEAPON_HAMMER"] = 20,
  ["WEAPON_BAT"] = 30,
  ["WEAPON_CROWBAR"] = 20,
  ["WEAPON_GOLFCLUB"] = 50,
  ["WEAPON_BOTTLE"] = 2,
  ["WEAPON_DAGGER"] = 20,
  ["WEAPON_HATCHET"] = 25,
  ["WEAPON_KNUCKLEDUSTER"] = 20,
  ["WEAPON_MACHETE"] = 40,
  ["WEAPON_FLASHLIGHT"] = 120,
  ["WEAPON_SWITCHBLADE"] = 50,
  -- Thrown
  ["WEAPON_BALL"] = 10,
  ["WEAPON_FIREEXTINGUISHER"] = 25,
  ["WEAPON_PETROLCAN"] = 50,
  ["WEAPON_GRENADE"] = 500,
  ["WEAPON_MOLOTOV"] = 500,
  ["WEAPON_SMOKEGRENADE"] = 500,
  ["WEAPON_SWITCHBLADE"] = 20,
  -- Thrown
  ["WEAPON_FIREEXTINGUISHER"] = 25,
  ["WEAPON_PETROLCAN"] = 50,
  ["WEAPON_BALL"] = 10,
  -- Pistols
  ["WEAPON_PISTOL"] = 900,
  ["WEAPON_SNSPISTOL"] = 500,
  ["WEAPON_VINTAGEPISTOL"] = 600,
  ["WEAPON_COMBATPISTOL"] = 800,
  ["WEAPON_HEAVYPISTOL"] = 1500,
  ["WEAPON_PISTOL50"] = 1500,
  ["WEAPON_MARKSMANPISTOL"] = 1700,
  ["WEAPON_APPISTOL"] = 2000,
  ["WEAPON_FLAREGUN"] = 300,
  -- SMGs
  ["WEAPON_MICROSMG"] = 500,
  ["WEAPON_MINISMG"] = 500,
  ["WEAPON_SMG"] = 650,
  ["WEAPON_COMBATPDW"] = 1600,
  ["WEAPON_ASSAULTSMG"] = 1800,
  -- Shotguns
  ["WEAPON_PUMPSHOTGUN"] = 400,
  ["WEAPON_SAWNOFFSHOTGUN"] = 450,
  ["WEAPON_BULLPUPSHOTGUN"] = 1000,
  ["WEAPON_ASSAULTSHOTGUN"] = 1500,
  -- Assault Rifles
  ["WEAPON_COMPACTRIFLE"] = 900,
  ["WEAPON_ASSAULTRIFLE"] = 1000,
  ["WEAPON_CARBINERIFLE"] = 1100,
  ["WEAPON_SPECIALCARBINE"] = 1250,
  ["WEAPON_BULLPUPRIFLE"] = 1250,
  ["WEAPON_ADVANCEDRIFLE"] = 1800,
  -- Heavy Weapons
  ["GRENADELAUNCHERSMOKE"] = 10000,
  ["WEAPON_RAILGUN"] = 9999999,
}

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
    local identifier = getPlayerIDFromSource(src)
    for k, v in pairs(carriedWeapons[identifier]) do
      carriedWeapons[identifier][k] = v
      TriggerClientEvent('cr:giveAmmo', src, k, v)
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
end)

AddEventHandler('cr:playerLoggedOff', function(identifier)
    SavePlayerWeaponInventory(identifier, carriedWeapons[identifier])
    carriedWeapons[identifier] = {}
end)