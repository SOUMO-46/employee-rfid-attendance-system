<?php
declare(strict_types=1);
class Attendance {
 public function __construct(private mysqli $db) {}
 public function save(int $employeeId,string $date,string $status,?string $entry,?string $exit): bool { $allowed=['present','absent','late','half_day','leave']; if($employeeId<1||!valid_date($date)||!in_array($status,$allowed,true)) throw new InvalidArgumentException('Invalid attendance data.');
  $check=$this->db->prepare('SELECT id FROM employees WHERE id=?'); $check->bind_param('i',$employeeId); $check->execute(); if(!$check->get_result()->fetch_assoc()) throw new InvalidArgumentException('Employee not found.'); if($entry!==null&&!preg_match('/^([01]\d|2[0-3]):[0-5]\d$/',$entry)) throw new InvalidArgumentException('Invalid entry time.'); if($exit!==null&&!preg_match('/^([01]\d|2[0-3]):[0-5]\d$/',$exit)) throw new InvalidArgumentException('Invalid exit time.');
  if($entry!==null&&$exit!==null&&$exit<$entry) throw new InvalidArgumentException('Exit time cannot be earlier than entry time.'); $s=$this->db->prepare('INSERT INTO attendance(employee_id,attendance_date,status,entry_time,exit_time) VALUES(?,?,?,?,?) ON DUPLICATE KEY UPDATE status=VALUES(status),entry_time=VALUES(entry_time),exit_time=VALUES(exit_time)'); $s->bind_param('issss',$employeeId,$date,$status,$entry,$exit); return $s->execute(); }
 public function recent(int $limit=15): array { $limit=max(1,min(100,$limit)); return $this->db->query('SELECT a.*,e.employee_code,e.name FROM attendance a JOIN employees e ON e.id=a.employee_id ORDER BY a.attendance_date DESC,a.id DESC LIMIT '.$limit)->fetch_all(MYSQLI_ASSOC); }
 public function allForEmployee(int $id): array { $s=$this->db->prepare('SELECT * FROM attendance WHERE employee_id=? ORDER BY attendance_date DESC'); $s->bind_param('i',$id); $s->execute(); return $s->get_result()->fetch_all(MYSQLI_ASSOC); }
}
