local semiFiringOnlyWeapons = {}
local semiBlock = false
local currentWeapon

local function SetupFiringMode(weapon)
  local fullAuto = true
  for _, v in ipairs(kSemiOnlyWeapons) do
    local hash = GetHashKey(v)
    if weapon == hash then
      fullAuto = false
      semiFiringOnlyWeapons[weapon] = true
    end
  end
  if fullAuto then
    semiFiringOnlyWeapons[weapon] = false
  end
end

local function SetFiring(enable)
  if enable then
    EnableControlAction(1, 24, true)
    EnableControlAction(1, 257, true)
  else
    DisableControlAction(1, 24, true)
    DisableControlAction(1, 257, true)
  end
end

local function EnforceSemiautoFireMode()
	local ped = GetPlayerPed(-1)
	local weapon = GetSelectedPedWeapon(ped)
  if semiFiringOnlyWeapons[weapon] == nil then
    SetupFiringMode(weapon)
  end
  if currentWeapon ~= nil and currentWeapon ~= weapon then
    semiBlock = false
  end
  if semiFiringOnlyWeapons[weapon] == false then
    SetFiring(true)
  else
    if IsDisabledControlJustReleased(1, 24) then
      semiBlock = false
    elseif IsControlJustPressed(1, 24) then
      semiBlock = true
    end
    SetFiring(not semiBlock)
  end
  currentWeapon = weapon
end

Citizen.CreateThread(function()
  while true do
    Wait(0)
    EnforceSemiautoFireMode()
  end
end)