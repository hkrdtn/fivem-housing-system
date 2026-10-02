-- housing.sql
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
