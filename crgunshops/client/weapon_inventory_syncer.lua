kWeapons = {
  "WEAPON_KNIFE",
  "WEAPON_HAMMER",
  "WEAPON_BAT",
  "WEAPON_CROWBAR",
  "WEAPON_GOLFCLUB",
  "WEAPON_BOTTLE",
  "WEAPON_DAGGER",
  "WEAPON_HATCHET",
  "WEAPON_KNUCKLEDUSTER",
  "WEAPON_MACHETE",
  "WEAPON_FLASHLIGHT",
  "WEAPON_SWITCHBLADE",
  -- Thrown
  "WEAPON_BALL",
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_PETROLCAN",
  "WEAPON_GRENADE",
  "WEAPON_MOLOTOV",
  "WEAPON_SMOKEGRENADE",
  "WEAPON_SWITCHBLADE",
  -- Thrown
  "WEAPON_FIREEXTINGUISHER",
  "WEAPON_PETROLCAN",
  "WEAPON_BALL",
  -- Pistols
  "WEAPON_PISTOL",
  "WEAPON_SNSPISTOL",
  "WEAPON_VINTAGEPISTOL",
  "WEAPON_COMBATPISTOL",
  "WEAPON_HEAVYPISTOL",
  "WEAPON_PISTOL50",
  "WEAPON_MARKSMANPISTOL",
  "WEAPON_APPISTOL",
  "WEAPON_FLAREGUN",
  -- SMGs
  "WEAPON_MICROSMG",
  "WEAPON_MINISMG",
  "WEAPON_SMG",
  "WEAPON_COMBATPDW",
  "WEAPON_ASSAULTSMG",
  -- Shotguns
  "WEAPON_PUMPSHOTGUN",
  "WEAPON_SAWNOFFSHOTGUN",
  "WEAPON_BULLPUPSHOTGUN",
  "WEAPON_ASSAULTSHOTGUN",
  -- Assault Rifles
  "WEAPON_COMPACTRIFLE",
  "WEAPON_ASSAULTRIFLE",
  "WEAPON_CARBINERIFLE",
  "WEAPON_SPECIALCARBINE",
  "WEAPON_BULLPUPRIFLE",
  "WEAPON_ADVANCEDRIFLE",
  -- Heavy Weapons
  "GRENADELAUNCHERSMOKE",
  "WEAPON_RAILGUN",
}

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