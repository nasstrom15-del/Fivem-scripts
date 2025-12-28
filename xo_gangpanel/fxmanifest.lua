shared_script "@CyberAnticheat/init.lua"
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '.exo1337'

client_scripts {
    'client/utils/utils.lua',
    'client/*.lua',
}

server_scripts {
    "@oxmysql/lib/MySQL.lua",
    'server/utils/utils.lua',
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
    "shared/*.lua",
}

-- ui_page 'http://localhost:5173/' -- DEV
ui_page 'dist/index.html'
files {'dist/index.html', 'dist/assets/**'}

escrow_ignore { 
    "shared/*.lua"
}
dependency '/assetpacks'