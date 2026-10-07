USE domus_ai;
select*from eventos_dispositivo;
SET @quantidade_eventos = 20000;

INSERT INTO eventos_dispositivo
(
    id_dispositivo,
    data_hora,
    evento,
    estado_anterior,
    estado_novo,
    motivo,
    origem
)

SELECT

    MOD(n - 1, 21960) + 1 AS id_dispositivo,

    CASE
        WHEN n > 19400 THEN
            DATE_ADD(
                '2050-10-01 00:00:00',
                INTERVAL MOD(n * 137, 31 * 24 * 60) MINUTE
            )

        WHEN n > 17800 THEN
            DATE_ADD(
                '2049-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        WHEN n > 15800 THEN
            DATE_ADD(
                '2047-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        WHEN n > 13500 THEN
            DATE_ADD(
                '2044-01-01 00:00:00',
                INTERVAL MOD(n * 137, 366 * 24 * 60) MINUTE
            )

        WHEN n > 11000 THEN
            DATE_ADD(
                '2041-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        WHEN n > 8500 THEN
            DATE_ADD(
                '2038-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        WHEN n > 6000 THEN
            DATE_ADD(
                '2035-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        WHEN n > 3500 THEN
            DATE_ADD(
                '2030-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )

        ELSE
            DATE_ADD(
                '2025-01-01 00:00:00',
                INTERVAL MOD(n * 137, 365 * 24 * 60) MINUTE
            )
    END AS data_hora,

    CASE MOD(n, 10)

        WHEN 0 THEN 'LIGAMENTO'
        WHEN 1 THEN 'DESLIGAMENTO'
        WHEN 2 THEN 'AUTOMACAO'
        WHEN 3 THEN 'AJUSTE'
        WHEN 4 THEN 'MUDANCA_ESTADO'
        WHEN 5 THEN 'FALHA'
        WHEN 6 THEN 'RESTAURACAO'
        WHEN 7 THEN 'MANUTENCAO'
        WHEN 8 THEN 'EMERGENCIA'
        ELSE 'COMANDO_IA'

    END AS evento,

    CASE MOD(n, 5)

        WHEN 0 THEN 'DESLIGADO'
        WHEN 1 THEN 'LIGADO'
        WHEN 2 THEN 'STANDBY'
        WHEN 3 THEN 'MANUTENCAO'
        ELSE 'DESLIGADO'

    END AS estado_anterior,

    CASE MOD(n, 5)

        WHEN 0 THEN 'LIGADO'
        WHEN 1 THEN 'DESLIGADO'
        WHEN 2 THEN 'LIGADO'
        WHEN 3 THEN 'DESLIGADO'
        ELSE 'STANDBY'

    END AS estado_novo,

    CASE MOD(n, 10)

        WHEN 0 THEN 'Dispositivo ativado conforme rotina programada da residência.'
        
        WHEN 1 THEN 'Dispositivo desligado automaticamente para reduzir consumo de energia.'
        
        WHEN 2 THEN 'A automação residencial alterou o estado do dispositivo conforme as condições do ambiente.'
        
        WHEN 3 THEN 'Configuração do dispositivo ajustada conforme preferência registrada pelo usuário.'
        
        WHEN 4 THEN 'O sistema identificou uma alteração necessária no estado do dispositivo.'
        
        WHEN 5 THEN 'Foi identificada uma falha temporária no funcionamento do dispositivo.'
        
        WHEN 6 THEN 'O funcionamento normal do dispositivo foi restaurado após uma ocorrência.'
        
        WHEN 7 THEN 'O dispositivo entrou em rotina de manutenção preventiva.'
        
        WHEN 8 THEN 'A inteligência artificial acionou o dispositivo devido a uma situação de emergência.'
        
        ELSE 'Comando executado pela inteligência artificial DOMUS.'
        
    END AS motivo,

    CASE MOD(n, 6)

        WHEN 0 THEN 'IA'
        WHEN 1 THEN 'AUTOMACAO'
        WHEN 2 THEN 'SENSOR'
        WHEN 3 THEN 'USUARIO'
        WHEN 4 THEN 'IA'
        ELSE 'AUTOMACAO'

    END AS origem

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
        <= @quantidade_eventos

) numeros;
