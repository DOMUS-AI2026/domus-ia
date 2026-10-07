USE domus_ai;
select*from medicoes;
SET @quantidade_medicoes = 100000;

INSERT INTO medicoes
(
    id_sensor,
    id_dispositivo,
    data_hora,
    valor,
    valor_texto,
    valor_booleano,
    unidade,
    qualidade_dado,
    origem,
    data_ingestao
)

SELECT
    dados.id_sensor,
    dados.id_dispositivo,
    dados.data_hora,

    CASE dados.id_tipo_sensor

        -- Sensor de energia
        WHEN 1 THEN
            ROUND(
                0.20
                + MOD(dados.n * 37, 780) / 100.0,
                4
            )

        -- Sensor de água
        WHEN 2 THEN
            ROUND(
                MOD(dados.n * 83, 2500) / 100.0,
                4
            )

        -- Sensor de temperatura
        WHEN 3 THEN
            ROUND(
                18
                + MOD(dados.n * 47, 2200) / 100.0,
                4
            )

        -- Sensor de umidade
        WHEN 4 THEN
            ROUND(
                30
                + MOD(dados.n * 71, 5500) / 100.0,
                4
            )

        -- Sensores booleanos
        WHEN 5 THEN NULL
        WHEN 6 THEN NULL
        WHEN 7 THEN NULL

        -- Sensor de luminosidade
        WHEN 8 THEN
            ROUND(
                20
                + MOD(dados.n * 113, 14800) / 10.0,
                4
            )

    END AS valor,

    CASE dados.id_tipo_sensor

        WHEN 5 THEN
            CASE
                WHEN MOD(dados.n, 9) = 0 THEN 'PRESENCA_DETECTADA'
                ELSE 'SEM_PRESENCA'
            END

        WHEN 6 THEN
            CASE
                WHEN MOD(dados.n, 7) = 0 THEN 'PORTA_ABERTA'
                ELSE 'PORTA_FECHADA'
            END

        WHEN 7 THEN
            CASE
                WHEN MOD(dados.n, 8) = 0 THEN 'JANELA_ABERTA'
                ELSE 'JANELA_FECHADA'
            END

        ELSE NULL

    END AS valor_texto,

    CASE dados.id_tipo_sensor

        WHEN 5 THEN
            CASE
                WHEN MOD(dados.n, 9) = 0 THEN 1
                ELSE 0
            END

        WHEN 6 THEN
            CASE
                WHEN MOD(dados.n, 7) = 0 THEN 1
                ELSE 0
            END

        WHEN 7 THEN
            CASE
                WHEN MOD(dados.n, 8) = 0 THEN 1
                ELSE 0
            END

        ELSE NULL

    END AS valor_booleano,

    dados.unidade_padrao AS unidade,

    CASE
        WHEN MOD(dados.n, 50) = 0 THEN 'SUSPEITO'
        WHEN MOD(dados.n, 13) = 0 THEN 'ESTIMADO'
        ELSE 'VALIDADO'
    END AS qualidade_dado,

    'SENSOR' AS origem,

    DATE_ADD(
        dados.data_hora,
        INTERVAL MOD(dados.n * 17, 60) SECOND
    ) AS data_ingestao

FROM
(
    SELECT
        numeros.n,

        sensores_lista.id_sensor,
        sensores_lista.id_dispositivo,
        sensores_lista.id_tipo_sensor,
        tipos_sensor.unidade_padrao,

        CASE
            WHEN
                2025 +
                LEAST(
                    25,
                    FLOOR(
                        25 * POW(
                            (numeros.n - 1) /
                            (@quantidade_medicoes - 1),
                            0.72
                        )
                    )
                ) = 2050

            THEN
                DATE_ADD(
                    '2050-10-01 00:00:00',
                    INTERVAL
                    MOD(
                        numeros.n * 173,
                        31 * 24 * 60
                    ) MINUTE
                )

            ELSE
                DATE_ADD(
                    CONCAT(
                        2025 +
                        LEAST(
                            25,
                            FLOOR(
                                25 * POW(
                                    (numeros.n - 1) /
                                    (@quantidade_medicoes - 1),
                                    0.72
                                )
                            )
                        ),
                        '-01-01 00:00:00'
                    ),
                    INTERVAL
                    MOD(
                        numeros.n * 173,
                        DATEDIFF(
                            CONCAT(
                                2025 +
                                LEAST(
                                    25,
                                    FLOOR(
                                        25 * POW(
                                            (numeros.n - 1) /
                                            (@quantidade_medicoes - 1),
                                            0.72
                                        )
                                    )
                                ) + 1,
                                '-01-01'
                            ),
                            CONCAT(
                                2025 +
                                LEAST(
                                    25,
                                    FLOOR(
                                        25 * POW(
                                            (numeros.n - 1) /
                                            (@quantidade_medicoes - 1),
                                            0.72
                                        )
                                    )
                                ),
                                '-01-01'
                            )
                        ) * 24 * 60
                    ) MINUTE
                )

        END AS data_hora

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
            SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ) a

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ) b

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ) c

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ) d

        CROSS JOIN
        (
            SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL
            SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL
            SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        ) e

        WHERE
            1
            + a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000)
            + (e.n * 10000)
            <= @quantidade_medicoes

    ) numeros

    JOIN
    (
        SELECT
            s.id_sensor,
            s.id_dispositivo,
            s.id_tipo_sensor,
            ROW_NUMBER() OVER (
                ORDER BY s.id_sensor
            ) AS ordem
        FROM sensores s
    ) sensores_lista

        ON sensores_lista.ordem =
            MOD(
                numeros.n - 1,
                (
                    SELECT COUNT(*)
                    FROM sensores
                )
            ) + 1

    INNER JOIN tipos_sensor
        ON tipos_sensor.id_tipo_sensor =
           sensores_lista.id_tipo_sensor

) dados;
