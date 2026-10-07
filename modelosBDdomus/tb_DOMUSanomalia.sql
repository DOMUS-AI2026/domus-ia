USE domus_ai;

SET @quantidade_anomalias = 10000;
select*from anomalias;
INSERT INTO anomalias
(
    id_residencia,
    id_sensor,
    id_dispositivo,
    data_hora,
    categoria,
    tipo,
    descricao,
    valor_observado,
    valor_esperado,
    desvio_percentual,
    score_anomalia,
    severidade,
    status
)

SELECT
    MOD(n - 1, 3660) + 1 AS id_residencia,

    NULL AS id_sensor,

    NULL AS id_dispositivo,

    CASE
        WHEN ano = 2050 THEN
            DATE_ADD(
                '2050-10-01 00:00:00',
                INTERVAL MOD(n * 173, 31 * 24 * 60) MINUTE
            )
        ELSE
            DATE_ADD(
                CONCAT(ano, '-01-01 00:00:00'),
                INTERVAL MOD(
                    n * 173,
                    DATEDIFF(
                        CONCAT(ano + 1, '-01-01'),
                        CONCAT(ano, '-01-01')
                    ) * 24 * 60
                ) MINUTE
            )
    END AS data_hora,

    CASE MOD(n, 10)
        WHEN 0 THEN 'SEGURANCA'
        WHEN 1 THEN 'AGUA'
        WHEN 2 THEN 'GAS'
        WHEN 3 THEN 'ENERGIA'
        WHEN 4 THEN 'TEMPERATURA'
        WHEN 5 THEN 'UMIDADE'
        WHEN 6 THEN 'QUALIDADE_AR'
        WHEN 7 THEN 'PRESENCA'
        WHEN 8 THEN 'DISPOSITIVO'
        WHEN 9 THEN 'AMBIENTE'
    END AS categoria,

    CASE MOD(n, 10)
        WHEN 0 THEN 'INTRUSAO_DETECTADA'
        WHEN 1 THEN 'VAZAMENTO_AGUA'
        WHEN 2 THEN 'VAZAMENTO_GAS'
        WHEN 3 THEN 'CONSUMO_ENERGIA'
        WHEN 4 THEN 'TEMPERATURA_ELEVADA'
        WHEN 5 THEN 'UMIDADE_ANORMAL'
        WHEN 6 THEN 'QUALIDADE_AR_BAIXA'
        WHEN 7 THEN 'PRESENCA_INESPERADA'
        WHEN 8 THEN 'FALHA_DISPOSITIVO'
        WHEN 9 THEN 'CONDICAO_AMBIENTAL_ANORMAL'
    END AS tipo,

    CASE MOD(n, 10)
        WHEN 0 THEN 'Foi identificada movimentacao incomum em uma area monitorada da residencia.'
        WHEN 1 THEN 'Foi identificado fluxo de agua acima do comportamento esperado para a residencia.'
        WHEN 2 THEN 'Foi detectada concentracao elevada de gas no ambiente monitorado.'
        WHEN 3 THEN 'O consumo de energia apresentou aumento significativo em relacao ao historico.'
        WHEN 4 THEN 'A temperatura do ambiente ultrapassou o limite configurado pelo sistema.'
        WHEN 5 THEN 'A umidade apresentou valores acima ou abaixo do padrao esperado.'
        WHEN 6 THEN 'Os sensores identificaram alteracao nos parametros de qualidade do ar.'
        WHEN 7 THEN 'Foi detectada presenca em horario ou local considerado incomum.'
        WHEN 8 THEN 'Um dispositivo conectado apresentou comportamento diferente do funcionamento esperado.'
        WHEN 9 THEN 'O ambiente apresentou uma condicao fora dos parametros definidos pela inteligencia artificial.'
    END AS descricao,

    CASE MOD(n, 10)
        WHEN 0 THEN 87.50
        WHEN 1 THEN 18.70
        WHEN 2 THEN 92.40
        WHEN 3 THEN 13.80
        WHEN 4 THEN 39.70
        WHEN 5 THEN 82.30
        WHEN 6 THEN 74.60
        WHEN 7 THEN 1.00
        WHEN 8 THEN 0.00
        WHEN 9 THEN 91.20
    END AS valor_observado,

    CASE MOD(n, 10)
        WHEN 0 THEN 5.00
        WHEN 1 THEN 0.50
        WHEN 2 THEN 10.00
        WHEN 3 THEN 7.00
        WHEN 4 THEN 24.00
        WHEN 5 THEN 50.00
        WHEN 6 THEN 20.00
        WHEN 7 THEN 0.00
        WHEN 8 THEN 1.00
        WHEN 9 THEN 45.00
    END AS valor_esperado,

    CASE MOD(n, 10)
        WHEN 0 THEN 1650.00
        WHEN 1 THEN 3640.00
        WHEN 2 THEN 824.00
        WHEN 3 THEN 97.14
        WHEN 4 THEN 65.42
        WHEN 5 THEN 64.60
        WHEN 6 THEN 273.00
        WHEN 7 THEN 100.00
        WHEN 8 THEN 100.00
        WHEN 9 THEN 102.67
    END AS desvio_percentual,

    CASE MOD(n, 10)
        WHEN 0 THEN 0.9200
        WHEN 1 THEN 0.8100
        WHEN 2 THEN 0.9900
        WHEN 3 THEN 0.6200
        WHEN 4 THEN 0.7300
        WHEN 5 THEN 0.6800
        WHEN 6 THEN 0.7700
        WHEN 7 THEN 0.7100
        WHEN 8 THEN 0.5800
        WHEN 9 THEN 0.7500
    END AS score_anomalia,

    CASE
        WHEN MOD(n, 10) IN (2, 0) THEN 'CRITICA'
        WHEN MOD(n, 10) IN (1, 3, 6) THEN 'ALTA'
        WHEN MOD(n, 10) IN (4, 5, 7) THEN 'MEDIA'
        ELSE 'BAIXA'
    END AS severidade,

    CASE
        WHEN ano = 2050 AND MOD(n, 5) = 0 THEN 'ABERTA'
        WHEN ano = 2050 AND MOD(n, 5) IN (1, 2) THEN 'EM_ANALISE'
        WHEN MOD(n, 7) = 0 THEN 'RESOLVIDA'
        ELSE 'ABERTA'
    END AS status

