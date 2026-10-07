USE domus_ai;

SET @quantidade_residencias = 3660;
select*from residencias;
INSERT INTO residencias
(
    id_residencia,
    id_usuario,
    nome,
    endereco,
    cidade,
    estado,
    cep,
    tipo_residencia,
    quantidade_moradores,
    area_m2,
    data_cadastro,
    ativo
)

SELECT
    u.id_usuario AS id_residencia,

    u.id_usuario,

    CONCAT(
        'Residencia de ',
        u.nome
    ) AS nome,

    CONCAT(
        ELT(
            1 + MOD(u.id_usuario * 13, 20),

            'Rua das Palmeiras',
            'Rua das Acacias',
            'Rua dos Ipês',
            'Rua das Flores',
            'Rua do Sol',
            'Avenida Central',
            'Rua das Hortensias',
            'Rua das Oliveiras',
            'Rua dos Pinheiros',
            'Rua das Mangueiras',
            'Avenida Brasil',
            'Rua Primavera',
            'Rua Bela Vista',
            'Rua das Amendoeiras',
            'Rua do Bosque',
            'Rua Nova',
            'Avenida das Nações',
            'Rua Jardim Europa',
            'Rua das Estrelas',
            'Rua Horizonte'
        ),

        ', ',

        50 + MOD(u.id_usuario * 7919, 9950)

    ) AS endereco,

    ELT(
        1 + MOD(u.id_usuario * 17, 20),

        'Sao Paulo',
        'Campinas',
        'Santos',
        'Rio de Janeiro',
        'Niteroi',
        'Belo Horizonte',
        'Uberlandia',
        'Curitiba',
        'Londrina',
        'Porto Alegre',
        'Florianopolis',
        'Joinville',
        'Salvador',
        'Recife',
        'Fortaleza',
        'Brasilia',
        'Goiania',
        'Vitoria',
        'Manaus',
        'Belem'
    ) AS cidade,

    ELT(
        1 + MOD(u.id_usuario * 17, 20),

        'SP',
        'SP',
        'SP',
        'RJ',
        'RJ',
        'MG',
        'MG',
        'PR',
        'PR',
        'RS',
        'SC',
        'SC',
        'BA',
        'PE',
        'CE',
        'DF',
        'GO',
        'ES',
        'AM',
        'PA'
    ) AS estado,

    CONCAT(
        LPAD(
            10000 + MOD(u.id_usuario * 7919, 89999),
            5,
            '0'
        ),
        '-',
        LPAD(
            MOD(u.id_usuario * 3571, 1000),
            3,
            '0'
        )
    ) AS cep,

    ELT(
        1 + MOD(u.id_usuario * 11, 6),

        'Casa',
        'Apartamento',
        'Sobrado',
        'Cobertura',
        'Casa em Condominio',
        'Studio'
    ) AS tipo_residencia,

    1 + MOD(u.id_usuario * 7, 5) AS quantidade_moradores,

    45 + MOD(u.id_usuario * 17, 250) AS area_m2,

    u.data_cadastro,

    u.ativo

FROM usuarios u

WHERE u.id_usuario <= @quantidade_residencias;
