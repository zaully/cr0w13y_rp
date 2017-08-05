-- run this once to setup the database.
ALTER TABLE users ADD COLUMN cr_carried_weapons VARCHAR(255) DEFAULT '{}';