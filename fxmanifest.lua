lua54 'yes' -- needed for reaper
lua54 'yes' -- needed for reaper
fx_version "adamant"
game "gta5"
client_scripts {
    "client/*.lua"
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/*.lua"
}
shared_scripts {
    "config.lua"
}