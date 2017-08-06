local weaponShops = {
  {['x'] = 842.40, ['y'] = -1033.12, ['z'] = 28.19, illegal = true},
  {['x'] = 21.70, ['y'] = -1107.41, ['z'] = 29.79, illegal = false}
}

local weaponPrices = {}
-- key = [name, price in legal stores (-1 means unavailable), price in illegal stores, price for ammo in legal stores, price for ammo in illegal stores, ammo per purchase]

local shopOpen = false

-- draw gunshop blips
Citizen.CreateThread(function()
  for k,v in ipairs(weaponShops)do
    local blip = AddBlipForCoord(v.x, v.y, v.z)
    SetBlipSprite(blip, 110)
    SetBlipScale(blip, 0.8)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Ammunation")
    EndTextCommandSetBlipName(blip)
  end
  
  return
end)

function ShowWeaponShopMenu(show, illegal)
    if(show) then
      TriggerEvent("GUI:Title", "Guns and Ammo")
      local limit = 0
      for k, info in pairs(weaponPrices) do
        if limit > 10 then -- can't handle all entries
          break
        end
        if illegal or info[2] > -1 then
          local weaponPrice
          if illegal then
            weaponPrice = info[3]
          else
            weaponPrice = info[2]
          end 
          TriggerEvent("GUI:Option", info[1] .. "($" .. weaponPrice .. ")", function(cb)
            if(cb) then
              TriggerServerEvent('cr:buyWeapon', k, illegal)
            end
          end)
          limit = limit + 1
        end
      end
      logged = true

      TriggerEvent("GUI:Update")
    end
end

RegisterNetEvent('cr:receiveWeaponPrices')
AddEventHandler('cr:receiveWeaponPrices', function(prices)
  weaponPrices = prices
end)

RegisterNetEvent('cr:removeAllWeapons')
AddEventHandler('cr:removeAllWeapons', function()
  RemoveAllPedWeapons(GetPlayerPed(-1), true)
end)

RegisterNetEvent('cr:giveWeapon')
AddEventHandler('cr:giveWeapon', function(v)
  Citizen.InvokeNative(0x67C540AA08E4A6F5, -1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET")
  GivePlayerAmmo(v, 0)
end)

RegisterNetEvent('cr:giveAmmo')
AddEventHandler('cr:giveAmmo', function(v, ammoCount)
  Citizen.InvokeNative(0x67C540AA08E4A6F5, -1, "WEAPON_PURCHASE", "HUD_AMMO_SHOP_SOUNDSET")  
  GivePlayerAmmo(v, ammoCount)
end)

function drawGunshopInteraction()
  local myPos = GetEntityCoords(GetPlayerPed(-1), true)
  for _,v in ipairs(weaponShops)do
    if Vdist(myPos.x, myPos.y, myPos.z, v.x, v.y, v.z) < 10.0 then
      DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 255, 255, 255,155, 0,0, 0,0)
      if Vdist(myPos.x, myPos.y, myPos.z, v.x, v.y, v.z) < 2.0 then 
        DisplayHelpText("Press ~INPUT_CONTEXT~ to open the weapon store")
        if IsControlJustPressed(1, 51) then
          shopOpen = not shopOpen
        end
        ShowWeaponShopMenu(shopOpen, v.illegal)
      else
        shopOpen = false
      end
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Wait(0)
    drawGunshopInteraction()
  end
end)