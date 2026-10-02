local MySQL = MySQL

local function initializeDatabase()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `houses` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `name` VARCHAR(80) NOT NULL,
            `price` INT NOT NULL,
            `owner_identifier` VARCHAR(60) DEFAULT NULL,
            `owner_name` VARCHAR(80) DEFAULT NULL,
            `locked` TINYINT(1) NOT NULL DEFAULT 1,
            `entrance_x` FLOAT NOT NULL,
            `entrance_y` FLOAT NOT NULL,
            `entrance_z` FLOAT NOT NULL,
            `entrance_h` FLOAT NOT NULL,
            `exit_x` FLOAT NOT NULL,
            `exit_y` FLOAT NOT NULL,
            `exit_z` FLOAT NOT NULL,
            `exit_h` FLOAT NOT NULL,
            `garage_x` FLOAT NOT NULL,
            `garage_y` FLOAT NOT NULL,
            `garage_z` FLOAT NOT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
        PrintDebug('Tabulka houses vytvořena')
    end)

    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `house_keys` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `identifier` VARCHAR(60) NOT NULL,
            `house_id` INT NOT NULL,
            `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (`id`),
            UNIQUE KEY `unique_key` (`identifier`, `house_id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
    ]], {}, function()
        PrintDebug('Tabulka house_keys vytvořena')
    end)
end

local function insertDefaultProperties()
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM houses', {}, function(count)
        if tonumber(count) > 0 then
            return
        end

        for _, prop in ipairs(Config.Properties) do
            MySQL.Async.execute('INSERT INTO houses (name, price, owner_identifier, owner_name, locked, entrance_x, entrance_y, entrance_z, entrance_h, exit_x, exit_y, exit_z, exit_h, garage_x, garage_y, garage_z) VALUES (@name, @price, NULL, NULL, @locked, @ex, @ey, @ez, @eh, @sx, @sy, @sz, @sh, @gx, @gy, @gz)', {
                ['@name'] = prop.name,
                ['@price'] = prop.price,
                ['@locked'] = prop.locked and 1 or 0,
                ['@ex'] = prop.entrance.x,
                ['@ey'] = prop.entrance.y,
                ['@ez'] = prop.entrance.z,
                ['@eh'] = prop.entrance.h,
                ['@sx'] = prop.exit.x,
                ['@sy'] = prop.exit.y,
                ['@sz'] = prop.exit.z,
                ['@sh'] = prop.exit.h,
                ['@gx'] = prop.garage.x,
                ['@gy'] = prop.garage.y,
                ['@gz'] = prop.garage.z
            })
        end
    end)
end

function GetAllHouses(callback)
    MySQL.Async.fetchAll('SELECT * FROM houses ORDER BY id ASC', {}, function(rows)
        local result = {}
        for _, row in ipairs(rows or {}) do
            result[#result + 1] = {
                id = row.id,
                name = row.name,
                price = tonumber(row.price),
                owner = row.owner_identifier,
                owner_name = row.owner_name,
                locked = tonumber(row.locked) == 1,
                entrance = { x = tonumber(row.entrance_x), y = tonumber(row.entrance_y), z = tonumber(row.entrance_z), h = tonumber(row.entrance_h) },
                exit = { x = tonumber(row.exit_x), y = tonumber(row.exit_y), z = tonumber(row.exit_z), h = tonumber(row.exit_h) },
                garage = { x = tonumber(row.garage_x), y = tonumber(row.garage_y), z = tonumber(row.garage_z) }
            }
        end
        callback(result)
    end)
end

function GetHouseById(houseId, callback)
    MySQL.Async.fetchAll('SELECT * FROM houses WHERE id = @id LIMIT 1', {
        ['@id'] = houseId
    }, function(rows)
        if rows and rows[1] then
            callback({
                id = rows[1].id,
                name = rows[1].name,
                price = tonumber(rows[1].price),
                owner = rows[1].owner_identifier,
                owner_name = rows[1].owner_name,
                locked = tonumber(rows[1].locked) == 1,
                entrance = { x = tonumber(rows[1].entrance_x), y = tonumber(rows[1].entrance_y), z = tonumber(rows[1].entrance_z), h = tonumber(rows[1].entrance_h) },
                exit = { x = tonumber(rows[1].exit_x), y = tonumber(rows[1].exit_y), z = tonumber(rows[1].exit_z), h = tonumber(rows[1].exit_h) },
                garage = { x = tonumber(rows[1].garage_x), y = tonumber(rows[1].garage_y), z = tonumber(rows[1].garage_z) }
            })
        else
            callback(nil)
        end
    end)
end

function SetHouseOwner(houseId, identifier, ownerName, callback)
    MySQL.Async.execute('UPDATE houses SET owner_identifier = @owner, owner_name = @owner_name WHERE id = @id', {
        ['@owner'] = identifier,
        ['@owner_name'] = ownerName,
        ['@id'] = houseId
    }, function(rows)
        if callback then callback(rows) end
    end)
end

function ClearHouseOwner(houseId, callback)
    MySQL.Async.execute('UPDATE houses SET owner_identifier = NULL, owner_name = NULL, locked = 1 WHERE id = @id', {
        ['@id'] = houseId
    }, function(rows)
        if callback then callback(rows) end
    end)
end

function ToggleHouseLock(houseId, callback)
    MySQL.Async.fetchScalar('SELECT locked FROM houses WHERE id = @id LIMIT 1', {
        ['@id'] = houseId
    }, function(value)
        local locked = tonumber(value) == 1
        MySQL.Async.execute('UPDATE houses SET locked = @locked WHERE id = @id', {
            ['@locked'] = locked and 0 or 1,
            ['@id'] = houseId
        }, function(rows)
            if callback then callback(not locked) end
        end)
    end)
end

function GiveHouseKey(identifier, houseId)
    MySQL.Async.execute('INSERT INTO house_keys (identifier, house_id) VALUES (@identifier, @house_id) ON DUPLICATE KEY UPDATE house_id = house_id', {
        ['@identifier'] = identifier,
        ['@house_id'] = houseId
    })
end

function RemoveHouseKey(identifier, houseId)
    MySQL.Async.execute('DELETE FROM house_keys WHERE identifier = @identifier AND house_id = @house_id', {
        ['@identifier'] = identifier,
        ['@house_id'] = houseId
    })
end

function HasHouseAccess(identifier, houseId, callback)
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM house_keys WHERE identifier = @identifier AND house_id = @house_id', {
        ['@identifier'] = identifier,
        ['@house_id'] = houseId
    }, function(count)
        callback(tonumber(count) > 0)
    end)
end

initializeDatabase()
Wait(1000)
insertDefaultProperties()
