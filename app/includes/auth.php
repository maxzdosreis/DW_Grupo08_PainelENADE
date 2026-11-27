<?php

require_once __DIR__ . '/resposta.php';

function iniciar_sessao()
{
    if (session_status() !== PHP_SESSION_ACTIVE) {
        session_set_cookie_params([
            'httponly' => true,
            'samesite' => 'Lax',
        ]);
        session_start();
    }
}

function usuario_logado()
{
    iniciar_sessao();
    return $_SESSION['usuario'] ?? null;
}

function exigir_login()
{
    $usuario = usuario_logado();
    if ($usuario === null) {
        responder_json([
            'ok' => false,
            'erro' => 'Sessão expirada ou usuário não autenticado.',
        ], 401);
        exit;
    }
    return $usuario;
}
