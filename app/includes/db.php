<?php

require_once __DIR__ . '/resposta.php';

function conectar()
{
    static $pdo = null;

    if ($pdo !== null) {
        return $pdo;
    }

    $arquivoConfig = __DIR__ . '/../config/config.php';
    if (!file_exists($arquivoConfig)) {
        responder_json([
            'ok' => false,
            'erro' => 'Arquivo app/config/config.php não encontrado. '
                . 'Copie app/config/config.example.php para app/config/config.php.',
        ], 500);
        exit;
    }
    require_once $arquivoConfig;

    $dsn = 'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=' . DB_CHARSET;

    try {
        $pdo = new PDO($dsn, DB_USER, DB_PASS, [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES => false,
        ]);
    } catch (PDOException $e) {
        error_log('Erro ao conectar no banco: ' . $e->getMessage());
        responder_json(['ok' => false, 'erro' => 'Erro interno. Tente novamente.'], 500);
        exit;
    }

    return $pdo;
}
