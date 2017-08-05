playersMoney = {}
playersMoneyRecord = {}
playersIds = {}

AddEventHandler('cr:playerSignedIn', function(identifier, record, src)
    if record.cr_cash_amount and record.cr_bank_balance then
      local money = {
        cash = record.cr_cash_amount,
        bank = record.cr_bank_balance
      }
      local dbRecrod = {
        cash = record.cr_cash_amount,
        bank = record.cr_bank_balance
      }
      playersMoney[identifier] = money
      playersMoneyRecord[identifier] = dbRecrod
      playersIds[identifier] = src
			TriggerClientEvent("cr:displayCash", src, money.cash)
			TriggerClientEvent("cr:displayBank", src, money.bank)
    end
end)

function updateCacheAndDBMoney(identifier, cashAmountAdjustment, bankAmountAdjustment)
  local cache = playersMoney[identifier]
  local db = playersMoneyRecord[identifier]
  if cache and db then
    cache.cash = cache.cash + cashAmountAdjustment
    cache.bank = cache.bank + bankAmountAdjustment
    if math.abs(cache.cash - db.cash) + math.abs(cache.bank - db.bank) > 500 then
      db.cash = cache.cash
      db.bank = cache.bank
      debugp("should save...")
      savePlayerMoney(identifier, db)
    end
    return true
  end
  return false
end

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
    updateCacheAndDBMoney(identifier, -amount, amount)
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
  if playersMoney[identifier] and playersIds[identifier] then
    local money = playersMoney[identifier]
    if money.cash + money.bank < amount then
      callback(eNotEnoughMoney)
      return
    end
    local bankChange = 0
    if money.cash < amount then
      bankChange = amount - money.cash
      updateCacheAndDBMoney(identifier, -money.cash, -bankChange)
    else
      updateCacheAndDBMoney(identifier, -amount, bankChange)
    end
    TriggerClientEvent("cr:changeMoney", playersIds[identifier], bankChange - amount, -bankChange)
    TriggerClientEvent("cr:displayCash", playersIds[identifier], money.cash)
    TriggerClientEvent("cr:displayBank", playersIds[identifier], money.bank)
    callback(rok)
  else
    callback(eCantFindPlayer)
  end
end)

function savePlayerMoney(identifier, money)
  MySQL.Async.execute("update users set cr_cash_amount=@cash_amount, cr_bank_balance=@bank_balence WHERE identifier = @identifier", {
      ['@cash_amount'] = money.cash,
      ['@bank_balence'] = money.bank,
      ['@identifier'] = identifier}, function (result)
  end)
end

function saveCachedPlayerMoney(identifier)
    if (playersMoney[identifier] ~= nil) then
      savePlayerMoney(identifier, playersMoney[identifier])
      playersMoney[identifier] = nil
      debugp(identifier .. " money saved")
    end
end

AddEventHandler('cr:playerLoggedOff', function(identifier)
    saveCachedPlayerMoney(identifier)
end)