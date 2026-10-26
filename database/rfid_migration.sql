USE employee_management;
CREATE TABLE IF NOT EXISTS rfid_cards (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 employee_id INT UNSIGNED NOT NULL,
 uid VARCHAR(64) NOT NULL,
 card_type VARCHAR(50) NOT NULL DEFAULT 'MIFARE',
 status ENUM('active','blocked','expired') NOT NULL DEFAULT 'active',
 issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 expires_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_rfid_uid(uid), INDEX idx_rfid_employee(employee_id), INDEX idx_rfid_status(status),
 FOREIGN KEY(employee_id) REFERENCES employees(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS attendance_devices (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 device_code VARCHAR(50) NOT NULL UNIQUE,
 device_name VARCHAR(120) NOT NULL,
 location VARCHAR(150) DEFAULT NULL,
 api_key_hash CHAR(64) DEFAULT NULL,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 last_seen_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS attendance_punches (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 event_id CHAR(36) NOT NULL UNIQUE,
 employee_id INT UNSIGNED NULL,
 card_uid VARCHAR(64) NOT NULL,
 device_id BIGINT UNSIGNED NULL,
 punch_type ENUM('IN','OUT','DUPLICATE','REJECTED') NOT NULL,
 punched_at DATETIME NOT NULL,
 received_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 sync_status ENUM('synced','pending','rejected') NOT NULL DEFAULT 'synced',
 reason VARCHAR(255) NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_punch_employee_date(employee_id,punched_at), INDEX idx_punch_device(device_id), INDEX idx_punch_uid(card_uid),
 FOREIGN KEY(employee_id) REFERENCES employees(id) ON DELETE CASCADE,
 FOREIGN KEY(device_id) REFERENCES attendance_devices(id) ON DELETE SET NULL
);
CREATE TABLE IF NOT EXISTS attendance_sync_events (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 event_id CHAR(36) NOT NULL UNIQUE,
 device_code VARCHAR(50) NOT NULL,
 payload_json JSON NOT NULL,
 status ENUM('pending','synced','failed') NOT NULL DEFAULT 'pending',
 attempts INT UNSIGNED NOT NULL DEFAULT 0,
 last_error VARCHAR(500) NULL,
 next_retry_at DATETIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_sync_status(status,next_retry_at)
);
CREATE TABLE IF NOT EXISTS attendance_settings (
 setting_key VARCHAR(80) PRIMARY KEY,
 setting_value VARCHAR(255) NOT NULL
);
INSERT INTO attendance_settings(setting_key,setting_value) VALUES
('duplicate_window_seconds','8'),('shift_start','09:00:00'),('late_after_minutes','10')
ON DUPLICATE KEY UPDATE setting_value=VALUES(setting_value);
