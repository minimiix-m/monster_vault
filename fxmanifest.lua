fx_version 'adamant'

game 'gta5'

version '1.0.0'
name 'monster_vault'
author 'Modify By minimiix'

shared_script {
	'config/config.general.lua',
	'config/config.shared.lua',
	'config/config.function.lua',
}

server_scripts {
	'server/main.lua'
}

client_scripts {
	'client/main.lua'
}

dependencies {
	'esx_addonaccount',
	'esx_addoninventory',
	'esx_datastore'
}

exports {
	"getMonsterVaultLicense"
}