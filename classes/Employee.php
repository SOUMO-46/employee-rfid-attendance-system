<?php
declare(strict_types=1);
class Employee {
    public function __construct(private mysqli $db) {}
    private function normalize(array $d): array {
        $d['employee_code']=trim((string)($d['employee_code']??'')); $d['name']=trim((string)($d['name']??''));
        $d['email']=trim((string)($d['email']??'')); $d['phone']=trim((string)($d['phone']??''));
        $d['department']=trim((string)($d['department']??'')); $d['designation']=trim((string)($d['designation']??''));
        $d['joining_date']=trim((string)($d['joining_date']??'')); $d['basic_salary']=money($d['basic_salary']??0);
        $d['status']=in_array(($d['status']??'active'),['active','inactive'],true)?$d['status']:'active';
        if($d['employee_code']===''||$d['name']===''||!filter_var($d['email'],FILTER_VALIDATE_EMAIL)||$d['phone']===''||$d['department']===''||$d['designation']===''||!valid_date($d['joining_date'])) throw new InvalidArgumentException('Please provide valid employee details.');
        if($d['basic_salary']<0) throw new InvalidArgumentException('Salary cannot be negative.');
        $d['address']=trim((string)($d['address']??'')); $d['city']=trim((string)($d['city']??'')); return $d;
    }
    public function create(array $d): int { $d=$this->normalize($d); $s=$this->db->prepare('INSERT INTO employees (employee_code,name,email,phone,department,designation,joining_date,basic_salary,status,address,city) VALUES (?,?,?,?,?,?,?,?,?,?,?)'); $s->bind_param('sssssssdsss',$d['employee_code'],$d['name'],$d['email'],$d['phone'],$d['department'],$d['designation'],$d['joining_date'],$d['basic_salary'],$d['status'],$d['address'],$d['city']); $s->execute(); return $this->db->insert_id; }
    public function all(string $search='', int $page=1, int $perPage=10): array { $page=max(1,$page); $perPage=max(1,min(100,$perPage)); $offset=($page-1)*$perPage; $like='%'.$search.'%'; $s=$this->db->prepare('SELECT * FROM employees WHERE employee_code LIKE ? OR name LIKE ? OR email LIKE ? OR department LIKE ? OR designation LIKE ? ORDER BY id DESC LIMIT ? OFFSET ?'); $s->bind_param('sssssii',$like,$like,$like,$like,$like,$perPage,$offset); $s->execute(); $rows=$s->get_result()->fetch_all(MYSQLI_ASSOC); $c=$this->db->prepare('SELECT COUNT(*) c FROM employees WHERE employee_code LIKE ? OR name LIKE ? OR email LIKE ? OR department LIKE ? OR designation LIKE ?'); $c->bind_param('sssss',$like,$like,$like,$like,$like); $c->execute(); $total=(int)$c->get_result()->fetch_assoc()['c']; return ['rows'=>$rows,'total'=>$total,'page'=>$page,'per_page'=>$perPage]; }
    public function find(int $id): ?array { if($id<1)return null; $s=$this->db->prepare('SELECT * FROM employees WHERE id=?'); $s->bind_param('i',$id); $s->execute(); return $s->get_result()->fetch_assoc() ?: null; }
    public function update(int $id,array $d): bool { if($id<1)return false; $d=$this->normalize($d); $s=$this->db->prepare('UPDATE employees SET employee_code=?,name=?,email=?,phone=?,department=?,designation=?,joining_date=?,basic_salary=?,status=?,address=?,city=? WHERE id=?'); $s->bind_param('sssssssdsssi',$d['employee_code'],$d['name'],$d['email'],$d['phone'],$d['department'],$d['designation'],$d['joining_date'],$d['basic_salary'],$d['status'],$d['address'],$d['city'],$id); return $s->execute(); }
    public function delete(int $id): bool { if($id<1)return false; $s=$this->db->prepare('DELETE FROM employees WHERE id=?'); $s->bind_param('i',$id); return $s->execute(); }
    public function stats(): array { $r=$this->db->query("SELECT COUNT(*) total, COALESCE(SUM(status='active'),0) active FROM employees")->fetch_assoc(); $today=date('Y-m-d'); $s=$this->db->prepare("SELECT COUNT(*) c FROM attendance WHERE attendance_date=? AND status IN ('present','late','half_day')"); $s->bind_param('s',$today); $s->execute(); $r['present']=(int)$s->get_result()->fetch_assoc()['c']; $s=$this->db->prepare("SELECT COUNT(DISTINCT employee_id) c FROM leave_requests WHERE status='approved' AND start_date<=? AND end_date>=?"); $s->bind_param('ss',$today,$today); $s->execute(); $r['on_leave']=(int)$s->get_result()->fetch_assoc()['c']; return $r; }
}
