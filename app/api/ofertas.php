<?php

require_once __DIR__ . '/../includes/resposta.php';
require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/formatacao.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    header('Allow: GET');
    responder_json(['ok' => false, 'erro' => 'Método não permitido.'], 405);
    exit;
}

exigir_login();

try {
    $pdo = conectar();

    $stmt = $pdo->prepare(
        'SELECT id, codigo, recorte_id, curso, grau_academico, modalidade
         FROM oferta
         ORDER BY codigo'
    );
    $stmt->execute();
    $linhasOfertas = $stmt->fetchAll();

    $stmt = $pdo->prepare(
        'SELECT oferta_id, ano, origem_dado
         FROM resultado
         ORDER BY ano DESC'
    );
    $stmt->execute();
    $linhasEdicoes = $stmt->fetchAll();
} catch (PDOException $e) {
    error_log('Erro ao listar ofertas: ' . $e->getMessage());
    responder_json(['ok' => false, 'erro' => 'Erro interno. Tente novamente.'], 500);
    exit;
}

$edicoesPorOferta = [];
foreach ($linhasEdicoes as $e) {
    $edicoesPorOferta[$e['oferta_id']][] = [
        'ano' => (int) $e['ano'],
        'origem_dado' => $e['origem_dado'],
    ];
}

$ofertas = [];
foreach ($linhasOfertas as $o) {
    $ofertas[] = [
        'id' => (int) $o['id'],
        'codigo' => $o['codigo'],
        'curso' => $o['curso'],
        'grau_academico' => $o['grau_academico'],
        'modalidade' => $o['modalidade'],
        'rotulo' => montar_rotulo($o['curso'], $o['grau_academico'], $o['modalidade']),
        'edicoes' => $edicoesPorOferta[$o['id']] ?? [],
    ];
}

$recorte = count($linhasOfertas) > 0 ? $linhasOfertas[0]['recorte_id'] : null;

responder_json([
    'ok' => true,
    'recorte' => $recorte,
    'ofertas' => $ofertas,
]);
