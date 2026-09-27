/* =========================================================
   DOMUS AI
   Banco de Dados - ExpoTech / GTI
   MySQL 8.0+
   
   Objetivo:
   Armazenar, organizar e disponibilizar dados de uma
   residência inteligente para análise, previsão,
   detecção de anomalias e tomada de decisão.
   ========================================================= */

DROP DATABASE IF EXISTS domus_ai;

CREATE DATABASE domus_ai
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE domus_ai;


/* =========================================================
   1. USUÁRIOS
   ========================================================= */

CREATE TABLE usuarios (
    id_usuario BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha_hash VARCHAR(255) NULL,
    telefone VARCHAR(20),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    INDEX idx_usuario_email (email)
) ENGINE=InnoDB;


/* =========================================================
   2. RESIDÊNCIAS
   ========================================================= */

CREATE TABLE residencias (
    id_residencia BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(100) NOT NULL,
    endereco VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(100),
    cep VARCHAR(10),
    tipo_residencia VARCHAR(50) DEFAULT 'Casa',
    quantidade_moradores INT UNSIGNED DEFAULT 1,
    area_m2 DECIMAL(10,2),
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_residencia_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_residencia_usuario (id_usuario)
) ENGINE=InnoDB;


/* =========================================================
   3. CÔMODOS
   ========================================================= */

CREATE TABLE comodos (
    id_comodo BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    nome VARCHAR(100) NOT NULL,
    tipo_comodo VARCHAR(50) NOT NULL,
    andar INT DEFAULT 1,
    area_m2 DECIMAL(8,2),
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_comodo_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_comodo_residencia (id_residencia)
) ENGINE=InnoDB;


/* =========================================================
   4. TIPOS DE DISPOSITIVOS
   ========================================================= */

CREATE TABLE tipos_dispositivo (
    id_tipo_dispositivo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    categoria VARCHAR(50) NOT NULL,
    descricao VARCHAR(255)
) ENGINE=InnoDB;


/* =========================================================
   5. DISPOSITIVOS
   ========================================================= */

