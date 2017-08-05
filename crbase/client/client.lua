local firstSpawn = true

AddEventHandler('playerSpawned', function(spawn)
    if firstSpawn then
      TriggerServerEvent('cr:playerFirstSpawned')
      firstSpawn = false
    end
end)

RegisterNetEvent('cr:notify')
AddEventHandler('cr:notify', function(str, img, title, subtitle)
  notifyPlayer(str)
end)

-- failing for some reasons.
local function CreateNotification(str, img, title, subtitle)
  SetNotificationTextEntry("STRING")
  AddTextComponentSubstringPlayerName(str)
  if img and title and subtitle then
    SetNotificationMessage(img, img, false, 4, title, subtitle)
  end
  DrawNotification(false, false)
end

function notifyPlayer(text)
  SetNotificationTextEntry('STRING')
  AddTextComponentString(text)
  DrawNotification(false, false)
end