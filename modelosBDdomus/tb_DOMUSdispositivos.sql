USE domus_ai;
select*from dispositivos;
INSERT INTO dispositivos
(
    id_comodo,
    id_tipo_dispositivo,
    nome,
    fabricante,
    modelo,
    potencia_w,
    estado,
    data_instalacao,
    ultimo_status,
    ativo
)

SELECT
    c.id_comodo,

    1 + MOD(c.id_comodo - 1, 10) AS id_tipo_dispositivo,

    CASE MOD(c.id_comodo - 1, 10)
        WHEN 0 THEN 'Smart TV'
        WHEN 1 THEN 'Ar-condicionado inteligente'
        WHEN 2 THEN 'Lampada inteligente'
        WHEN 3 THEN 'Fechadura inteligente'
        WHEN 4 THEN 'Valvula de gas inteligente'
        WHEN 5 THEN 'Registro de agua inteligente'
        WHEN 6 THEN 'Persiana inteligente'
        WHEN 7 THEN 'Tomada inteligente'
        WHEN 8 THEN 'Camera de seguranca'
        ELSE 'Assistente residencial'
    END AS nome,

    CASE MOD(c.id_comodo - 1, 8)
        WHEN 0 THEN 'Samsung'
        WHEN 1 THEN 'LG'
        WHEN 2 THEN 'Philips'
        WHEN 3 THEN 'Intelbras'
        WHEN 4 THEN 'Xiaomi'
        WHEN 5 THEN 'Positivo'
        WHEN 6 THEN 'TP-Link'
        ELSE 'Electrolux'
    END AS fabricante,

    CASE MOD(c.id_comodo - 1, 8)
        WHEN 0 THEN 'DOMUS-SMART-2050'
        WHEN 1 THEN 'DOMUS-AIR-X5'
        WHEN 2 THEN 'DOMUS-LIGHT-V4'
        WHEN 3 THEN 'DOMUS-LOCK-3'
        WHEN 4 THEN 'DOMUS-GAS-SAFE'
        WHEN 5 THEN 'DOMUS-WATER-GUARD'
        WHEN 6 THEN 'DOMUS-SHADE-AI'
        WHEN 7 THEN 'DOMUS-POWER-2050'
    END AS modelo,

    CASE MOD(c.id_comodo - 1, 10)
        WHEN 0 THEN 120.00
        WHEN 1 THEN 1400.00
        WHEN 2 THEN 12.00
        WHEN 3 THEN 8.00
        WHEN 4 THEN 5.00
        WHEN 5 THEN 3.00
        WHEN 6 THEN 80.00
        WHEN 7 THEN 15.00
        WHEN 8 THEN 18.00
        ELSE 10.00
    END AS potencia_w,

    CASE MOD(c.id_comodo, 5)
        WHEN 0 THEN 'MANUTENCAO'
        WHEN 1 THEN 'LIGADO'
        WHEN 2 THEN 'LIGADO'
        WHEN 3 THEN 'STANDBY'
        ELSE 'LIGADO'
    END AS estado,

    CASE
        WHEN c.id_comodo <= 3000 THEN
            DATE_ADD(
                '2025-01-01',
                INTERVAL MOD(c.id_comodo * 97, 365) DAY
            )

        WHEN c.id_comodo <= 7000 THEN
            DATE_ADD(
                '2030-01-01',
                INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
            )

        WHEN c.id_comodo <= 12000 THEN
            DATE_ADD(
                '2035-01-01',
                INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
            )

        WHEN c.id_comodo <= 17000 THEN
            DATE_ADD(
                '2040-01-01',
                INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
            )

        WHEN c.id_comodo <= 20500 THEN
            DATE_ADD(
                '2045-01-01',
                INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
            )

        ELSE
            DATE_ADD(
                '2050-10-01',
                INTERVAL MOD(c.id_comodo * 97, 31) DAY
            )
    END AS data_instalacao,

    CASE
        WHEN c.id_comodo <= 20500 THEN
            DATE_ADD(
                CASE
                    WHEN c.id_comodo <= 3000 THEN
                        DATE_ADD(
                            '2025-01-01 08:00:00',
                            INTERVAL MOD(c.id_comodo * 97, 365) DAY
                        )

                    WHEN c.id_comodo <= 7000 THEN
                        DATE_ADD(
                            '2030-01-01 08:00:00',
                            INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
                        )

                    WHEN c.id_comodo <= 12000 THEN
                        DATE_ADD(
                            '2035-01-01 08:00:00',
                            INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
                        )

                    WHEN c.id_comodo <= 17000 THEN
                        DATE_ADD(
                            '2040-01-01 08:00:00',
                            INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
                        )

                    ELSE
                        DATE_ADD(
                            '2045-01-01 08:00:00',
                            INTERVAL MOD(c.id_comodo * 97, 365 * 5) DAY
                        )
                END,
                INTERVAL MOD(c.id_comodo * 13, 720) MINUTE
            )

        ELSE
            DATE_ADD(
                '2050-10-01 08:00:00',
                INTERVAL MOD(c.id_comodo * 13, 31 * 24 * 60) MINUTE
            )
    END AS ultimo_status,

    CASE
        WHEN MOD(c.id_comodo, 37) = 0 THEN 0
        ELSE 1
    END AS ativo

FROM comodos c;
