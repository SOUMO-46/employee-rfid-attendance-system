<?php
declare(strict_types=1);
require_once __DIR__ . '/config.php';
class Database {
    private mysqli $connection;
    public function __construct() {
        mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
        $this->connection = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);
        $this->connection->set_charset('utf8mb4');
    }
    public function getConnection(): mysqli { return $this->connection; }
}
