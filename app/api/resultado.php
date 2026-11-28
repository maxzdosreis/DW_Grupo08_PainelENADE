<?php

require_once __DIR__ . '/../includes/resposta.php';
require_once __DIR__ . '/../includes/db.php';
require_once __DIR__ . '/../includes/auth.php';
require_once __DIR__ . '/../includes/formatacao.php';
require_once __DIR__ . '/../includes/parametros.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    header('Allow: GET');
    responder_json(['ok' => false, 'erro' => 'Método não permitido.'], 405);
    exit;
}

exigir_login();

function para_int($valor)
{
    return $valor === null ? null : (int) $valor;
}

function para_float($valor)
{
    return $valor === null ? null : (float) $valor;
}

$ofertaId = ler_inteiro_query('oferta_id');
if ($ofertaId === null || $ofertaId === false) {
    responder_json(['ok' => false, 'erro' => 'Informe oferta_id como um número inteiro positivo.'], 422);
    exit;
}

$ano = ler_inteiro_query('ano', 4);
if ($ano === false) {
    responder_json(['ok' => false, 'erro' => 'O ano deve ter 4 dígitos (ex.: 2015).'], 422);
    exit;
}

try {
    $pdo = conectar();

    $stmt = $pdo->prepare(
        'SELECT id, codigo, curso, grau_academico, modalidade
         FROM oferta
         WHERE id = ?'
    );
    $stmt->execute([$ofertaId]);
    $o = $stmt->fetch();

    if (!$o) {
        responder_json(['ok' => false, 'erro' => 'Oferta não encontrada.'], 404);
        exit;
    }

    $colunas = 'ano, inscritos, participantes, nota_formacao_geral,
                nota_componente_especifico, conceito_continuo, conceito_faixa,
                ponto_forte, ponto_atencao, origem_dado';
    if ($ano !== null) {
        $stmt = $pdo->prepare(
            "SELECT $colunas FROM resultado WHERE oferta_id = ? AND ano = ?"
        );
        $stmt->execute([$ofertaId, $ano]);
    } else {
        $stmt = $pdo->prepare(
            "SELECT $colunas FROM resultado WHERE oferta_id = ? ORDER BY ano DESC LIMIT 1"
        );
        $stmt->execute([$ofertaId]);
    }
    $r = $stmt->fetch();

    $a = false;
    if ($r) {
        $stmt = $pdo->prepare(
            'SELECT ano, conceito_faixa, conceito_continuo
             FROM resultado
             WHERE oferta_id = ? AND ano < ?
             ORDER BY ano DESC
             LIMIT 1'
        );
        $stmt->execute([$ofertaId, $r['ano']]);
        $a = $stmt->fetch();
    }
} catch (PDOException $e) {
    error_log('Erro ao buscar resultado: ' . $e->getMessage());
    responder_json(['ok' => false, 'erro' => 'Erro interno. Tente novamente.'], 500);
    exit;
}

$oferta = [
    'id' => (int) $o['id'],
    'codigo' => $o['codigo'],
    'curso' => $o['curso'],
    'grau_academico' => $o['grau_academico'],
    'modalidade' => $o['modalidade'],
    'rotulo' => montar_rotulo($o['curso'], $o['grau_academico'], $o['modalidade']),
];

if (!$r) {
    responder_json([
        'ok' => true,
        'oferta' => $oferta,
        'ano' => $ano,
        'resultado' => null,
        'mensagem' => 'Sem dados para esta oferta/edição.',
    ]);
    exit;
}

$inscritos = para_int($r['inscritos']);
$participantes = para_int($r['participantes']);
$notaFg = para_float($r['nota_formacao_geral']);
$notaCe = para_float($r['nota_componente_especifico']);

$participacao = null;
if ($inscritos !== null && $inscritos > 0 && $participantes !== null) {
    $participacao = round($participantes / $inscritos * 100, 1);
}

$diferenca = null;
if ($notaFg !== null && $notaCe !== null) {
    $diferenca = round($notaFg - $notaCe, 4);
}

$resultado = [
    'inscritos' => $inscritos,
    'participantes' => $participantes,
    'participacao' => $participacao,
    'nota_formacao_geral' => $notaFg,
    'nota_componente_especifico' => $notaCe,
    'diferenca_fg_ce' => $diferenca,
    'conceito_continuo' => para_float($r['conceito_continuo']),
    'conceito_faixa' => $r['conceito_faixa'],
    'ponto_forte' => $r['ponto_forte'],
    'ponto_atencao' => $r['ponto_atencao'],
    'origem_dado' => $r['origem_dado'],
];

$anterior = null;
if ($a) {
    $variacao = null;
    $faixaAtual = $r['conceito_faixa'];
    $faixaAnterior = $a['conceito_faixa'];
    if ($faixaAtual !== null && $faixaAnterior !== null
        && ctype_digit($faixaAtual) && ctype_digit($faixaAnterior)) {
        $variacao = (int) $faixaAtual - (int) $faixaAnterior;
    }

    $anterior = [
        'ano' => (int) $a['ano'],
        'conceito_faixa' => $a['conceito_faixa'],
        'conceito_continuo' => para_float($a['conceito_continuo']),
        'variacao_faixa' => $variacao,
    ];
}

responder_json([
    'ok' => true,
    'oferta' => $oferta,
    'ano' => (int) $r['ano'],
    'resultado' => $resultado,
    'anterior' => $anterior,
]);
