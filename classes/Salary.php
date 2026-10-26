<?php
declare(strict_types=1);
class Salary {
 public function __construct(private mysqli $db) {}
 public function save(array $d): bool { $month=(string)($d['salary_month']??''); if(!preg_match('/^\d{4}-(0[1-9]|1[0-2])$/',$month)) throw new InvalidArgumentException('Invalid salary month.'); $d['basic_salary']=money($d['basic_salary']??0); $d['allowance']=money($d['allowance']??0); $d['overtime']=money($d['overtime']??0); $d['deduction']=money($d['deduction']??0); $gross=$d['basic_salary']+$d['allowance']+$d['overtime']; $net=max(0,$gross-$d['deduction']); $employeeId=(int)($d['employee_id']??0); if($employeeId<1)throw new InvalidArgumentException('Invalid employee.');
  $check=$this->db->prepare('SELECT id FROM employees WHERE id=?'); $check->bind_param('i',$employeeId); $check->execute(); if(!$check->get_result()->fetch_assoc()) throw new InvalidArgumentException('Employee not found.'); $s=$this->db->prepare('INSERT INTO salaries(employee_id,salary_month,basic_salary,allowance,overtime,deduction,net_salary) VALUES(?,?,?,?,?,?,?) ON DUPLICATE KEY UPDATE basic_salary=VALUES(basic_salary),allowance=VALUES(allowance),overtime=VALUES(overtime),deduction=VALUES(deduction),net_salary=VALUES(net_salary)'); $s->bind_param('isddddd',$employeeId,$month,$d['basic_salary'],$d['allowance'],$d['overtime'],$d['deduction'],$net); return $s->execute(); }
 public function all(): array { return $this->db->query('SELECT s.*,e.employee_code,e.name FROM salaries s JOIN employees e ON e.id=s.employee_id ORDER BY s.salary_month DESC,s.id DESC')->fetch_all(MYSQLI_ASSOC); }
}
