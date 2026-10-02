# 🏠 VMS-Style Housing System - FINAL VERSION

## Kompletní profesionální housing systém pro FiveM ESX

### ✨ Klíčové funkce

- ✅ Nákup/Prodej nemovitostí
- ✅ Zámek a odemknutí domu
- ✅ Interiérové teleporty (vstup/výstup)
- ✅ Klíče a přístup do domu
- ✅ Domovní garáž
- ✅ Domovní sklad / Inventář
- ✅ Profesionální NUI menu
- ✅ MySQL databáze
- ✅ Admin příkazy
- ✅ České texty
- ✅ Emoji notifikace
- ✅ Bezpečnostní kontroly

---

## 📥 Instalace

### 1. Vložení do serveru

```bash
cd resources
git clone https://github.com/hkrdtn/fivem-housing-system fivem-housing-system
```

### 2. Přidání do server.cfg

```cfg
ensure esx-extended
ensure mysql-async
ensure fivem-housing-system
```

### 3. SQL Databáze

Spusť tento SQL skript:

```sql
-- Vytvoření tabulky domů
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
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    INDEX `owner_idx` (`owner_identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabulka klíčů
CREATE TABLE IF NOT EXISTS `house_keys` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(60) NOT NULL,
    `house_id` INT NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_key` (`identifier`, `house_id`),
    INDEX `house_idx` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabulka domovního inventáře
CREATE TABLE IF NOT EXISTS `house_inventory` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `house_id` INT NOT NULL,
    `item_name` VARCHAR(80) NOT NULL,
    `item_count` INT NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_house_item` (`house_id`, `item_name`),
    INDEX `house_idx` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tabulka vozidel v garáži
CREATE TABLE IF NOT EXISTS `house_vehicles` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `house_id` INT NOT NULL,
    `owner_identifier` VARCHAR(60) NOT NULL,
    `vehicle_model` VARCHAR(80) NOT NULL,
    `vehicle_plate` VARCHAR(80) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `unique_vehicle_key` (`house_id`, `vehicle_plate`),
    INDEX `house_idx` (`house_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Přidání house_key itemu
INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES
('house_key', 'Klíč od domu', 1, 0, 1)
ON DUPLICATE KEY UPDATE `label` = VALUES(`label`);
```

### 4. Restart serveru

```
restart fivem-housing-system
```

---

## 🎮 Příkazy

| Příkaz | Popis | Příklad |
|--------|-------|----------|
| `/houses` | Otevřít menu nemovitostí | `/houses` |
| `/givehousekey` | Přidat klíč do inventáře | `/givehousekey` |
| `/housesadmin` | Admin seznam domů | `/housesadmin` |

---

## 📋 Funkce v detailu

### 🏡 Nákup nemovitosti
- Hráč se postaví k domu
- Stiskne [E] a otevře NUI menu
- Klikne na "Koupit"
- Zaplatí cenu a dům se mu přidělí
- Dostane klíč do inventáře

### 🚪 Vstup do domu
- Hráč stiskne [E] u vchodu domu
- Otevře se menu
- Klikne na "Vstoupit"
- Teleportuje se do interiéru
- Na výstupu se ukáže marker [E] "Opustit dům"

### 🔒 Zamykání/Odemykání
- Pouze majitel může zamykat/odemykat
- Zamčený dům nemohou vstoupit ostatní bez klíče
- Tlačítko "🔒 Zamknout" / "🔓 Odemknout" v menu

### 🗝️ Klíče
- Item `house_key` se přidá do inventáře při koupi
- Lze si přidat pomocí `/givehousekey`
- Umožňuje vstup do domu

### 🚗 Garáž
- Přehled vozidel v garáži
- Zobrazuje model a SPZ
- Lze ukládat vozidla do DB

### 📦 Sklad
- Ukládání a vybírání položek
- Pouze majitel má přístup
- Položky se ukládají do DB

### 💰 Prodej
- Hráč prodá dům za 70% původní ceny
- Klíč se odebere
- Dům se označí jako volný

---

## 🛠️ Konfigurace

Uprav `config.lua`:

```lua
Config.MaxOwnedHouses = 3  -- Maximální počet vlastněných domů
Config.KeyItem = 'house_key'  -- Název itemu klíče
Config.Debug = true  -- Debug režim
```

---

## 📁 Struktura

```
fivem-housing-system/
├── fxmanifest.lua
├── config.lua
├── server/
│   ├── main.lua
│   └── database.lua
├── client/
│   └── main.lua
├── html/
│   ├── index.html
│   ├── style.css
│   └── app.js
├── sql/
│   └── housing.sql
└── README.md
```

---

## 🔐 Bezpečnost

- ✅ Ověření vlastníka
- ✅ Ověření přístupu (klíče)
- ✅ Ověření majetku
- ✅ Kontrola peněz
- ✅ Admin kontrol

---

## 📞 Support

Pokud narazíš na problém:

1. Zkontroluj `server.log`
2. Ujisti se, že máš všechny tabulky v DB
3. Zkontroluj dependencies v `server.cfg`
4. Zkus `/housesadmin` (pokud jsi admin)

---

## 📜 Licenční podmínky

Tento script je free VMS-style verze. Není komerčním klonem.

---

## ✅ Checklist pro nasazení

- [x] Resource naklonován
- [x] SQL spuštěn
- [x] server.cfg upraven
- [x] es_extended aktivován
- [x] mysql-async aktivován
- [x] Item `house_key` přidán
- [x] Server restartován
- [x] Funkce otestovány

---

**Verze:** 2.0.0 FINAL
**Poslední aktualizace:** 2. října 2026
**Stav:** ✅ Produkční verze
