local weaponShops = {
  {['x'] = 842.40, ['y'] = -1033.12, ['z'] = 28.19, illegal = true},
  {['x'] = 21.70, ['y'] = -1107.41, ['z'] = 29.79, illegal = false}
}

weaponShopOpen = false

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

function showWeaponShopMenu(show)
    if(show) then
      TriggerEvent("GUI:Title", "Guns and Ammo")

      TriggerEvent("GUI:Option", "M92", function(cb)
        if(cb) then
          TriggerServerEvent('cr:buyWeapon', 'WEAPON_PISTOL')
        else
        end
      end)

      TriggerEvent("GUI:Option", "M1911", function(cb)
        if(cb) then
          TriggerServerEvent('cr:buyWeapon', 'WEAPON_HEAVYPISTOL')
        else
        end
      end)

      TriggerEvent("GUI:Update")
    end
end

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
        showWeaponShopMenu(shopOpen)
      else
        shopOpen = false
      end
    end
  end
end

Citizen.CreateThread(function()
  local shopOpen = false
  while true do
    Wait(0)
    drawGunshopInteraction()
  end
end)