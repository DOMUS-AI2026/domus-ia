USE domus_ai;
select*from domus_scores;
INSERT INTO domus_scores
(
    id_residencia,
    data_referencia,
    score_total,
    score_energia,
    score_agua,
    score_eficiencia,
    score_sustentabilidade,
    score_seguranca,
    score_comportamento,
    classificacao
)

SELECT
    dados.id_residencia,
    dados.data_referencia,

    ROUND(
        (
            dados.score_energia +
            dados.score_agua +
            dados.score_eficiencia +
            dados.score_sustentabilidade +
            dados.score_seguranca +
            dados.score_comportamento
        ) / 6,
        2
    ) AS score_total,

    dados.score_energia,
    dados.score_agua,
    dados.score_eficiencia,
    dados.score_sustentabilidade,
    dados.score_seguranca,
    dados.score_comportamento,

    CASE
        WHEN (
            dados.score_energia +
            dados.score_agua +
            dados.score_eficiencia +
            dados.score_sustentabilidade +
            dados.score_seguranca +
            dados.score_comportamento
        ) / 6 >= 90
            THEN 'EXCELENTE'

        WHEN (
            dados.score_energia +
            dados.score_agua +
            dados.score_eficiencia +
            dados.score_sustentabilidade +
            dados.score_seguranca +
            dados.score_comportamento
        ) / 6 >= 75
            THEN 'MUITO BOM'

        WHEN (
            dados.score_energia +
            dados.score_agua +
            dados.score_eficiencia +
            dados.score_sustentabilidade +
            dados.score_seguranca +
            dados.score_comportamento
        ) / 6 >= 60
            THEN 'BOM'

        WHEN (
            dados.score_energia +
            dados.score_agua +
            dados.score_eficiencia +
            dados.score_sustentabilidade +
            dados.score_seguranca +
            dados.score_comportamento
        ) / 6 >= 40
            THEN 'REGULAR'

        ELSE 'CRITICO'
    END AS classificacao

FROM
(
    SELECT

        numeros.n AS id_numero,

        MOD(numeros.n - 1, 3660) + 1 AS id_residencia,

        CASE
            WHEN numeros.n > 9700 THEN
                DATE_ADD(
                    '2050-10-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 31 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 8500 THEN
                DATE_ADD(
                    '2049-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 7000 THEN
                DATE_ADD(
                    '2047-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 5200 THEN
                DATE_ADD(
                    '2044-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 366 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 3400 THEN
                DATE_ADD(
                    '2041-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 2100 THEN
                DATE_ADD(
                    '2038-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 1200 THEN
                DATE_ADD(
                    '2035-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            WHEN numeros.n > 600 THEN
                DATE_ADD(
                    '2030-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )

            ELSE
                DATE_ADD(
                    '2025-01-01 00:00:00',
                    INTERVAL MOD(numeros.n * 47, 365 * 24 * 60) MINUTE
                )
        END AS data_referencia,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    45 + MOD(numeros.n * 31, 51)
                )
            ),
            2
        ) AS score_energia,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    48 + MOD(numeros.n * 37, 48)
                )
            ),
            2
        ) AS score_agua,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    50 + MOD(numeros.n * 43, 46)
                )
            ),
            2
        ) AS score_eficiencia,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    47 + MOD(numeros.n * 53, 50)
                )
            ),
            2
        ) AS score_sustentabilidade,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    55 + MOD(numeros.n * 29, 44)
                )
            ),
            2
        ) AS score_seguranca,

        ROUND(
            LEAST(
                100,
                GREATEST(
                    20,
                    44 + MOD(numeros.n * 41, 53)
                )
            ),
            2
        ) AS score_comportamento

    FROM
    (
        SELECT
            1
            + a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000) AS n

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

        WHERE
            1
            + a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000)
            <= 10000

    ) numeros
) dados;
