USE domus_ai;

SELECT
    id_tipo_dispositivo,
    nome,
    categoria,
    descricao
FROM tipos_dispositivo
ORDER BY id_tipo_dispositivo;
