<?php

function ler_inteiro_query($nome, $digitos = null)
{
    if (!isset($_GET[$nome])) {
        return null;
    }

    $valor = $_GET[$nome];

    if (!is_string($valor)) {
        return false;
    }

    $valor = trim($valor);
    if ($valor === '') {
        return null;
    }

    if ($digitos !== null) {
        $padrao = '/^\d{' . (int) $digitos . '}$/';
    } else {
        $padrao = '/^[1-9]\d{0,8}$/';
    }

    if (!preg_match($padrao, $valor)) {
        return false;
    }

    return (int) $valor;
}
