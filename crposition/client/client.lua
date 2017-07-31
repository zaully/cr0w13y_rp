RegisterNetEvent('cr:movePlayer')
AddEventHandler('cr:movePlayer', function(posMap)
    local ped = GetPlayerPed(-1)
    SetEntityCoords(ped, posMap.x, posMap.y, posMap.z, 1, 0, 0, 1)
end)

function updateCoordsToServer()
  local ped = GetPlayerPed(-1)
  local pos = GetEntityCoords(ped, true)
  x, y, z = table.unpack(pos)
  local h = GetEntityHeading(ped)
  TriggerServerEvent("cr:playerLocationUpdated", {['x'] = x, ['y'] = y, ['z'] = z, ['h'] = h})
end

Citizen.CreateThread(function ()
  while true do
    Citizen.Wait(15000)
    updateCoordsToServer()
  end
end)