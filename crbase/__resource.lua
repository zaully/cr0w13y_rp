resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP mode base" -- Resource Descrption

client_scripts {
  'client/client.lua',
--  'client/keys.lua',
  'client/ui_notification.lua'
}
server_scripts {
  'config/server_config.lua',
  'server/server.lua',
  'server/position_manager.lua',
  'server/login.lua',
  '@mysql-async/lib/MySQL.lua'
}

server_exports {
  'getPlayerIDFromSource'
}
