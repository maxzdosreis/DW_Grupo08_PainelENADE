<?php

require_once __DIR__ . '/../includes/resposta.php';
require_once __DIR__ . '/../includes/auth.php';

$usuario = exigir_login();

responder_json([
    'ok' => true,
    'usuario' => ['nome' => $usuario['nome'], 'login' => $usuario['login']],
]);