CREATE TABLE dispositivos (
    id_dispositivo BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_comodo BIGINT UNSIGNED NOT NULL,
    id_tipo_dispositivo INT UNSIGNED NOT NULL,
    nome VARCHAR(120) NOT NULL,
    fabricante VARCHAR(100),
    modelo VARCHAR(100),
    potencia_w DECIMAL(10,2),
    estado VARCHAR(30) NOT NULL DEFAULT 'DESLIGADO',
    data_instalacao DATE,
    ultimo_status DATETIME,
    ativo BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT fk_dispositivo_comodo
        FOREIGN KEY (id_comodo)
        REFERENCES comodos(id_comodo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_dispositivo_tipo
        FOREIGN KEY (id_tipo_dispositivo)
        REFERENCES tipos_dispositivo(id_tipo_dispositivo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_dispositivo_estado
        CHECK (estado IN ('LIGADO', 'DESLIGADO', 'STANDBY', 'ERRO')),

    INDEX idx_dispositivo_comodo (id_comodo),
    INDEX idx_dispositivo_tipo (id_tipo_dispositivo)
) ENGINE=InnoDB;


/* =========================================================
   6. TIPOS DE SENSORES
   ========================================================= */

CREATE TABLE tipos_sensor (
    id_tipo_sensor INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    categoria VARCHAR(50) NOT NULL,
    unidade_padrao VARCHAR(30),
    descricao VARCHAR(255)
) ENGINE=InnoDB;


/* =========================================================
   7. SENSORES
   ========================================================= */

CREATE TABLE sensores (
    id_sensor BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_comodo BIGINT UNSIGNED NOT NULL,
    id_dispositivo BIGINT UNSIGNED NULL,
    id_tipo_sensor INT UNSIGNED NOT NULL,
    codigo_sensor VARCHAR(100) NOT NULL UNIQUE,
    fabricante VARCHAR(100),
    modelo VARCHAR(100),
    status VARCHAR(30) NOT NULL DEFAULT 'ATIVO',
    data_instalacao DATE,
    ultima_comunicacao DATETIME,

    CONSTRAINT fk_sensor_comodo
        FOREIGN KEY (id_comodo)
        REFERENCES comodos(id_comodo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_sensor_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_sensor_tipo
        FOREIGN KEY (id_tipo_sensor)
        REFERENCES tipos_sensor(id_tipo_sensor)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT chk_sensor_status
        CHECK (status IN ('ATIVO', 'INATIVO', 'ERRO', 'MANUTENCAO')),

    INDEX idx_sensor_comodo (id_comodo),
    INDEX idx_sensor_tipo (id_tipo_sensor)
) ENGINE=InnoDB;


/* =========================================================
   8. MEDIÇÕES DOS SENSORES
   ========================================================= */

CREATE TABLE medicoes (
    id_medicao BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_sensor BIGINT UNSIGNED NOT NULL,
    id_dispositivo BIGINT UNSIGNED NULL,
    data_hora DATETIME NOT NULL,
    valor DECIMAL(15,4) NULL,
    valor_texto VARCHAR(100) NULL,
    valor_booleano BOOLEAN NULL,
    unidade VARCHAR(30),
    qualidade_dado VARCHAR(20) DEFAULT 'VALIDO',
    origem VARCHAR(30) DEFAULT 'SENSOR',
    data_ingestao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_medicao_sensor
        FOREIGN KEY (id_sensor)
        REFERENCES sensores(id_sensor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_medicao_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_qualidade_medicao
        CHECK (
            qualidade_dado IN
            ('VALIDO', 'SUSPEITO', 'INVALIDO', 'AUSENTE')
        ),

    INDEX idx_medicao_sensor_data (id_sensor, data_hora),
    INDEX idx_medicao_data (data_hora),
    INDEX idx_medicao_dispositivo_data (id_dispositivo, data_hora)
) ENGINE=InnoDB;


/* =========================================================
   9. EVENTOS DOS DISPOSITIVOS
   ========================================================= */

CREATE TABLE eventos_dispositivo (
    id_evento BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_dispositivo BIGINT UNSIGNED NOT NULL,
    data_hora DATETIME NOT NULL,
    evento VARCHAR(50) NOT NULL,
    estado_anterior VARCHAR(30),
    estado_novo VARCHAR(30),
    motivo VARCHAR(255),
    origem VARCHAR(30) DEFAULT 'AUTOMACAO',

    CONSTRAINT fk_evento_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_evento_dispositivo_data
        (id_dispositivo, data_hora),

    INDEX idx_evento_data (data_hora)
) ENGINE=InnoDB;


/* =========================================================
   10. PRESENÇA / OCUPAÇÃO
   ========================================================= */

CREATE TABLE registros_presenca (
    id_presenca BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_comodo BIGINT UNSIGNED NOT NULL,
    id_sensor BIGINT UNSIGNED NOT NULL,
    data_hora DATETIME NOT NULL,
    presente BOOLEAN NOT NULL,
    quantidade_pessoas INT UNSIGNED DEFAULT 0,
    confianca DECIMAL(5,2),

    CONSTRAINT fk_presenca_comodo
        FOREIGN KEY (id_comodo)
        REFERENCES comodos(id_comodo)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_presenca_sensor
        FOREIGN KEY (id_sensor)
        REFERENCES sensores(id_sensor)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    INDEX idx_presenca_comodo_data
        (id_comodo, data_hora),

    INDEX idx_presenca_data (data_hora)
) ENGINE=InnoDB;


/* =========================================================
   11. ANOMALIAS
   ========================================================= */

CREATE TABLE anomalias (
    id_anomalia BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    id_sensor BIGINT UNSIGNED NULL,
    id_dispositivo BIGINT UNSIGNED NULL,
    data_hora DATETIME NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    valor_observado DECIMAL(15,4),
    valor_esperado DECIMAL(15,4),
    desvio_percentual DECIMAL(10,2),
    score_anomalia DECIMAL(10,4),
    severidade VARCHAR(20) NOT NULL DEFAULT 'MEDIA',
    status VARCHAR(30) NOT NULL DEFAULT 'ABERTA',

    CONSTRAINT fk_anomalia_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_anomalia_sensor
        FOREIGN KEY (id_sensor)
        REFERENCES sensores(id_sensor)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_anomalia_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_anomalia_severidade
        CHECK (
            severidade IN
            ('BAIXA', 'MEDIA', 'ALTA', 'CRITICA')
        ),

    CONSTRAINT chk_anomalia_status
        CHECK (
            status IN
            ('ABERTA', 'EM_ANALISE', 'RESOLVIDA', 'IGNORADA')
        ),

    INDEX idx_anomalia_residencia_data
        (id_residencia, data_hora),

    INDEX idx_anomalia_severidade
        (severidade)
) ENGINE=InnoDB;


/* =========================================================
   12. MODELOS PREDITIVOS
   ========================================================= */

CREATE TABLE modelos (
    id_modelo BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    tipo_modelo VARCHAR(80) NOT NULL,
    objetivo VARCHAR(255) NOT NULL,
    algoritmo VARCHAR(100),
    versao VARCHAR(30),
    acuracia DECIMAL(8,4),
    mae DECIMAL(15,6),
    rmse DECIMAL(15,6),
    data_treinamento DATETIME,
    ativo BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB;


/* =========================================================
   13. PREVISÕES
   ========================================================= */

CREATE TABLE previsoes (
    id_previsao BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    id_modelo BIGINT UNSIGNED NOT NULL,
    id_comodo BIGINT UNSIGNED NULL,
    id_dispositivo BIGINT UNSIGNED NULL,
    data_geracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_previsao DATETIME NOT NULL,
    categoria VARCHAR(50) NOT NULL,
    variavel VARCHAR(100) NOT NULL,
    valor_previsto DECIMAL(15,4),
    unidade VARCHAR(30),
    intervalo_inferior DECIMAL(15,4),
    intervalo_superior DECIMAL(15,4),
    confianca DECIMAL(8,4),

    CONSTRAINT fk_previsao_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_previsao_modelo
        FOREIGN KEY (id_modelo)
        REFERENCES modelos(id_modelo)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,

    CONSTRAINT fk_previsao_comodo
        FOREIGN KEY (id_comodo)
        REFERENCES comodos(id_comodo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_previsao_dispositivo
        FOREIGN KEY (id_dispositivo)
        REFERENCES dispositivos(id_dispositivo)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    INDEX idx_previsao_residencia_data
        (id_residencia, data_previsao),

    INDEX idx_previsao_categoria
        (categoria)
) ENGINE=InnoDB;


/* =========================================================
   14. ALERTAS
   ========================================================= */

CREATE TABLE alertas (
    id_alerta BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    id_anomalia BIGINT UNSIGNED NULL,
    data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(80) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    mensagem TEXT NOT NULL,
    severidade VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'NAO_LIDO',
    canal VARCHAR(30) DEFAULT 'APLICATIVO',

    CONSTRAINT fk_alerta_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_alerta_anomalia
        FOREIGN KEY (id_anomalia)
        REFERENCES anomalias(id_anomalia)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_alerta_severidade
        CHECK (
            severidade IN
            ('INFO', 'BAIXA', 'MEDIA', 'ALTA', 'CRITICA')
        ),

    CONSTRAINT chk_alerta_status
        CHECK (
            status IN
            ('NAO_LIDO', 'LIDO', 'EM_ANALISE', 'RESOLVIDO')
        ),

    INDEX idx_alerta_residencia_data
        (id_residencia, data_hora),

    INDEX idx_alerta_status
        (status)
) ENGINE=InnoDB;


/* =========================================================
   15. RECOMENDAÇÕES
   ========================================================= */

CREATE TABLE recomendacoes (
    id_recomendacao BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    id_alerta BIGINT UNSIGNED NULL,
    id_anomalia BIGINT UNSIGNED NULL,
    data_geracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    categoria VARCHAR(50) NOT NULL,
    titulo VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,
    impacto_estimado DECIMAL(10,2),
    unidade_impacto VARCHAR(30),
    prioridade VARCHAR(20) DEFAULT 'MEDIA',
    status VARCHAR(30) DEFAULT 'PENDENTE',

    CONSTRAINT fk_recomendacao_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_recomendacao_alerta
        FOREIGN KEY (id_alerta)
        REFERENCES alertas(id_alerta)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT fk_recomendacao_anomalia
        FOREIGN KEY (id_anomalia)
        REFERENCES anomalias(id_anomalia)
        ON DELETE SET NULL
        ON UPDATE CASCADE,

    CONSTRAINT chk_recomendacao_prioridade
        CHECK (
            prioridade IN
            ('BAIXA', 'MEDIA', 'ALTA')
        ),

    CONSTRAINT chk_recomendacao_status
        CHECK (
            status IN
            ('PENDENTE', 'ACEITA', 'RECUSADA', 'CONCLUIDA')
        ),

    INDEX idx_recomendacao_residencia
        (id_residencia, data_geracao)
) ENGINE=InnoDB;


/* =========================================================
   16. DOMUS SCORE
   ========================================================= */

CREATE TABLE domus_scores (
    id_score BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_residencia BIGINT UNSIGNED NOT NULL,
    data_referencia DATE NOT NULL,
    score_total DECIMAL(5,2) NOT NULL,

    score_energia DECIMAL(5,2),
    score_agua DECIMAL(5,2),
    score_eficiencia DECIMAL(5,2),
    score_sustentabilidade DECIMAL(5,2),
    score_seguranca DECIMAL(5,2),
    score_comportamento DECIMAL(5,2),

    classificacao VARCHAR(30),

    CONSTRAINT fk_score_residencia
        FOREIGN KEY (id_residencia)
        REFERENCES residencias(id_residencia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT chk_score_total
        CHECK (score_total BETWEEN 0 AND 100),

    CONSTRAINT chk_score_energia
        CHECK (score_energia IS NULL OR score_energia BETWEEN 0 AND 100),

    CONSTRAINT chk_score_agua
        CHECK (score_agua IS NULL OR score_agua BETWEEN 0 AND 100),

    CONSTRAINT chk_score_eficiencia
        CHECK (score_eficiencia IS NULL OR score_eficiencia BETWEEN 0 AND 100),

    CONSTRAINT chk_score_sustentabilidade
        CHECK (
            score_sustentabilidade IS NULL
            OR score_sustentabilidade BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_score_seguranca
        CHECK (
            score_seguranca IS NULL
            OR score_seguranca BETWEEN 0 AND 100
        ),

    CONSTRAINT chk_score_comportamento
        CHECK (
            score_comportamento IS NULL
            OR score_comportamento BETWEEN 0 AND 100
        ),

    UNIQUE KEY uk_score_residencia_data
        (id_residencia, data_referencia),

    INDEX idx_score_data
        (data_referencia)
) ENGINE=InnoDB;


/* =========================================================
   17. CARGA INICIAL - TIPOS DE DISPOSITIVOS
   ========================================================= */

INSERT INTO tipos_dispositivo
(nome, categoria, descricao)
VALUES
('Ar-condicionado', 'CLIMATIZACAO',
 'Controle de temperatura e climatização'),

('Iluminação', 'ILUMINACAO',
 'Luzes inteligentes da residência'),

('Televisão', 'ENTRETENIMENTO',
 'Televisão conectada'),

('Geladeira', 'ELETRODOMESTICO',
 'Refrigerador inteligente'),

('Máquina de lavar', 'ELETRODOMESTICO',
 'Máquina de lavar roupas'),

('Chuveiro', 'HIGIENE',
 'Controle e monitoramento do chuveiro'),

('Computador', 'TECNOLOGIA',
 'Computador ou estação de trabalho'),

('Bomba de água', 'AGUA',
 'Sistema de bombeamento de água'),

('Fechadura inteligente', 'SEGURANCA',
 'Controle inteligente de acesso'),

('Câmera', 'SEGURANCA',
 'Câmera ou sensor visual simulado');


/* =========================================================
   18. CARGA INICIAL - TIPOS DE SENSORES
   ========================================================= */

INSERT INTO tipos_sensor
(nome, categoria, unidade_padrao, descricao)
VALUES
('Sensor de energia', 'ENERGIA', 'kWh',
 'Medição do consumo energético'),

('Sensor de água', 'AGUA', 'L',
 'Medição do consumo de água'),

('Sensor de temperatura', 'CLIMA', '°C',
 'Medição da temperatura'),

('Sensor de umidade', 'CLIMA', '%',
 'Medição da umidade'),

('Sensor de presença', 'PRESENCA', 'boolean',
 'Detecção de presença'),

('Sensor de porta', 'SEGURANCA', 'boolean',
 'Detecção de abertura de portas'),

('Sensor de janela', 'SEGURANCA', 'boolean',
 'Detecção de abertura de janelas'),

('Sensor de luminosidade', 'ILUMINACAO', 'lux',
 'Medição da luminosidade');


/* =========================================================
   19. VIEW - CONSUMO DE ENERGIA
   ========================================================= */

CREATE OR REPLACE VIEW vw_consumo_energia AS
SELECT
    r.id_residencia,
    r.nome AS residencia,
    c.nome AS comodo,
    d.nome AS dispositivo,
    DATE(m.data_hora) AS data,
    SUM(m.valor) AS consumo_kwh
FROM medicoes m

INNER JOIN sensores s
    ON m.id_sensor = s.id_sensor

INNER JOIN tipos_sensor ts
    ON s.id_tipo_sensor = ts.id_tipo_sensor

INNER JOIN comodos c
    ON s.id_comodo = c.id_comodo

INNER JOIN residencias r
    ON c.id_residencia = r.id_residencia

LEFT JOIN dispositivos d
    ON m.id_dispositivo = d.id_dispositivo

WHERE ts.categoria = 'ENERGIA'
  AND m.qualidade_dado = 'VALIDO'

GROUP BY
    r.id_residencia,
    r.nome,
    c.nome,
    d.nome,
    DATE(m.data_hora);


/* =========================================================
   20. VIEW - CONSUMO DE ÁGUA
   ========================================================= */

CREATE OR REPLACE VIEW vw_consumo_agua AS
SELECT
    r.id_residencia,
    r.nome AS residencia,
    c.nome AS comodo,
    DATE(m.data_hora) AS data,
    SUM(m.valor) AS consumo_litros
FROM medicoes m

INNER JOIN sensores s
    ON m.id_sensor = s.id_sensor

INNER JOIN tipos_sensor ts
    ON s.id_tipo_sensor = ts.id_tipo_sensor

INNER JOIN comodos c
    ON s.id_comodo = c.id_comodo

INNER JOIN residencias r
    ON c.id_residencia = r.id_residencia

WHERE ts.categoria = 'AGUA'
  AND m.qualidade_dado = 'VALIDO'

GROUP BY
    r.id_residencia,
    r.nome,
    c.nome,
    DATE(m.data_hora);


/* =========================================================
   21. VIEW - ALERTAS ATIVOS
   ========================================================= */

CREATE OR REPLACE VIEW vw_alertas_ativos AS
SELECT
    a.id_alerta,
    r.nome AS residencia,
    a.data_hora,
    a.tipo,
    a.titulo,
    a.mensagem,
    a.severidade,
    a.status
FROM alertas a

INNER JOIN residencias r
    ON a.id_residencia = r.id_residencia

WHERE a.status IN ('NAO_LIDO', 'LIDO', 'EM_ANALISE');


/* =========================================================
   22. VIEW - DASHBOARD DOMUS
   ========================================================= */

CREATE OR REPLACE VIEW vw_domus_dashboard AS
SELECT
    r.id_residencia,
    r.nome AS residencia,

    (
        SELECT ds.score_total
        FROM domus_scores ds
        WHERE ds.id_residencia = r.id_residencia
        ORDER BY ds.data_referencia DESC
        LIMIT 1
    ) AS domus_score,

    (
        SELECT COUNT(*)
        FROM alertas a
        WHERE a.id_residencia = r.id_residencia
          AND a.status = 'NAO_LIDO'
    ) AS alertas_nao_lidos,

    (
        SELECT COUNT(*)
        FROM anomalias an
        WHERE an.id_residencia = r.id_residencia
          AND an.status = 'ABERTA'
    ) AS anomalias_abertas,

    (
        SELECT COUNT(*)
        FROM dispositivos d
        INNER JOIN comodos c
            ON d.id_comodo = c.id_comodo
        WHERE c.id_residencia = r.id_residencia
          AND d.estado = 'LIGADO'
    ) AS dispositivos_ligados

FROM residencias r;


/* =========================================================
   FIM DO SCRIPT
   ========================================================= */