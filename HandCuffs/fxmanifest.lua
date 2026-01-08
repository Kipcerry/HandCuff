

fx_version 'adamant'

game 'gta5'


lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
    '@es_extended/imports.lua'
}


server_scripts {

	'server.lua',
    '@oxmysql/lib/MySQL.lua'
}

client_scripts {
	'@es_extended/locale.lua',
	'client.lua'
}
