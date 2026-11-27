<?php

function montar_rotulo($curso, $grau, $modalidade)
{
    $curso = mb_convert_case($curso, MB_CASE_TITLE, 'UTF-8');

    $curso = preg_replace_callback(
        '/(?<=\s)(De|Da|Do|Das|Dos|E|Em)(?=\s)/u',
        function ($m) {
            return mb_strtolower($m[1], 'UTF-8');
        },
        $curso
    );

    if ($modalidade === 'Educação Presencial') {
        $modalidade = 'Presencial';
    } elseif ($modalidade === 'Educação a Distância') {
        $modalidade = 'EaD';
    }

    return $curso . ' · ' . $grau . ' · ' . $modalidade;
}
