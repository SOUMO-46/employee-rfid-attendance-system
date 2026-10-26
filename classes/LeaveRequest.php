<?php
declare(strict_types=1);
class LeaveRequest {
 public function __construct(private mysqli $db) {}
 public function create(array $d): bool { $type=(string)($d['leave_type']??''); $allowed=['casual','sick','earned','unpaid','other']; $start=(string)($d['start_date']??''); $end=(string)($d['end_date']??''); if((int)($d['employee_id']??0)<1||!in_array($type,$allowed,true)||!valid_date($start)||!valid_date($end)||$end<$start||trim((string)($d['reason']??''))==='') throw new InvalidArgumentException('Please provide valid leave details.'); $employeeId=(int)$d['employee_id']; $check=$this->db->prepare('SELECT id FROM employees WHERE id=?'); $check->bind_param('i',$employeeId); $check->execute(); if(!$check->get_result()->fetch_assoc()) throw new InvalidArgumentException('Employee not found.');
  $over=$this->db->prepare('SELECT id FROM leave_requests WHERE employee_id=? AND status IN ("pending","approved") AND start_date<=? AND end_date>=? LIMIT 1'); $over->bind_param('iss',$employeeId,$end,$start); $over->execute(); if($over->get_result()->fetch_assoc()) throw new InvalidArgumentException('This employee already has an overlapping leave request.');
  $reason=trim((string)$d['reason']); $s=$this->db->prepare('INSERT INTO leave_requests(employee_id,leave_type,start_date,end_date,reason,status) VALUES(?,?,?,?,?,"pending")'); $s->bind_param('issss',$employeeId,$type,$start,$end,$reason); return $s->execute(); }
 public function all(): array { return $this->db->query('SELECT l.*,e.employee_code,e.name FROM leave_requests l JOIN employees e ON e.id=l.employee_id ORDER BY l.id DESC')->fetch_all(MYSQLI_ASSOC); }
 public function status(int $id,string $status): bool { if($id<1||!in_array($status,['approved','rejected'],true)) throw new InvalidArgumentException('Invalid leave status.'); $s=$this->db->prepare('UPDATE leave_requests SET status=? WHERE id=? AND status="pending"'); $s->bind_param('si',$status,$id); return $s->execute(); }
}
