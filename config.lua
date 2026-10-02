Config = {}

Config.Debug = true
Config.Command = 'houses'
Config.KeyItem = 'house_key'
Config.MaxOwnedHouses = 3

Config.InventoryAllowedItems = {
    'bread',
    'water',
    'phone',
    'lockpick',
    'weapon_pistol'
}

Config.Properties = {
    {
        id = 1,
        name = 'Sunset Villa',
        price = 15000,
        entrance = { x = 120.51, y = -1001.25, z = 29.35, h = 92.0 },
        exit = { x = 346.12, y = -1000.97, z = -99.2, h = 160.0 },
        garage = { x = 111.80, y = -1016.80, z = 28.80 },
        locked = true,
        label = 'Vila Sunset'
    },
    {
        id = 2,
        name = 'Palms Apartment',
        price = 9000,
        entrance = { x = 170.59, y = -1000.80, z = 29.85, h = 55.0 },
        exit = { x = 348.91, y = -998.52, z = -99.2, h = 205.0 },
        garage = { x = 160.3, y = -997.6, z = 29.0 },
        locked = true,
        label = 'Palms Apartment'
    },
    {
        id = 3,
        name = 'Hillside House',
        price = 12000,
        entrance = { x = 220.33, y = -989.83, z = 29.75, h = 10.0 },
        exit = { x = 332.15, y = -1001.11, z = -99.2, h = 110.0 },
        garage = { x = 214.50, y = -981.60, z = 28.30 },
        locked = true,
        label = 'Hillside House'
    }
}

function PrintDebug(msg)
    if Config.Debug then
        print('[HOUSING] ' .. tostring(msg))
    end
end
