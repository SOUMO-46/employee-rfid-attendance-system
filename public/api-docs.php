<?php $title='REST API'; require_once __DIR__.'/../partials/header.php'; ?><section class="panel"><div class="panel-head"><h2>REST API</h2><span class="badge active">JSON</span></div><p class="muted">Base URL: <code>/api/index.php</code>. All write endpoints accept JSON request bodies.</p><pre class="api-code">GET    /api/index.php?resource=employees
GET    /api/index.php?resource=employees&id=1
POST   /api/index.php?resource=employees
PUT    /api/index.php?resource=employees&id=1
DELETE /api/index.php?resource=employees&id=1
GET    /api/index.php?resource=attendance
POST   /api/index.php?resource=attendance
GET    /api/index.php?resource=leave
POST   /api/index.php?resource=leave
GET    /api/index.php?resource=salary
POST   /api/index.php?resource=salary</pre><p class="muted">For production deployment, put the API behind HTTPS, authentication, rate limiting and server-level access controls.</p></section><?php require_once __DIR__.'/../partials/footer.php'; ?>