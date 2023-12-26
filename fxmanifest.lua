fx_version 'cerulean'
game 'gta5'

name 'Stance'
description 'A library which utilizes wheel game natives made for FiveM'
author 'L_Remp'

lua54 'yes'

version '1.1.0'

client_scripts {
    'config.lua',
    'client/*.lua',
    'locale/*.json',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'config.lua',
    'server/*.lua',
}

files {
    'locale/*.json',
    'ui/dist/index.html',
    'ui/dist/assets/*.css',
    'ui/dist/assets/*.js',
}

ui_page 'ui/dist/index.html'