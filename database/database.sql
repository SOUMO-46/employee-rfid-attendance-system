CREATE DATABASE IF NOT EXISTS employee_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE employee_management;

CREATE TABLE IF NOT EXISTS employees (
 id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 employee_code VARCHAR(30) NOT NULL UNIQUE,
 name VARCHAR(120) NOT NULL,
 email VARCHAR(150) NOT NULL UNIQUE,
 phone VARCHAR(20) NOT NULL,
 department VARCHAR(100) NOT NULL,
 designation VARCHAR(100) NOT NULL,
 joining_date DATE NOT NULL,
 basic_salary DECIMAL(12,2) NOT NULL DEFAULT 0,
 status ENUM('active','inactive') NOT NULL DEFAULT 'active',
 address VARCHAR(255) DEFAULT NULL,
 city VARCHAR(100) DEFAULT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 INDEX idx_department(department), INDEX idx_status(status), INDEX idx_joining_date(joining_date)
);
CREATE TABLE IF NOT EXISTS attendance (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 employee_id INT UNSIGNED NOT NULL,
 attendance_date DATE NOT NULL,
 status ENUM('present','absent','late','half_day','leave') NOT NULL,
 entry_time TIME NULL,
 exit_time TIME NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_employee_date(employee_id,attendance_date),
 INDEX idx_attendance_date(attendance_date),
 FOREIGN KEY(employee_id) REFERENCES employees(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS leave_requests (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 employee_id INT UNSIGNED NOT NULL,
 leave_type ENUM('casual','sick','earned','unpaid','other') NOT NULL,
 start_date DATE NOT NULL,
 end_date DATE NOT NULL,
 reason VARCHAR(500) NOT NULL,
 status ENUM('pending','approved','rejected') NOT NULL DEFAULT 'pending',
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 INDEX idx_leave_employee(employee_id), INDEX idx_leave_dates(start_date,end_date), INDEX idx_leave_status(status),
 FOREIGN KEY(employee_id) REFERENCES employees(id) ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS salaries (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 employee_id INT UNSIGNED NOT NULL,
 salary_month CHAR(7) NOT NULL,
 basic_salary DECIMAL(12,2) NOT NULL,
 allowance DECIMAL(12,2) NOT NULL DEFAULT 0,
 overtime DECIMAL(12,2) NOT NULL DEFAULT 0,
 deduction DECIMAL(12,2) NOT NULL DEFAULT 0,
 net_salary DECIMAL(12,2) NOT NULL,
 created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_salary(employee_id,salary_month),
 INDEX idx_salary_month(salary_month),
 FOREIGN KEY(employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- Demo data: safe to run on a fresh database. Existing demo codes are ignored.
INSERT IGNORE INTO employees (employee_code,name,email,phone,department,designation,joining_date,basic_salary,status,address,city) VALUES
('EMP-1001','Arjun Sen','arjun.sen@example.com','9876543201','Engineering','Senior PHP Developer','2023-04-10',65000,'active','Salt Lake Sector V','Kolkata'),
('EMP-1002','Maya Roy','maya.roy@example.com','9876543202','Human Resources','HR Executive','2024-01-15',48000,'active','New Town','Kolkata'),
('EMP-1003','Rohan Das','rohan.das@example.com','9876543203','Finance','Accountant','2022-09-01',52000,'active','B.T. Road','Kolkata'),
('EMP-1004','Priya Ghosh','priya.ghosh@example.com','9876543204','Operations','Operations Manager','2021-07-19',72000,'active','Shyambazar','Kolkata'),
('EMP-1005','Sourav Paul','sourav.paul@example.com','9876543205','Support','Support Specialist','2025-02-03',39000,'active','Barrackpore','North 24 Parganas'),
('EMP-1006','Nisha Kapoor','nisha.kapoor@example.com','9876543206','Marketing','Marketing Executive','2023-11-06',45000,'inactive','Rajarhat','Kolkata');

INSERT INTO attendance(employee_id,attendance_date,status,entry_time,exit_time)
SELECT id,CURDATE(),'present','09:02:00','18:08:00' FROM employees WHERE employee_code='EMP-1001'
ON DUPLICATE KEY UPDATE status=VALUES(status),entry_time=VALUES(entry_time),exit_time=VALUES(exit_time);
INSERT INTO attendance(employee_id,attendance_date,status,entry_time,exit_time)
SELECT id,CURDATE(),'late','09:37:00','18:12:00' FROM employees WHERE employee_code='EMP-1002'
ON DUPLICATE KEY UPDATE status=VALUES(status),entry_time=VALUES(entry_time),exit_time=VALUES(exit_time);
INSERT INTO attendance(employee_id,attendance_date,status,entry_time,exit_time)
SELECT id,CURDATE(),'present','08:55:00','17:58:00' FROM employees WHERE employee_code='EMP-1003'
ON DUPLICATE KEY UPDATE status=VALUES(status),entry_time=VALUES(entry_time),exit_time=VALUES(exit_time);
INSERT INTO attendance(employee_id,attendance_date,status,entry_time,exit_time)
SELECT id,CURDATE(),'half_day','09:10:00','13:30:00' FROM employees WHERE employee_code='EMP-1004'
ON DUPLICATE KEY UPDATE status=VALUES(status),entry_time=VALUES(entry_time),exit_time=VALUES(exit_time);

INSERT INTO leave_requests(employee_id,leave_type,start_date,end_date,reason,status)
SELECT id,'casual',DATE_ADD(CURDATE(),INTERVAL 3 DAY),DATE_ADD(CURDATE(),INTERVAL 4 DAY),'Personal work','pending' FROM employees WHERE employee_code='EMP-1002';
INSERT INTO leave_requests(employee_id,leave_type,start_date,end_date,reason,status)
SELECT id,'sick',DATE_SUB(CURDATE(),INTERVAL 2 DAY),DATE_SUB(CURDATE(),INTERVAL 1 DAY),'Medical rest','approved' FROM employees WHERE employee_code='EMP-1005';

INSERT INTO salaries(employee_id,salary_month,basic_salary,allowance,overtime,deduction,net_salary)
SELECT id,DATE_FORMAT(CURDATE(),'%Y-%m'),basic_salary,5000,2500,1200,basic_salary+5000+2500-1200 FROM employees WHERE employee_code='EMP-1001'
ON DUPLICATE KEY UPDATE basic_salary=VALUES(basic_salary),allowance=VALUES(allowance),overtime=VALUES(overtime),deduction=VALUES(deduction),net_salary=VALUES(net_salary);
INSERT INTO salaries(employee_id,salary_month,basic_salary,allowance,overtime,deduction,net_salary)
SELECT id,DATE_FORMAT(CURDATE(),'%Y-%m'),basic_salary,3500,1000,700,basic_salary+3500+1000-700 FROM employees WHERE employee_code='EMP-1002'
ON DUPLICATE KEY UPDATE basic_salary=VALUES(basic_salary),allowance=VALUES(allowance),overtime=VALUES(overtime),deduction=VALUES(deduction),net_salary=VALUES(net_salary);
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
