CREATE DATABASE IF NOT EXISTS painel_enade CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE painel_enade;

-- Remoção na ordem inversa das chaves estrangeiras.
DROP TABLE IF EXISTS acao;
DROP TABLE IF EXISTS resultado;
DROP TABLE IF EXISTS oferta;
DROP TABLE IF EXISTS usuario;

-- Usuários do sistema (login). O formato do hash da senha é definido na T05;
-- nenhum registro é inserido aqui.
CREATE TABLE usuario (
    id    INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome  VARCHAR(100) NOT NULL,
    login VARCHAR(50)  NOT NULL,
    senha VARCHAR(255) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_usuario_login (login)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Oferta = combinação de curso, grau acadêmico e modalidade (ex.: O01).
CREATE TABLE oferta (
    id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
    codigo         VARCHAR(10)  NOT NULL,   -- ex.: O01
    recorte_id     VARCHAR(5)   NOT NULL,   -- ex.: R01
    curso          VARCHAR(150) NOT NULL,
    grau_academico VARCHAR(50)  NOT NULL,
    modalidade     VARCHAR(50)  NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_oferta_codigo (codigo),
    UNIQUE KEY uq_oferta_curso_grau_modalidade (curso, grau_academico, modalidade)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Resultado do ENADE de uma oferta em um ano.
-- A participação NÃO é coluna: é calculada nas consultas
-- (participantes / inscritos * 100).
-- origem_dado distingue dado oficial do INEP de dado simulado (didático);
-- nunca misturar nem alterar.
CREATE TABLE resultado (
    id                         INT UNSIGNED NOT NULL AUTO_INCREMENT,
    oferta_id                  INT UNSIGNED NOT NULL,
    ano                        SMALLINT     NOT NULL,
    inscritos                  INT          NULL,
    participantes              INT          NULL,
    nota_formacao_geral        DECIMAL(7,4) NULL,
    nota_componente_especifico DECIMAL(7,4) NULL,
    conceito_continuo          DECIMAL(6,4) NULL,
    conceito_faixa             VARCHAR(2)   NULL,       -- '1' a '5' ou 'SC'
    ponto_forte                VARCHAR(255) NULL,
    ponto_atencao              VARCHAR(255) NULL,
    origem_dado ENUM('OFICIAL_INEP','SIMULADO_DIDATICO') NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_resultado_oferta_ano (oferta_id, ano),
    CONSTRAINT fk_resultado_oferta FOREIGN KEY (oferta_id) REFERENCES oferta (id),
    CONSTRAINT ck_resultado_participantes CHECK (participantes <= inscritos),
    CONSTRAINT ck_resultado_nota_fg CHECK (nota_formacao_geral BETWEEN 0 AND 100),
    CONSTRAINT ck_resultado_nota_ce CHECK (nota_componente_especifico BETWEEN 0 AND 100),
    CONSTRAINT ck_resultado_conceito CHECK (conceito_continuo BETWEEN 0 AND 5),
    CONSTRAINT ck_resultado_faixa CHECK (conceito_faixa IN ('1','2','3','4','5','SC'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Ações de melhoria cadastradas pelo grupo para uma oferta.
-- anexo_arquivo guarda o nome do arquivo armazenado em app/uploads/;
-- anexo_nome_original guarda o nome que o usuário enviou.
CREATE TABLE acao (
    id                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    oferta_id           INT UNSIGNED NOT NULL,
    titulo              VARCHAR(150) NOT NULL,
    descricao           TEXT         NOT NULL,
    situacao            ENUM('Planejada','Em andamento','Concluída') NOT NULL,
    responsavel         VARCHAR(100) NOT NULL,
    prazo               DATE         NOT NULL,
    anexo_nome_original VARCHAR(255) NULL,
    anexo_arquivo       VARCHAR(255) NULL,
    criado_em           TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_acao_oferta FOREIGN KEY (oferta_id) REFERENCES oferta (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
