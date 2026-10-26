# Employee RFID Attendance System

A professional employee management and RFID-based attendance system built with **PHP OOP, MySQL, REST API, JavaScript, and Python**.

The system provides employee management, attendance tracking, leave management, salary management, RFID card registration, live attendance monitoring, and a dedicated RFID kiosk with offline retry support.

---

## 🚀 Features

### Employee Management

- Employee CRUD operations
- Employee registration and management
- Employee profile management
- Department and employee information
- Employee deletion

### 📡 RFID Attendance

- RFID card registration and replacement
- 13.56MHz MIFARE/NFC RFID support
- Automatic IN/OUT detection
- Duplicate tap protection
- Unique event ID for reliable attendance processing
- Raw RFID punch audit logging
- Daily attendance summary
- Live attendance monitoring
- Device heartbeat tracking

### 🖥️ RFID Kiosk

- Dedicated attendance kiosk interface
- Keyboard-wedge RFID reader support
- USB Virtual COM reader support
- Success/error feedback
- WebAudio attendance beep
- Browser-based offline queue
- Automatic retry when connection is restored

### 📊 Attendance System

- Live attendance dashboard
- Attendance history
- IN/OUT punch tracking
- Duplicate punch prevention
- Offline punch synchronization
- Reliable attendance event processing

### 📝 Leave Management

- Employee leave requests
- Leave management
- Leave status tracking

### 💰 Salary Management

- Employee salary records
- Salary management module
- Salary information tracking

### 🔌 REST API

- REST-style API architecture
- RFID attendance API
- Employee data processing
- JSON-based API responses
- Event ID based idempotent processing

### 🐍 Python RFID Service

- Python-based local RFID reader bridge
- USB Virtual COM reader support
- SQLite offline queue
- Automatic retry of unsent RFID events
- API communication using HTTP requests

---

## 🛠️ Technologies Used

### Backend

- PHP
- PHP OOP
- MySQL
- REST API

### Frontend

- HTML5
- CSS3
- JavaScript

### RFID Service

- Python 3.10+
- PySerial
- Requests
- SQLite

### Development Tools

- XAMPP / WAMP
- MySQL / phpMyAdmin
- Git
- GitHub

---

## 📁 Project Structure

```text
employee-rfid-attendance-system/
│
├── api/
│   └── index.php
│
├── classes/
│   ├── Attendance.php
│   ├── Employee.php
│   ├── LeaveRequest.php
│   ├── RfidAttendance.php
│   └── Salary.php
│
├── config/
│   ├── bootstrap.php
│   ├── config.php
│   └── Database.php
│
├── database/
│   ├── database.sql
│   ├── demo_rfid_cards.sql
│   ├── install.sql
│   └── rfid_migration.sql
│
├── kiosk/
│   ├── assets/
│   │   ├── css/
│   │   └── js/
│   └── index.php
│
├── partials/
│   ├── header.php
│   └── footer.php
│
├── public/
│   ├── assets/
│   │   ├── css/
│   │   └── js/
│   │
│   ├── api-docs.php
│   ├── attendance.php
│   ├── employee-delete.php
│   ├── employee-form.php
│   ├── employees.php
│   ├── index.php
│   ├── leave.php
│   ├── live-attendance.php
│   ├── rfid.php
│   └── salary.php
│
├── services/
│   └── rfid_service/
│       ├── reader_service.py
│       ├── simulate_50.py
│       └── requirements.txt
│
├── .gitignore
└── README.md
```

---

# ⚙️ Installation

## 1. Clone the Repository

```bash
git clone https://github.com/YOUR_USERNAME/employee-rfid-attendance-system.git
```

Move into the project directory:

```bash
cd employee-rfid-attendance-system
```

---

## 2. XAMPP Setup

Install and start **XAMPP**.

Start:

- Apache
- MySQL

Place the project inside:

```text
C:\xampp\htdocs\
```

The final path should look like:

```text
C:\xampp\htdocs\employee-rfid-attendance-system\
```

---

## 3. Create the Database

Open phpMyAdmin:

```text
http://localhost/phpmyadmin
```

Create the required MySQL database.

The default project configuration uses:

```text
Database: employee_management
Username: root
Password: empty
Host: localhost
```

---

## 4. Import Database Files

Import the SQL files in the following order:

### Step 1

```text
database/database.sql
```

### Step 2

```text
database/rfid_migration.sql
```

### Optional Demo RFID Cards

```text
database/demo_rfid_cards.sql
```

---

## 5. Configure Database

Open:

```text
config/config.php
```

Update the database settings according to your local environment.

Example:

```php
const DB_HOST = 'localhost';
const DB_NAME = 'employee_management';
const DB_USER = 'root';
const DB_PASS = '';
```

---

# 🌐 Running the Application

After starting Apache and MySQL, open:

### Admin / Management

```text
http://localhost/employee-rfid-attendance-system/public/
```

### RFID Kiosk

```text
http://localhost/employee-rfid-attendance-system/kiosk/
```

---

# 📡 RFID Setup

The system supports:

- Keyboard-emulation RFID readers
- USB Virtual COM RFID readers

For keyboard-wedge readers, the kiosk can receive RFID input directly from the browser.

For Virtual COM readers, use the included Python RFID service.

---

# 🐍 Python RFID Service

Go to:

```text
services/rfid_service/
```

Install Python dependencies:

```bash
pip install -r requirements.txt
```

The service uses:

- `pyserial`
- `requests`

Run the RFID reader service:

```bash
python reader_service.py --port COM3 --api http://localhost/employee-rfid-attendance-system/api/index.php --device GATE-01
```

Replace `COM3` with the actual RFID reader COM port.

---

# 🔄 Offline Reliability

The system is designed to handle temporary network interruptions.

### Browser Kiosk

The browser kiosk can temporarily store unsent RFID events and retry them when the connection is restored.

### Python RFID Service

The local RFID service uses SQLite to store unsent events and automatically retries them.

### Server

Each attendance punch contains a unique `event_id`.

The server prevents the same event from being processed multiple times.

This provides **idempotent attendance processing** and helps prevent duplicate attendance records.

---

# 🔐 Security Considerations

- Use prepared statements for database operations.
- Do not commit database passwords or API secrets.
- Keep production credentials outside the repository.
- Use environment-specific configuration for production deployments.
- Validate RFID and employee input on the server side.

---

# 🧪 Testing

Recommended testing checklist:

- Test employee creation
- Test employee update
- Test employee deletion
- Test attendance recording
- Test RFID card registration
- Test valid RFID card
- Test invalid RFID card
- Test rapid duplicate RFID taps
- Test live attendance dashboard
- Test leave management
- Test salary management
- Test offline RFID queue
- Test synchronization after reconnecting
- Test API responses
- Test database import on a clean MySQL database

---

# 📋 Database Components

The project includes SQL files for:

- Main database structure
- RFID migration
- Demo RFID cards
- Installation setup

```text
database/
├── database.sql
├── rfid_migration.sql
├── demo_rfid_cards.sql
└── install.sql
```

---

# 🎯 Project Purpose

This project was developed as a professional employee management and RFID attendance solution combining:

- PHP Object-Oriented Programming
- MySQL database management
- REST API development
- JavaScript frontend functionality
- RFID hardware integration
- Python service development
- Offline event processing
- Real-time attendance monitoring

---

# 👨‍💻 Author

**Soumo**

---

## ⭐ Repository

If you find this project useful, consider giving the repository a ⭐ star.

---