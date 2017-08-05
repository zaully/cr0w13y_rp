RegisterServerEvent('cr:buyWeapon')
AddEventHandler('cr:buyWeapon', function(weaponTag)
  local identifier = getPlayerIDFromSource(source)
  if carriedWeapons[identifier] == nil then
    carriedWeapons[identifier] = {}
  end
  local src = source
  if kWeaponPrices[weaponTag] then
      if carriedWeapons[identifier][weaponTag] == nil then
        -- check money
        TriggerEvent('cr:spendMoney', identifier, kWeaponPrices[weaponTag], function(result)
          if result == rok then
            TriggerClientEvent('cr:notify', src, 'Thank you for your purchase!', "CHAR_MILSITE", "Warstock Cache & Carry", "Weapon Purschase")
            TriggerClientEvent('cr:giveWeapon', src, weaponTag)
            carriedWeapons[identifier][weaponTag] = 0
          else
            TriggerClientEvent('cr:notify', src, '~r~Not enough cash')
          end
        end)
      else
        TriggerEvent('cr:spendMoney', identifier, kWeaponPrices[weaponTag] / 100, function(result)
          if result == rok then
            TriggerClientEvent('cr:notify', src, 'Thank you for your purchase!', "CHAR_MILSITE", "Warstock Cache & Carry", "Weapon Purschase")
            TriggerClientEvent('cr:giveAmmo', src, weaponTag, 30)
            carriedWeapons[identifier][weaponTag] = carriedWeapons[identifier][weaponTag] + 30
          else
            TriggerClientEvent('cr:notify', src, '~r~Not enough cash')
          end
        end)
      end
  end
end)

RegisterServerEvent('cr:saveWeaponInventory')
AddEventHandler('cr:saveWeaponInventory', function(weaponInfo)
    local identifier = getPlayerIDFromSource(source)
    UpdatePlayerCarriedWeapons(identifier, weaponInfo)
end)