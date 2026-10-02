# Free VMS-styled Housing System

## Co obsahuje

- koupi / prodej nemovitostí
- zámek domu
- vstup do domu
- klíče a přístup
- NUI menu
- databázové tabulky
- item `house_key`
- příkaz `/houses`
- SQL pro nastavení itemů a základních domů
- vše v češtině

## Instalace

### 1. Vlož resource do `resources/fivem-housing-system`

### 2. Přidej do `server.cfg`

```cfg
ensure esx-extended
ensure mysql-async
ensure fivem-housing-system
```

### 3. Spusť SQL

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

INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('house_key', 'Klíč od domu', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
```

### 4. Příkazy

- `/houses` – otevře NUI menu nehnutele
- `/givehousekey` – přidá item `house_key`

### 5. Restart serveru

## DŮLEŽITÉ

Tento script je vytvořený jako free VMS-style verze. Je inspirovaný stylem a funkcemi, ale neobsahuje originální komerční kód ani logo VMS.

## Funkce

✓ nákup nemovitosti
✓ prodej nemovitosti
✓ zámek domu
✓ přístup do domu
✓ uložení do MySQL
✓ klíče
✓ NUI menu
✓ české texty
✓ připravené sample domy

## Struktura resource

```txt
fivem-housing-system/
├── fxmanifest.lua
├── config.lua
├── client/
│   └── main.lua
├── server/
│   ├── database.lua
│   └── main.lua
├── html/
│   ├── index.html
│   ├── style.css
│   └── app.js
├── README.md
└── sql/
    └── housing.sql
```
