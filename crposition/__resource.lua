resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP position module" -- Resource Descrption

client_scripts {
  'client/client.lua'
}
server_scripts {
  'config/server_config.lua',
  'server/client_event_handler.lua',
  'server/position_manager.lua',
  '@crbase/server/base.lua',
  '@mysql-async/lib/MySQL.lua'
}