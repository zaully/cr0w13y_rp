resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP mode base" -- Resource Descrption

client_scripts {
  'client/client.lua'
}
server_scripts {
  'config/server_config.lua',
  'server/base.lua',
  'server/main.lua',
  '@mysql-async/lib/MySQL.lua'
}