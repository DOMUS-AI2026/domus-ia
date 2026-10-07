USE domus_ai;
select*from alertas;
INSERT INTO alertas
(
    id_alerta,
    id_residencia,
    id_anomalia,
    data_hora,
    tipo,
    titulo,
    mensagem,
    severidade,
    status,
    canal
)

SELECT
    ROW_NUMBER() OVER (ORDER BY a.id_anomalia) AS id_alerta,

    a.id_residencia,

    a.id_anomalia,

    a.data_hora,

    CASE a.tipo
        WHEN 'VAZAMENTO_GAS' THEN 'VAZAMENTO_GAS'
        WHEN 'VAZAMENTO_AGUA' THEN 'VAZAMENTO_AGUA'
        WHEN 'INTRUSAO_DETECTADA' THEN 'INTRUSAO'
        WHEN 'CONSUMO_ENERGIA' THEN 'CONSUMO_ENERGIA'
        WHEN 'TEMPERATURA_ELEVADA' THEN 'TEMPERATURA'
        WHEN 'UMIDADE_ANORMAL' THEN 'UMIDADE'
        WHEN 'QUALIDADE_AR_BAIXA' THEN 'QUALIDADE_AR'
        WHEN 'PRESENCA_INESPERADA' THEN 'PRESENCA'
        WHEN 'FALHA_DISPOSITIVO' THEN 'FALHA_DISPOSITIVO'
        WHEN 'CONDICAO_AMBIENTAL_ANORMAL' THEN 'AMBIENTE'
        ELSE 'OUTRO'
    END AS tipo,

    CASE a.tipo
        WHEN 'VAZAMENTO_GAS'
            THEN 'Vazamento de gás detectado'

        WHEN 'VAZAMENTO_AGUA'
            THEN 'Vazamento de água detectado'

        WHEN 'INTRUSAO_DETECTADA'
            THEN 'Possível intrusão detectada'

        WHEN 'CONSUMO_ENERGIA'
            THEN 'Consumo de energia elevado'

        WHEN 'TEMPERATURA_ELEVADA'
            THEN 'Temperatura elevada'

        WHEN 'UMIDADE_ANORMAL'
            THEN 'Umidade fora do padrão'

        WHEN 'QUALIDADE_AR_BAIXA'
            THEN 'Qualidade do ar alterada'

        WHEN 'PRESENCA_INESPERADA'
            THEN 'Presença inesperada detectada'

        WHEN 'FALHA_DISPOSITIVO'
            THEN 'Falha em dispositivo'

        WHEN 'CONDICAO_AMBIENTAL_ANORMAL'
            THEN 'Condição ambiental anormal'

        ELSE 'Anomalia detectada'
    END AS titulo,

    CASE a.tipo

        WHEN 'VAZAMENTO_GAS'
            THEN 'A DOMUS detectou concentração anormal de gás e acionou automaticamente o protocolo de segurança.'

        WHEN 'VAZAMENTO_AGUA'
            THEN 'A DOMUS identificou fluxo de água acima do padrão esperado para a residência.'

        WHEN 'INTRUSAO_DETECTADA'
            THEN 'Foi identificada movimentação incomum em uma área monitorada da residência.'

        WHEN 'CONSUMO_ENERGIA'
            THEN 'A inteligência artificial identificou consumo de energia acima do padrão histórico da residência.'

        WHEN 'TEMPERATURA_ELEVADA'
            THEN 'A temperatura do ambiente ultrapassou o limite configurado no sistema DOMUS.'

        WHEN 'UMIDADE_ANORMAL'
            THEN 'O nível de umidade apresentou comportamento fora dos parâmetros esperados.'

        WHEN 'QUALIDADE_AR_BAIXA'
            THEN 'Os sensores identificaram alteração nos parâmetros de qualidade do ar.'

        WHEN 'PRESENCA_INESPERADA'
            THEN 'Foi detectada presença em horário ou local considerado incomum pelo sistema.'

        WHEN 'FALHA_DISPOSITIVO'
            THEN 'Um dispositivo conectado apresentou comportamento diferente do funcionamento esperado.'

        WHEN 'CONDICAO_AMBIENTAL_ANORMAL'
            THEN 'A inteligência artificial identificou uma condição ambiental fora do padrão.'

        ELSE
            'A DOMUS identificou uma situação fora do comportamento esperado.'
    END AS mensagem,

    a.severidade,

    CASE a.status
        WHEN 'ABERTA' THEN 'ATIVO'
        WHEN 'EM_ANALISE' THEN 'EM_ANALISE'
        WHEN 'RESOLVIDA' THEN 'RESOLVIDO'
        ELSE 'ATIVO'
    END AS status,

    CASE MOD(a.id_anomalia, 6)
        WHEN 0 THEN 'APP'
        WHEN 1 THEN 'APP'
        WHEN 2 THEN 'NOTIFICACAO'
        WHEN 3 THEN 'SMS'
        WHEN 4 THEN 'EMAIL'
        WHEN 5 THEN 'APP'
    END AS canal

FROM anomalias a

ORDER BY a.id_anomalia

LIMIT 10000;
