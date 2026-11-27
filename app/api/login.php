<?php

require_once __DIR__ . '/../includes/resposta.php';
require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/auth.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Allow: POST');
    responder_json(['ok' => false, 'erro' => 'Método não permitido.'], 405);
    exit;
}

$entrada = json_decode(file_get_contents('php://input'), true);
if (!is_array($entrada)) {
    $entrada = $_POST;
}

$login = trim((string) ($entrada['login'] ?? ''));
$senha = (string) ($entrada['senha'] ?? '');

if ($login === '' || $senha === '') {
    responder_json(['ok' => false, 'erro' => 'Informe o login e a senha.'], 422);
    exit;
}

try {
    $pdo = conectar();
    $stmt = $pdo->prepare('SELECT id, nome, login, senha FROM usuario WHERE login = :login');
    $stmt->execute([':login' => $login]);
    $usuario = $stmt->fetch();
} catch (PDOException $e) {
    error_log('Erro no login: ' . $e->getMessage());
    responder_json(['ok' => false, 'erro' => 'Erro interno. Tente novamente.'], 500);
    exit;
}

if (!$usuario || !password_verify($senha, $usuario['senha'])) {
    responder_json(['ok' => false, 'erro' => 'Login ou senha inválidos.'], 401);
    exit;
}

iniciar_sessao();
session_regenerate_id(true);

$_SESSION['usuario'] = [
    'id' => (int) $usuario['id'],
    'nome' => $usuario['nome'],
    'login' => $usuario['login'],
];

responder_json([
    'ok' => true,
    'usuario' => ['nome' => $usuario['nome'], 'login' => $usuario['login']],
]);
