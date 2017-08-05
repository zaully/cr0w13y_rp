-- Manifest
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

description "Crowley's RP money module" -- Resource Descrption

ui_page 'client/ui.html'

client_scripts {
  'client/client.lua'
}

server_scripts {
  'config/server_config.lua',
  'server/money_enums.lua',
  'server/money_manager.lua',
  '@crbase/server/base.lua',
  '@mysql-async/lib/MySQL.lua'
}

-- NUI Files
files {
	'client/ui.html',
	'client/pdown.ttf'
}