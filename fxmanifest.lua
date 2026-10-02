fx_version 'cerulean'
game 'gta5'

author 'Copilot'
description 'Free VMS-style FiveM Housing System with buy / sell / keys / garage / NUI'
version '1.0.0'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js'
}

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/database.lua',
    'server/main.lua'
}

dependencies {
    'es_extended',
    'mysql-async',
    'skinchanger'
}
