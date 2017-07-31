-- run this once to setup the database.
-- if you changed kTableName or kFieldName, change the columes below as well.
ALTER TABLE users ADD COLUMN cr_player_position VARCHAR(255) DEFAULT '{-852.84448242188, -2257.5744628906,  -11.508383750916, 132.17895507813}';