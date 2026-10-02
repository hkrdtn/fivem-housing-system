# VMS-style Housing System

## Co přidáváme

- koupi / prodej nemovitostí
- zámek domu
- garáž
- domovní sklad / inventory
- klíče a přístup
- NUI menu a ESX integrace
- SQL tabulky pro domy, klíče, garáže a zásoby
- vše v češtině

## SQL

```sql
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
    `garage_enabled` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `house_keys` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `house_id` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_key` (`identifier`, `house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `house_inventory` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `house_id` INT NOT NULL,
    `item_name` VARCHAR(80) NOT NULL,
    `item_count` INT NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_house_item` (`house_id`, `item_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `house_vehicles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `house_id` INT NOT NULL,
    `owner_identifier` VARCHAR(60) NOT NULL,
    `vehicle_model` VARCHAR(80) NOT NULL,
    `vehicle_plate` VARCHAR(80) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_vehicle_key` (`house_id`, `vehicle_plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('house_key', 'Klíč od domu', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
```

## Příkazy

- `/houses` – otevře menu
- `/givehousekey` – přidá klíč do inventáře

## Funkce

✓ nákup domů
✓ prodej domů
✓ přístup / klíče
✓ garáž
✓ domovní sklad / inventory
✓ NUI menu
✓ ESX kompatibilita
✓ česky

## Instalace

1. Vlož resource do `resources/fivem-housing-system`
2. Přidej do `server.cfg`
3. Spusť SQL
4. Restart serveru
