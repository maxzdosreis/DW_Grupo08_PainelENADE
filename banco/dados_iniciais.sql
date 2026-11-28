USE painel_enade;

-- Dados iniciais do Painel ENADE (T04 e T05) - gerado por scripts/gerar_dados_iniciais.py
-- Conteúdo: ofertas e resultados do R09; usuário de demonstração (demo) e 3 ações de
-- exemplo (2 com anexo em app/uploads/).
-- Fonte: arquivo do professor datasets_enade_2015_2025/dados_por_recorte/R09_enade_2015_2025.csv (recorte R09).
-- Total: 22 resultados em 2 ofertas (4 OFICIAL_INEP e 18 SIMULADO_DIDATICO).
-- origem_dado foi mantido exatamente como no CSV: dados simulados NAO sao oficiais.
-- ATENCAO: ponto_forte e ponto_atencao sao SUGESTOES do CSV (ponto_forte_sugerido /
-- ponto_atencao_sugerido) e devem ser revisados pelo grupo.
-- Execute depois de banco/estrutura.sql (que recria as tabelas vazias).

INSERT INTO oferta (codigo, recorte_id, curso, grau_academico, modalidade) VALUES
('O07', 'R09', 'DIREITO', 'Bacharelado', 'Educação Presencial'),
('O35', 'R09', 'TECNOLOGIA EM GESTÃO PÚBLICA', 'Tecnológico', 'Educação a Distância');

INSERT INTO resultado (oferta_id, ano, inscritos, participantes, nota_formacao_geral,
    nota_componente_especifico, conceito_continuo, conceito_faixa, ponto_forte, ponto_atencao, origem_dado) VALUES
((SELECT id FROM oferta WHERE codigo='O07'), 2015, 64, 60, 56.5933, 38.575, 1.9632, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'OFICIAL_INEP'),
((SELECT id FROM oferta WHERE codigo='O07'), 2016, 64, 61, 53.14, 37.61, 1.9025, '2', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2017, 63, 60, 49.38, 36.5, 1.881, '2', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2018, 62, 59, 45.46949, 35.25763, 1.84629, '2', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'OFICIAL_INEP'),
((SELECT id FROM oferta WHERE codigo='O07'), 2019, 76, 71, 48.02, 36.24, 1.9693, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2020, 87, 80, 50.93, 37.54, 2.1333, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2021, 102, 92, 54.02, 39.5, 2.2812, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2022, 114, 101, 56.781, 40.504, 2.394, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'OFICIAL_INEP'),
((SELECT id FROM oferta WHERE codigo='O07'), 2023, 114, 99, 58.46, 42.67, 2.5228, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2024, 115, 98, 58.83, 41.74, 2.6744, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O07'), 2025, 121, 102, 59.1, 43.05, 2.7228, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2015, 8, 6, 51.84, 51.48, 2.6282, '3', 'Desempenho equilibrado entre Formação Geral e Componente Específico', 'Manter acompanhamento da participação e da evolução histórica', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2016, 8, 6, 51.64, 51.23, 2.7282, '3', 'Desempenho equilibrado entre Formação Geral e Componente Específico', 'Manter acompanhamento da participação e da evolução histórica', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2017, 8, 6, 51.01, 50.96, 2.6985, '3', 'Desempenho equilibrado entre Formação Geral e Componente Específico', 'Manter acompanhamento da participação e da evolução histórica', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2018, 9, 6, 51.72, 51.14, 2.7694, '3', 'Desempenho equilibrado entre Formação Geral e Componente Específico', 'Manter acompanhamento da participação e da evolução histórica', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2019, 9, 6, 51.81, 49.49, 2.8669, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2020, 11, 7, 51.7, 51.06, 2.7983, '3', 'Desempenho equilibrado entre Formação Geral e Componente Específico', 'Manter acompanhamento da participação e da evolução histórica', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2021, 9, 6, 51.51, 49.41, 2.9405, '3', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2022, 14, 9, 52.388, 50.1, 2.996, '4', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'OFICIAL_INEP'),
((SELECT id FROM oferta WHERE codigo='O35'), 2023, 19, 13, 51.95, 49.02, 3.02, '4', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2024, 18, 12, 52.61, 48.34, 2.9708, '4', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO'),
((SELECT id FROM oferta WHERE codigo='O35'), 2025, 25, 18, 51.75, 46.8, 3.0221, '4', 'Formação Geral com resultado superior ao Componente Específico', 'Acompanhar o desempenho no Componente Específico', 'SIMULADO_DIDATICO');

-- Usuário de demonstração (login: demo / senha: demo123).
-- A senha é guardada com password_hash(..., PASSWORD_DEFAULT), nunca em texto puro.
-- CONFERIR: o PDF do projeto pede o usuário "no formato utilizado no exemplo da aula";
-- se o exemplo da aula usar outro formato (texto puro, md5...), ajustar HASH_DEMO e o login.
INSERT INTO usuario (nome, login, senha) VALUES
('Usuário demonstrador', 'demo', '$2y$12$e6CxI2JMsQfpiNk3aJSqWOeOxV4RvAzj/TQFxNPLO8zVpNb8UcL8C');

-- Ações de exemplo das ofertas O07 e O35. Anexos reais em app/uploads/ (gerados por
-- scripts/gerar_anexos_demo.py); anexo_arquivo guarda só o nome armazenado.
INSERT INTO acao (oferta_id, titulo, descricao, situacao, responsavel, prazo,
    anexo_nome_original, anexo_arquivo) VALUES
((SELECT id FROM oferta WHERE codigo='O07'), 'Revisar conteúdos de raciocínio jurídico e interpretação de textos', 'Revisar ementas e atividades das disciplinas que trabalham argumentação jurídica e leitura de textos, alinhando-as ao perfil de questões do ENADE.', 'Em andamento', 'NDE do curso', '2026-11-30', 'plano.pdf', 'demo_plano_acao.pdf'),
((SELECT id FROM oferta WHERE codigo='O35'), 'Aplicar simulado interdisciplinar de Gestão Pública', 'Simulado com questões de formação geral e de componente específico para os concluintes, com devolutiva por área aos estudantes.', 'Concluída', 'Coordenação', '2026-10-15', 'registro_oficina.png', 'demo_registro_oficina.png'),
((SELECT id FROM oferta WHERE codigo='O07'), 'Oficina de questões discursivas', 'Oficina prática para treinar a resolução e a correção de questões discursivas com os estudantes do último ano.', 'Planejada', 'Docentes', '2027-03-20', NULL, NULL);
