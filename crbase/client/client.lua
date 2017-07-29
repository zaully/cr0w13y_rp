local firstSpawn = true

AddEventHandler('playerSpawned', function(spawn)
    if firstSpawn then
      TriggerServerEvent('cr:playerFirstSpawned')
      firstSpawn = false
    end
end)

RegisterNetEvent('cr:movePlayer')
AddEventHandler('cr:movePlayer', function(posMap)
    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, posMap.x, posMap.y, posMap.z, 1, 0, 0, 1)
end)

RegisterNetEvent('cr:notify')
AddEventHandler('cr:notify', function(str, img, title, subtitle)
  CreateNotification(str, img, title, subtitle)
end)

function updateCoordsToServer()
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped, true)
  x, y, z = table.unpack(pos)
  local h = GetEntityHeading(ped)
  TriggerServerEvent("cr:playerLocationUpdated", {['x'] = x, ['y'] = y, ['z'] = z, ['h'] = h})
end

local function CreateNotification(str, img, title, subtitle)
  SetNotificationTextEntry("STRING")
  AddTextComponentSubstringPlayerName(str)
  if img and title and subtitle then
    SetNotificationMessage(img, img, false, 4, title, subtitle)
  end
  DrawNotification(false, false)
end

Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(15000)
    updateCoordsToServer()
  end
end)