FROM
(
    SELECT
        n,
        2025 +
        LEAST(
            25,
            FLOOR(
                25 * POW(
                    (n - 1) / (@quantidade_anomalias - 1),
                    0.65
                )
            )
        ) AS ano

    FROM
    (
        SELECT
            1
            + a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000)
            + (e.n * 10000) AS n

        FROM
        (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
            UNION ALL SELECT 6
            UNION ALL SELECT 7
            UNION ALL SELECT 8
            UNION ALL SELECT 9
        ) a

        CROSS JOIN
        (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
            UNION ALL SELECT 6
            UNION ALL SELECT 7
            UNION ALL SELECT 8
            UNION ALL SELECT 9
        ) b

        CROSS JOIN
        (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
            UNION ALL SELECT 6
            UNION ALL SELECT 7
            UNION ALL SELECT 8
            UNION ALL SELECT 9
        ) c

        CROSS JOIN
        (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
            UNION ALL SELECT 6
            UNION ALL SELECT 7
            UNION ALL SELECT 8
            UNION ALL SELECT 9
        ) d

        CROSS JOIN
        (
            SELECT 0 AS n
            UNION ALL SELECT 1
            UNION ALL SELECT 2
            UNION ALL SELECT 3
            UNION ALL SELECT 4
            UNION ALL SELECT 5
            UNION ALL SELECT 6
            UNION ALL SELECT 7
            UNION ALL SELECT 8
            UNION ALL SELECT 9
        ) e

        WHERE
            1
            + a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000)
            + (e.n * 10000)
            <= @quantidade_anomalias
    ) numeros
) dados;
