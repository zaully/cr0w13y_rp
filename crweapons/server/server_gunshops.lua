local kWeaponPrices = {
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

local weaponsOwned = {}

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

AddEventHandler('playerDropped', function()
  weaponsOwned[source] = {}
end)

RegisterServerEvent('cr:buyWeapon')
AddEventHandler('cr:buyWeapon', function(weaponTag)
  local identifier = getPlayerIDFromSource(source)
  if weaponsOwned[identifier] == nil then
    weaponsOwned[identifier] = {}
  end

  if kWeaponPrices[weaponTag] then
      if weaponsOwned[identifier][weaponTag] == nil then
        -- check money
        TriggerEvent('cr:spendMoney', identifier, kWeaponPrices[weaponTag], function(result)
--          if result == rok then
--            TriggerClientEvent('cr:notify', source, 'Thank you for your purchase!', "CHAR_MILSITE", "Warstock Cache & Carry", "Weapon Purschase")
--            TriggerClientEvent('cr:giveWeapon', source, weaponTag)
--            weaponsOwned[source][weaponTag] = true
--            return
--          end
        end)
        -- just give the weapon
--        weaponsOwned[identifier][weaponTag] = true
--        TriggerClientEvent('cr:giveWeapon', source, weaponTag)
--        return
      else
        -- just give the weapon
        TriggerClientEvent('cr:giveAmmo', source, weaponTag)
        return
        
        -- check money
--        local ammoPrice = kWeaponPrices[weaponTag] / 100
--        if user.getMoney() >= ammoPrice then
--          user.removeMoney(ammoPrice)
--          TriggerClientEvent('cr:giveAmmo', source, weaponTag)
--          return
--        end
      
      end
      TriggerClientEvent('cr:notify', source, '~r~Not enough cash')
  end
end)