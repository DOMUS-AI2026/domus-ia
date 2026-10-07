USE domus_ai;
select*from comodos;
SET @quantidade_residencias = 3660;
SET @comodos_por_residencia = 6;

INSERT INTO comodos
(
    id_residencia,
    nome,
    tipo_comodo,
    andar,
    area_m2,
    ativo
)

SELECT

    r.id_residencia,

    CASE c.tipo
        WHEN 1 THEN 'Sala de estar'
        WHEN 2 THEN 'Cozinha'
        WHEN 3 THEN 'Quarto principal'
        WHEN 4 THEN 'Quarto'
        WHEN 5 THEN 'Banheiro'
        WHEN 6 THEN 'Lavanderia'
    END AS nome,

    CASE c.tipo
        WHEN 1 THEN 'SALA'
        WHEN 2 THEN 'COZINHA'
        WHEN 3 THEN 'QUARTO'
        WHEN 4 THEN 'QUARTO'
        WHEN 5 THEN 'BANHEIRO'
        WHEN 6 THEN 'LAVANDERIA'
    END AS tipo_comodo,

    CASE
        WHEN c.tipo IN (1,2,3,4,5,6)
            THEN 1 + MOD(r.id_residencia * 7, 3)
    END AS andar,

    CASE c.tipo
        WHEN 1 THEN 12 + MOD(r.id_residencia * 17, 25)
        WHEN 2 THEN 7 + MOD(r.id_residencia * 13, 15)
        WHEN 3 THEN 10 + MOD(r.id_residencia * 19, 20)
        WHEN 4 THEN 8 + MOD(r.id_residencia * 23, 15)
        WHEN 5 THEN 4 + MOD(r.id_residencia * 11, 8)
        WHEN 6 THEN 5 + MOD(r.id_residencia * 29, 10)
    END AS area_m2,

    CASE
        WHEN MOD(r.id_residencia + c.tipo, 37) = 0 THEN 0
        ELSE 1
    END AS ativo

FROM residencias r

CROSS JOIN
(
    SELECT 1 AS tipo
    UNION ALL SELECT 2
    UNION ALL SELECT 3
    UNION ALL SELECT 4
    UNION ALL SELECT 5
    UNION ALL SELECT 6
) c

WHERE r.id_residencia <= @quantidade_residencias;
