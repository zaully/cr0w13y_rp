-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP realistic weapons module" -- Resource Descrption

client_scripts {
  'client/config.lua',
  'client/client.lua'
}
server_script 'server/server.lua'