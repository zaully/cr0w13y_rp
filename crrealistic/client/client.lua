local currentWeapon = nil
local weaponDrewAt = nil
local hashToModel = {}

function DisplayHelpText(str)
  BeginTextCommandDisplayHelp("STRING")
  AddTextComponentScaleform(str)
  EndTextCommandDisplayHelp(0, 0, 1, -1)
end

function RunDrawingSpeedChecks()
	local ped = GetPlayerPed(-1)
	local weapon = GetSelectedPedWeapon(ped)
  if weapon == -1569615261 then -- unarmed
    currentWeapon = nil
    weaponDrewAt = nil
    return
  end
  if weaponDrewAt == nil or currentWeapon == nil or weapon ~= currentWeapon then
    weaponDrewAt = GetGameTimer()
    currentWeapon = weapon
    DisablePlayerFiring(ped, true)
  else
    local drawingTime = hashToModel[currentWeapon]
    if drawingTime then
      local currentTime = GetGameTimer()
      if currentTime - weaponDrewAt < drawingTime then
        DisablePlayerFiring(ped, true)
      end
    else
      DisablePlayerFiring(ped, true)
    end
  end
end

Citizen.CreateThread(function()
  while true do
    Wait(0)
    RunDrawingSpeedChecks()
  end
end)

local firstSpawn = true
AddEventHandler('playerSpawned', function(spawn)
    if firstSpawn then
      for k, v in pairs(kWeaponsHandling) do
        local hash = GetHashKey(k)
        hashToModel[hash] = v
      end
      firstSpawn = false
    end
end)