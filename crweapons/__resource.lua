-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP weapons module" -- Resource Descrption

client_scripts {
  'client/client_gunshops.lua',
  'client/ui.lua'
}

server_scripts {
  'server/server_gunshops.lua',
  '@mysql-async/lib/MySQL.lua'
}