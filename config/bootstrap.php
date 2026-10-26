<?php
declare(strict_types=1);
if (session_status() !== PHP_SESSION_ACTIVE) session_start();
require_once __DIR__.'/config.php'; require_once __DIR__.'/Database.php';
foreach (['Employee','Attendance','LeaveRequest','Salary','RfidAttendance'] as $class) require_once __DIR__.'/../classes/'.$class.'.php';
function e(mixed $v): string { return htmlspecialchars((string)($v ?? ''), ENT_QUOTES, 'UTF-8'); }
function redirect(string $url): never { header('Location: '.$url); exit; }
function csrf_token(): string { if(empty($_SESSION['csrf_token'])) $_SESSION['csrf_token']=bin2hex(random_bytes(32)); return $_SESSION['csrf_token']; }
function verify_csrf(?string $token): void { if(!$token||!hash_equals($_SESSION['csrf_token']??'', $token)) throw new RuntimeException('Invalid security token. Refresh and try again.'); }
function valid_date(string $d): bool { $x=DateTime::createFromFormat('Y-m-d',$d); return $x && $x->format('Y-m-d')===$d; }
function money(mixed $v): float { $n=(float)$v; if($n<0) throw new InvalidArgumentException('Amount cannot be negative.'); return round($n,2); }
function json_response(array $data,int $status=200): never { http_response_code($status); header('Content-Type: application/json; charset=utf-8'); echo json_encode($data,JSON_UNESCAPED_UNICODE); exit; }
