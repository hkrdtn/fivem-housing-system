local ESX = exports['es_extended']:getSharedObject()

local houses = {}

local function notify(msg)
    ESX.ShowNotification(msg)
end

local function GetDistance(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    local dz = a.z - b.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end

local function Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if not onScreen then return end

    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(true)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextEntry('STRING')
    AddTextComponentString(text)
    DrawText(_x, _y)
end

local function refreshHouses()
    TriggerServerEvent('housing:server:getProperties')
end

local function openHousingMenu()
    refreshHouses()
    SendNUIMessage({ type = 'openMenu', houses = houses })
    SetNuiFocus(true, true)
end

RegisterNetEvent('housing:client:syncHouses', function(serverHouses)
    houses = serverHouses or {}
end)

RegisterNetEvent('housing:client:notify', function(message)
    notify(message)
end)

RegisterNetEvent('housing:client:teleportToHouse', function(property, destination)
    if not destination then return end
    SetEntityCoords(PlayerPedId(), destination.x, destination.y, destination.z, false, false, false, false)
    SetEntityHeading(PlayerPedId(), destination.h or 0.0)
    notify('Vstoupil jsi do domu: ' .. property.name)
end)

RegisterNetEvent('housing:client:garageReply', function(data)
    if data and data.list then
        local message = 'Garáž: ' .. table.concat(data.list, ', ') if #data.list == 0 then message = 'Garáž je prázdná.' end
        notify(message)
    end
end)

RegisterNetEvent('housing:client:inventoryReply', function(data)
    if data and data.list then
        local message = 'Sklad: ' .. table.concat(data.list, ', ') if #data.list == 0 then message = 'Sklad je prázdný.' end
        notify(message)
    end
end)

RegisterNUICallback('closeMenu', function(_, cb)
    SetNuiFocus(false, false)
    cb({ ok = true })
end)

RegisterNUICallback('buyHouse', function(data, cb)
    TriggerServerEvent('housing:server:buyHouse', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNUICallback('sellHouse', function(data, cb)
    TriggerServerEvent('housing:server:sellHouse', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNUICallback('toggleLock', function(data, cb)
    TriggerServerEvent('housing:server:toggleLock', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNUICallback('enterHouse', function(data, cb)
    TriggerServerEvent('housing:server:enterHouse', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNUICallback('openGarage', function(data, cb)
    TriggerServerEvent('housing:server:openGarage', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNUICallback('openInventory', function(data, cb)
    TriggerServerEvent('housing:server:openInventory', tonumber(data.id))
    cb({ ok = true })
end)

RegisterNuicallback('depositItem', function(data, cb)
    TriggerServerEvent('housing:server:depositItem', tonumber(data.id), tostring(data.itemName), tonumber(data.count or 1))
    cb({ ok = true })
end)

RegisterNuicallback('withdrawItem', function(data, cb)
    TriggerServerEvent('housing:server:withdrawItem', tonumber(data.id), tostring(data.itemName), tonumber(data.count or 1))
    cb({ ok = true })
end)

RegisterCommand(Config.Command, function()
    openHousingMenu()
end, false)

RegisterCommand('houses', function()
    openHousingMenu()
end, false)

CreateThread(function()
    Wait(1000)
    refreshHouses()

    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)

        for _, property in ipairs(houses) do
            local entrance = property.entrance or { x = 0, y = 0, z = 0 }
            local dist = GetDistance(coords, vector3(entrance.x, entrance.y, entrance.z))

            if dist < 25.0 then
                DrawMarker(1, entrance.x, entrance.y, entrance.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.2, 1.2, 0.6, 255, 255, 255, 120, false, true, 2, false, nil, nil, false)
                if dist < 2.0 then
                    Draw3DText(entrance.x, entrance.y, entrance.z + 1.2, '[E] ' .. property.name)
                    if IsControlJustPressed(0, 38) then
                        openHousingMenu()
                    end
                end
            end
        end

        Wait(0)
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        Wait(1500)
        refreshHouses()
    end
end)
