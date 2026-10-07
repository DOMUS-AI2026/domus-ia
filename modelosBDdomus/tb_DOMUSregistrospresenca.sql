USE domus_ai;
select*from registros_presenca;
SET @quantidade_presencas = 30000;

INSERT INTO registros_presenca
(
    id_comodo,
    id_sensor,
    data_hora,
    presente,
    quantidade_pessoas,
    confianca
)

SELECT
    sensores_presenca.id_comodo,

    sensores_presenca.id_sensor,

    CASE
        WHEN dados.ano = 2050 THEN
            DATE_ADD(
                '2050-10-01 00:00:00',
                INTERVAL MOD(dados.n * 173, 31 * 24 * 60) MINUTE
            )

        ELSE
            DATE_ADD(
                CONCAT(
                    dados.ano,
                    '-01-01 00:00:00'
                ),
                INTERVAL MOD(
                    dados.n * 173,
                    DATEDIFF(
                        CONCAT(dados.ano + 1, '-01-01'),
                        CONCAT(dados.ano, '-01-01')
                    ) * 24 * 60
                ) MINUTE
            )
    END AS data_hora,

    CASE
        WHEN MOD(dados.n, 7) IN (0, 1, 3) THEN 1
        ELSE 0
    END AS presente,

    CASE
        WHEN MOD(dados.n, 7) IN (0, 1, 3) THEN
            1 + MOD(dados.n * 17, 5)
        ELSE
            0
    END AS quantidade_pessoas,

    ROUND(
        85 + MOD(dados.n * 37, 1500) / 100,
        2
    ) AS confianca

FROM
(
    SELECT
        numeros.n,

        2025 +
        LEAST(
            25,
            FLOOR(
                25 * POW(
                    (numeros.n - 1) /
                    (@quantidade_presencas - 1),
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
            <= @quantidade_presencas

    ) numeros
) dados

JOIN
(
    SELECT
        id_sensor,
        id_comodo,
        ROW_NUMBER() OVER (
            ORDER BY id_sensor
        ) AS ordem

    FROM sensores

    WHERE id_tipo_sensor = 5

) sensores_presenca

ON sensores_presenca.ordem =
    MOD(
        dados.n - 1,
        (
            SELECT COUNT(*)
            FROM sensores
            WHERE id_tipo_sensor = 5
        )
    ) + 1;
