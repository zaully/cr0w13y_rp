
RegisterNetEvent('cr:displayCash')
AddEventHandler('cr:displayCash', function(a)
    SendNUIMessage({
      setmoney = true,
      money = a
    })
end)

RegisterNetEvent('cr:displayBank')
AddEventHandler('cr:displayBank', function(a)
    SendNUIMessage({
      setbank = true,
      money = a
    })
end)

RegisterNetEvent('cr:changeMoney')
AddEventHandler('cr:changeMoney', function(cashAmount, bankAmount)
    SendNUIMessage({
      moneytransaction = true,
      amount = cashAmount
    })
    SendNUIMessage({
      banktransaction = true,
      amount = bankAmount
    })
end)