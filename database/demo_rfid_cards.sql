USE employee_management;
INSERT IGNORE INTO rfid_cards (employee_id, uid, card_type, status)
SELECT id, '04A831927C61', 'MIFARE', 'active' FROM employees WHERE employee_code='EMP-1001';
INSERT IGNORE INTO rfid_cards (employee_id, uid, card_type, status)
SELECT id, '04B921827D22', 'MIFARE', 'active' FROM employees WHERE employee_code='EMP-1002';
INSERT IGNORE INTO rfid_cards (employee_id, uid, card_type, status)
SELECT id, '047721829A55', 'MIFARE', 'active' FROM employees WHERE employee_code='EMP-1003';
INSERT IGNORE INTO attendance_devices (device_code, device_name, location, status)
VALUES ('GATE-01','Main Gate RFID Kiosk','Main Gate','active');
