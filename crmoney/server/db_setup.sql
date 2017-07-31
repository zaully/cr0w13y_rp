-- run this once to setup the database.
-- if you changed kTableName, kCashField or kBankField, change the columes below as well.
ALTER TABLE users ADD COLUMN cr_cash_amount int unsigned DEFAULT 0;
ALTER TABLE users ADD COLUMN cr_bank_balance int unsigned DEFAULT 0;