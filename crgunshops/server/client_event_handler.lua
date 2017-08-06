function ternary(check, first, second)
  if check then
    return first
  else
    return second
  end 
end

RegisterServerEvent('cr:buyWeapon')
AddEventHandler('cr:buyWeapon', function(weaponTag, illegal)
  local identifier = getPlayerIDFromSource(source)
  if carriedWeapons[identifier] == nil then
    carriedWeapons[identifier] = {}
  end
  local src = source
  if kWeaponPrices[weaponTag] then
    local info = kWeaponPrices[weaponTag]
    local ammo = info[6]
    local price
    if carriedWeapons[identifier][weaponTag] == nil then
      price = ternary(illegal, info[3], info[2])
    else
      price = ternary(illegal, info[5], info[4])
    end
    TriggerEvent('cr:spendMoney', identifier, price, function(result)
      if result == rok then
        TriggerClientEvent('cr:notify', src, 'Thank you for your purchase!', "CHAR_MILSITE", "Warstock Cache & Carry", "Weapon Purschase")
        TriggerClientEvent('cr:giveAmmo', src, weaponTag, ammo)
        if carriedWeapons[identifier][weaponTag] == nil then
          carriedWeapons[identifier][weaponTag] = ammo
        else
          carriedWeapons[identifier][weaponTag] = carriedWeapons[identifier][weaponTag] + ammo
        end
      else
        TriggerClientEvent('cr:notify', src, '~r~Not enough cash')
      end
    end)
  end
end)

RegisterServerEvent('cr:saveWeaponInventory')
AddEventHandler('cr:saveWeaponInventory', function(weaponInfo)
    local identifier = getPlayerIDFromSource(source)
    UpdatePlayerCarriedWeapons(identifier, weaponInfo)
end)