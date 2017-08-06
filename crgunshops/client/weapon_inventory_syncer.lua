function GivePlayerAmmo(item, ammoCount)
  GiveWeaponToPed(GetPlayerPed(-1), GetHashKey(item), ammoCount, false, false)
end

function UpdateWeaponsInfo()
  local uploading = {}
  for _, k in ipairs(kWeapons) do
    local pd = GetPlayerPed(-1)
    local hash = GetHashKey(k)
    if HasPedGotWeapon(pd, hash, false) then
      uploading[k] = GetAmmoInPedWeapon(pd, hash)
    end
  end
  TriggerServerEvent('cr:saveWeaponInventory', uploading)
end

Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(30000)
    UpdateWeaponsInfo()
  end
end)