playersMoney = {}
playersIds = {}

AddEventHandler('cr:playerSignedIn', function(identifier, record, src)
    if record.cr_cash_amount and record.cr_bank_balance then
      local money = {
        cash = record.cr_cash_amount,
        bank = record.cr_bank_balance
      }
      playersMoney[identifier] = money
      playersIds[identifier] = src
			TriggerClientEvent("cr:displayCash", src, money.cash)
			TriggerClientEvent("cr:displayBank", src, money.bank)
    end
end)

function cashToFromBank(identifier, amount, callback)
  if playersMoney[identifier] and playersIds[identifier] then
    local money = playersMoney[identifier]
    if amount > 0 and money.cash < amount then
      callback(eNotEnoughCash)
      return
    end
    if amount < 0 and money.bank < -amount then
      callback(eNotEnoughInBank)
      return
    end
    money.cash = money.cash - amount
    money.bank = money.bank + amount
    TriggerClientEvent("cr:changeMoney", playersIds[identifier], -amount, amount)
    callback(rok)
  else
    callback(eCantFindPlayer)
  end
end

AddEventHandler('cr:depositIntoBankAccount', function(identifier, amount, callback)
    cashToFromBank(identifier, amount, callback)
end)

AddEventHandler('cr:widrawFromBankAccount', function(identifier, amount, callback)
    cashToFromBank(identifier, -amount, callback)
end)

AddEventHandler('cr:spendMoney', function(identifier, amount, callback)
  debugp("a")
  if playersMoney[identifier] and playersIds[identifier] then
    debugp("b")
    local money = playersMoney[identifier]
    if money.cash + money.bank < amount then
      callback(eNotEnoughMoney)
      debugp("c")
      return
    end
    local bankChange = 0
    if money.cash < amount then
      bankChange = amount - money.cash
      money.cash = 0
      money.bank = money.bank - bankChange
    else
      money.cash = money.cash - amount
    end
    TriggerClientEvent("cr:changeMoney", playersIds[identifier], bankChange - amount, -bankChange)
    TriggerClientEvent("cr:displayCash", playersIds[identifier], money.cash)
    TriggerClientEvent("cr:displayBank", playersIds[identifier], money.bank)
    callback(rok)
    debugp("o")
  else
    callback(eCantFindPlayer)
    debugp("d")
  end
end)