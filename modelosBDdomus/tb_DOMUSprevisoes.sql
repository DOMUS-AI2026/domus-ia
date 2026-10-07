USE domus_ai;
select*from previsoes;
SET @quantidade_previsoes = 20000;

INSERT INTO previsoes
(
    id_residencia,
    id_modelo,
    id_comodo,
    id_dispositivo,
    data_geracao,
    data_previsao,
    categoria,
    variavel,
    valor_previsto,
    unidade,
    intervalo_inferior,
    intervalo_superior,
    confianca
)

SELECT
    base.id_residencia,
    base.id_modelo,
    base.id_comodo,
    base.id_dispositivo,
    base.data_geracao,

    LEAST(
        DATE_ADD(
            base.data_geracao,
            INTERVAL (7 + MOD(base.n, 30)) DAY
        ),
        '2050-10-31 23:59:59'
    ) AS data_previsao,

    CASE MOD(base.n, 6)
        WHEN 0 THEN 'ENERGIA'
        WHEN 1 THEN 'AGUA'
        WHEN 2 THEN 'CLIMA'
        WHEN 3 THEN 'SEGURANCA'
        WHEN 4 THEN 'COMPORTAMENTO'
        ELSE 'SUSTENTABILIDADE'
    END AS categoria,

    CASE MOD(base.n, 6)
        WHEN 0 THEN 'consumo_energia'
        WHEN 1 THEN 'consumo_agua'
        WHEN 2 THEN 'temperatura'
        WHEN 3 THEN 'nivel_seguranca'
        WHEN 4 THEN 'padrao_comportamento'
        ELSE 'indice_sustentabilidade'
    END AS variavel,

    CASE MOD(base.n, 6)
        WHEN 0 THEN ROUND(2 + MOD(base.n * 47, 9000) / 100, 2)
        WHEN 1 THEN ROUND(5 + MOD(base.n * 61, 30000) / 100, 2)
        WHEN 2 THEN ROUND(18 + MOD(base.n * 37, 1800) / 100, 2)
        WHEN 3 THEN ROUND(50 + MOD(base.n * 29, 5000) / 100, 2)
        WHEN 4 THEN ROUND(40 + MOD(base.n * 53, 6000) / 100, 2)
        ELSE ROUND(45 + MOD(base.n * 71, 5500) / 100, 2)
    END AS valor_previsto,

    CASE MOD(base.n, 6)
        WHEN 0 THEN 'kWh'
        WHEN 1 THEN 'L'
        WHEN 2 THEN '°C'
        WHEN 3 THEN '%'
        WHEN 4 THEN '%'
        ELSE '%'
    END AS unidade,

    CASE MOD(base.n, 6)
        WHEN 0 THEN ROUND((2 + MOD(base.n * 47, 9000) / 100) * 0.90, 2)
        WHEN 1 THEN ROUND((5 + MOD(base.n * 61, 30000) / 100) * 0.90, 2)
        WHEN 2 THEN ROUND((18 + MOD(base.n * 37, 1800) / 100) * 0.95, 2)
        WHEN 3 THEN ROUND((50 + MOD(base.n * 29, 5000) / 100) * 0.90, 2)
        WHEN 4 THEN ROUND((40 + MOD(base.n * 53, 6000) / 100) * 0.90, 2)
        ELSE ROUND((45 + MOD(base.n * 71, 5500) / 100) * 0.90, 2)
    END AS intervalo_inferior,

    CASE MOD(base.n, 6)
        WHEN 0 THEN ROUND((2 + MOD(base.n * 47, 9000) / 100) * 1.10, 2)
        WHEN 1 THEN ROUND((5 + MOD(base.n * 61, 30000) / 100) * 1.10, 2)
        WHEN 2 THEN ROUND((18 + MOD(base.n * 37, 1800) / 100) * 1.05, 2)
        WHEN 3 THEN ROUND((50 + MOD(base.n * 29, 5000) / 100) * 1.10, 2)
        WHEN 4 THEN ROUND((40 + MOD(base.n * 53, 6000) / 100) * 1.10, 2)
        ELSE ROUND((45 + MOD(base.n * 71, 5500) / 100) * 1.10, 2)
    END AS intervalo_superior,

    ROUND(
        0.80 + MOD(base.n * 17, 1999) / 10000,
        4
    ) AS confianca

FROM
(
    SELECT
        numeros.n,

        c.id_residencia,
        c.id_comodo,
        d.id_dispositivo,

        1 + MOD(numeros.n - 1, 30) AS id_modelo,

        CASE
            WHEN ano = 2050 THEN
                DATE_ADD(
                    '2050-10-01 00:00:00',
                    INTERVAL MOD(
                        numeros.n * 173,
                        31 * 24 * 60
                    ) MINUTE
                )

            ELSE
                DATE_ADD(
                    CONCAT(
                        ano,
                        '-01-01 00:00:00'
                    ),
                    INTERVAL MOD(
                        numeros.n * 173,
                        DATEDIFF(
                            CONCAT(ano + 1, '-01-01'),
                            CONCAT(ano, '-01-01')
                        ) * 24 * 60
                    ) MINUTE
                )
        END AS data_geracao

    FROM
    (
        SELECT
            1
            + a.n
            + b.n * 10
            + c.n * 100
            + d.n * 1000
            + e.n * 10000 AS n,

            2025 +
            LEAST(
                25,
                FLOOR(
                    25 * POW(
                        (
                            (
                                1
                                + a.n
                                + b.n * 10
                                + c.n * 100
                                + d.n * 1000
                                + e.n * 10000
                            ) - 1
                        ) / (@quantidade_previsoes - 1),
                        0.65
                    )
                )
            ) AS ano

        FROM
        (
            SELECT 0 AS n UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9
        ) a

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9
        ) b

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9
        ) c

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9
        ) d

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL
            SELECT 1 UNION ALL
            SELECT 2 UNION ALL
            SELECT 3 UNION ALL
            SELECT 4 UNION ALL
            SELECT 5 UNION ALL
            SELECT 6 UNION ALL
            SELECT 7 UNION ALL
            SELECT 8 UNION ALL
            SELECT 9
        ) e

        WHERE
            1
            + a.n
            + b.n * 10
            + c.n * 100
            + d.n * 1000
            + e.n * 10000
            <= @quantidade_previsoes
    ) numeros

    INNER JOIN comodos c
        ON c.id_comodo =
           MOD(numeros.n - 1, 21960) + 1

    INNER JOIN dispositivos d
        ON d.id_comodo = c.id_comodo

) base;
