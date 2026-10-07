USE domus_ai;
select*from recomendacoes;
INSERT INTO recomendacoes
(
    id_residencia,
    id_alerta,
    id_anomalia,
    data_geracao,
    categoria,
    titulo,
    descricao,
    impacto_estimado,
    unidade_impacto,
    prioridade,
    status
)
SELECT
    a.id_residencia,
    a.id_alerta,
    a.id_anomalia,
    a.data_hora,

    CASE
        WHEN a.tipo = 'VAZAMENTO_GAS' THEN 'GAS'
        WHEN a.tipo = 'VAZAMENTO_AGUA' THEN 'AGUA'
        WHEN a.tipo = 'FUMACA' THEN 'SEGURANCA'
        WHEN a.tipo = 'TEMPERATURA' THEN 'CLIMA'
        WHEN a.tipo = 'PRESENCA' THEN 'SEGURANCA'
        WHEN a.tipo = 'PORTA_ABERTA' THEN 'SEGURANCA'
        WHEN a.tipo = 'CONSUMO_ENERGIA' THEN 'ENERGIA'
        WHEN a.tipo = 'UMIDADE' THEN 'CLIMA'
        WHEN a.tipo = 'QUALIDADE_AR' THEN 'AMBIENTE'
        WHEN a.tipo = 'FALHA_DISPOSITIVO' THEN 'MANUTENCAO'
        ELSE 'GERAL'
    END AS categoria,

    CASE
        WHEN a.tipo = 'VAZAMENTO_GAS'
            THEN 'Verificar sistema de gas'
        WHEN a.tipo = 'VAZAMENTO_AGUA'
            THEN 'Verificar possivel vazamento de agua'
        WHEN a.tipo = 'FUMACA'
            THEN 'Verificar origem da fumaca'
        WHEN a.tipo = 'TEMPERATURA'
            THEN 'Ajustar temperatura do ambiente'
        WHEN a.tipo = 'PRESENCA'
            THEN 'Verificar movimentacao detectada'
        WHEN a.tipo = 'PORTA_ABERTA'
            THEN 'Verificar porta ou janela'
        WHEN a.tipo = 'CONSUMO_ENERGIA'
            THEN 'Reduzir consumo de energia'
        WHEN a.tipo = 'UMIDADE'
            THEN 'Controlar umidade do ambiente'
        WHEN a.tipo = 'QUALIDADE_AR'
            THEN 'Verificar qualidade do ar'
        WHEN a.tipo = 'FALHA_DISPOSITIVO'
            THEN 'Realizar manutencao preventiva'
        ELSE
            'Verificar situacao identificada pela DOMUS'
    END AS titulo,

    CASE
        WHEN a.tipo = 'VAZAMENTO_GAS'
            THEN 'A DOMUS identificou uma concentracao anormal de gas e recomenda verificar o ambiente e manter o protocolo de seguranca ativo.'

        WHEN a.tipo = 'VAZAMENTO_AGUA'
            THEN 'A DOMUS identificou comportamento de consumo de agua acima do esperado. Recomenda-se verificar torneiras, tubulacoes e equipamentos.'

        WHEN a.tipo = 'FUMACA'
            THEN 'Foi detectada presenca de fumaca. Recomenda-se verificar a origem e manter os sistemas de seguranca ativados.'

        WHEN a.tipo = 'TEMPERATURA'
            THEN 'A temperatura apresentou comportamento fora do padrao. Recomenda-se ajustar a climatizacao do ambiente.'

        WHEN a.tipo = 'PRESENCA'
            THEN 'Foi detectada movimentacao diferente do comportamento habitual. Recomenda-se verificar a area monitorada.'

        WHEN a.tipo = 'PORTA_ABERTA'
            THEN 'Uma porta ou janela permaneceu aberta por tempo acima do comportamento habitual da residencia.'

        WHEN a.tipo = 'CONSUMO_ENERGIA'
            THEN 'A inteligencia artificial identificou consumo elevado. Recomenda-se revisar os equipamentos de maior consumo.'

        WHEN a.tipo = 'UMIDADE'
            THEN 'O nivel de umidade esta fora do comportamento esperado. Recomenda-se verificar ventilacao e possiveis fontes de umidade.'

        WHEN a.tipo = 'QUALIDADE_AR'
            THEN 'Foram identificadas alteracoes na qualidade do ar. Recomenda-se verificar ventilacao e condicoes do ambiente.'

        WHEN a.tipo = 'FALHA_DISPOSITIVO'
            THEN 'Foi identificado comportamento irregular em um dispositivo. Recomenda-se realizar manutencao preventiva.'

        ELSE
            'A DOMUS identificou uma situacao fora do comportamento esperado e gerou esta recomendacao.'
    END AS descricao,

    CASE
        WHEN a.tipo = 'VAZAMENTO_GAS' THEN 1.00
        WHEN a.tipo = 'VAZAMENTO_AGUA' THEN 12.50
        WHEN a.tipo = 'FUMACA' THEN 1.00
        WHEN a.tipo = 'TEMPERATURA' THEN 4.50
        WHEN a.tipo = 'PRESENCA' THEN 1.00
        WHEN a.tipo = 'PORTA_ABERTA' THEN 5.00
        WHEN a.tipo = 'CONSUMO_ENERGIA' THEN 18.50
        WHEN a.tipo = 'UMIDADE' THEN 8.00
        WHEN a.tipo = 'QUALIDADE_AR' THEN 15.00
        WHEN a.tipo = 'FALHA_DISPOSITIVO' THEN 25.00
        ELSE 5.00
    END AS impacto_estimado,

    CASE
        WHEN a.tipo = 'VAZAMENTO_GAS' THEN 'ppm'
        WHEN a.tipo = 'VAZAMENTO_AGUA' THEN 'L'
        WHEN a.tipo = 'FUMACA' THEN 'nivel'
        WHEN a.tipo = 'TEMPERATURA' THEN '°C'
        WHEN a.tipo = 'PRESENCA' THEN 'eventos'
        WHEN a.tipo = 'PORTA_ABERTA' THEN 'minutos'
        WHEN a.tipo = 'CONSUMO_ENERGIA' THEN '%'
        WHEN a.tipo = 'UMIDADE' THEN '%'
        WHEN a.tipo = 'QUALIDADE_AR' THEN '%'
        WHEN a.tipo = 'FALHA_DISPOSITIVO' THEN '%'
        ELSE '%'
    END AS unidade_impacto,

    CASE
        WHEN a.severidade = 'CRITICA' THEN 'CRITICA'
        WHEN a.severidade = 'ALTA' THEN 'ALTA'
        WHEN a.severidade = 'MEDIA' THEN 'MEDIA'
        ELSE 'BAIXA'
    END AS prioridade,

    CASE
        WHEN a.status = 'ATIVO' THEN 'PENDENTE'
        WHEN a.status = 'EM_ANALISE' THEN 'EM_ANALISE'
        WHEN a.status = 'RESOLVIDO' THEN 'APLICADA'
        ELSE 'PENDENTE'
    END AS status

FROM alertas a

WHERE NOT EXISTS
(
    SELECT 1
    FROM recomendacoes r
    WHERE r.id_alerta = a.id_alerta
);
