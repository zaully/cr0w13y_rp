-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP weapons module" -- Resource Descrption

client_scripts {
  'client/weapons.lua',
  'client/weapon_inventory_syncer.lua',
  'client/client_gunshops.lua',
  'client/ui.lua'
}

server_scripts {
  'server/weapon_prices.lua',
  'server/client_event_handler.lua',
  'server/server_gunshops.lua',
  '@crmoney/server/money_enums.lua',
  '@crbase/server/base.lua',
  '@mysql-async/lib/MySQL.lua'
}