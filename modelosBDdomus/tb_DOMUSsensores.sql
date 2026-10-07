USE domus_ai;
select*from sensores;
INSERT INTO sensores
(
    id_comodo,
    id_dispositivo,
    id_tipo_sensor,
    codigo_sensor,
    fabricante,
    modelo,
    status,
    data_instalacao,
    ultima_comunicacao
)

SELECT

    c.id_comodo,

    d.id_dispositivo,

    CASE
        WHEN s.posicao = 1 THEN
            1 + MOD(c.id_comodo - 1, 8)
        ELSE
            1 + MOD(c.id_comodo + 2, 8)
    END AS id_tipo_sensor,

    CONCAT(
        'DOMUS-SENSOR-',
        LPAD(c.id_comodo, 5, '0'),
        '-',
        s.posicao
    ) AS codigo_sensor,

    CASE
        WHEN MOD(c.id_comodo, 6) = 0 THEN 'Siemens'
        WHEN MOD(c.id_comodo, 6) = 1 THEN 'Bosch'
        WHEN MOD(c.id_comodo, 6) = 2 THEN 'Intelbras'
        WHEN MOD(c.id_comodo, 6) = 3 THEN 'Samsung'
        WHEN MOD(c.id_comodo, 6) = 4 THEN 'Philips'
        ELSE 'Xiaomi'
    END AS fabricante,

    CASE
        WHEN s.posicao = 1 THEN
            CASE MOD(c.id_comodo - 1, 8)
                WHEN 0 THEN 'DOMUS-ENERGY-X1'
                WHEN 1 THEN 'DOMUS-WATER-X2'
                WHEN 2 THEN 'DOMUS-TEMP-X3'
                WHEN 3 THEN 'DOMUS-HUMID-X4'
                WHEN 4 THEN 'DOMUS-PRESENCE-X5'
                WHEN 5 THEN 'DOMUS-DOOR-X6'
                WHEN 6 THEN 'DOMUS-WINDOW-X7'
                ELSE 'DOMUS-LIGHT-X8'
            END
        ELSE
            CASE MOD(c.id_comodo + 2, 8)
                WHEN 0 THEN 'DOMUS-ENERGY-PRO'
                WHEN 1 THEN 'DOMUS-WATER-PRO'
                WHEN 2 THEN 'DOMUS-TEMP-PRO'
                WHEN 3 THEN 'DOMUS-HUMID-PRO'
                WHEN 4 THEN 'DOMUS-PRESENCE-PRO'
                WHEN 5 THEN 'DOMUS-DOOR-PRO'
                WHEN 6 THEN 'DOMUS-WINDOW-PRO'
                ELSE 'DOMUS-LIGHT-PRO'
            END
    END AS modelo,

    CASE
        WHEN MOD(c.id_comodo + s.posicao, 19) = 0 THEN 'MANUTENCAO'
        WHEN MOD(c.id_comodo + s.posicao, 23) = 0 THEN 'OFFLINE'
        ELSE 'ATIVO'
    END AS status,

    LEAST(
        DATE_ADD(
            r.data_cadastro,
            INTERVAL MOD(c.id_comodo * 7 + s.posicao * 11, 30) DAY
        ),
        '2050-10-31'
    ) AS data_instalacao,

    LEAST(
        TIMESTAMP(
            DATE_ADD(
                r.data_cadastro,
                INTERVAL MOD(c.id_comodo * 7 + s.posicao * 11, 30) DAY
            )
        ),
        '2050-10-31 23:59:59'
    ) AS ultima_comunicacao

FROM comodos c

INNER JOIN residencias r
    ON r.id_residencia = c.id_residencia

INNER JOIN dispositivos d
    ON d.id_comodo = c.id_comodo

CROSS JOIN
(
    SELECT 1 AS posicao
    UNION ALL
    SELECT 2 AS posicao
) s;
