USE domus_ai;

DELETE FROM usuarios;
SELECT COUNT(*) AS total_usuarios
FROM usuarios;
select*from usuarios;

SELECT
    YEAR(data_cadastro) AS ano,
    COUNT(*) AS quantidade
FROM usuarios
GROUP BY YEAR(data_cadastro)
ORDER BY ano;

USE domus_ai;

SET @quantidade_usuarios = 3660;

INSERT INTO usuarios
(
    id_usuario,
    nome,
    email,
    senha_hash,
    telefone,
    data_cadastro,
    ativo
)

SELECT
    n AS id_usuario,

    CONCAT(
        ELT(
            1 + MOD((n * 37 + 11), 60),

            'Joao',
            'Maria',
            'Carlos',
            'Ana',
            'Lucas',
            'Juliana',
            'Rafael',
            'Camila',
            'Pedro',
            'Fernanda',
            'Gustavo',
            'Beatriz',
            'Thiago',
            'Larissa',
            'Daniel',
            'Mariana',
            'Felipe',
            'Amanda',
            'Bruno',
            'Gabriela',
            'Eduardo',
            'Patricia',
            'Renato',
            'Leticia',
            'Diego',
            'Bianca',
            'Marcelo',
            'Vanessa',
            'Rodrigo',
            'Natalia',
            'Victor',
            'Aline',
            'Leonardo',
            'Priscila',
            'Mateus',
            'Isabela',
            'Andre',
            'Carolina',
            'Henrique',
            'Daniela',
            'Sergio',
            'Luana',
            'Vinicius',
            'Monica',
            'Samuel',
            'Bruna',
            'Fabio',
            'Renata',
            'Caio',
            'Tatiana',
            'Arthur',
            'Alessandra',
            'Murilo',
            'Debora',
            'Cristian',
            'Raquel',
            'Wesley',
            'Flavia',
            'Yuri',
            'Evelyn'
        ),
        ' ',
        ELT(
            1 + MOD((n * 53 + 17), 61),

            'Silva',
            'Santos',
            'Oliveira',
            'Souza',
            'Costa',
            'Pereira',
            'Rodrigues',
            'Almeida',
            'Ferreira',
            'Alves',
            'Lima',
            'Gomes',
            'Ribeiro',
            'Carvalho',
            'Araujo',
            'Martins',
            'Rocha',
            'Barbosa',
            'Dias',
            'Nascimento',
            'Correia',
            'Mendes',
            'Freitas',
            'Vieira',
            'Moreira',
            'Cardoso',
            'Teixeira',
            'Ramos',
            'Castro',
            'Duarte',
            'Monteiro',
            'Melo',
            'Neves',
            'Barros',
            'Moura',
            'Freire',
            'Guimaraes',
            'Nunes',
            'Miranda',
            'Braga',
            'Farias',
            'Campos',
            'Cunha',
            'Pires',
            'Moraes',
            'Borges',
            'Santana',
            'Tavares',
            'Siqueira',
            'Dantas',
            'Mota',
            'Bezerra',
            'Coelho',
            'Sampaio',
            'Sales',
            'Andrade',
            'Brito',
            'Viana',
            'Macedo',
            'Rezende',
            'Queiroz'
        )
    ) AS nome,

    LOWER(
        CONCAT(
            ELT(
                1 + MOD((n * 37 + 11), 60),

                'joao',
                'maria',
                'carlos',
                'ana',
                'lucas',
                'juliana',
                'rafael',
                'camila',
                'pedro',
                'fernanda',
                'gustavo',
                'beatriz',
                'thiago',
                'larissa',
                'daniel',
                'mariana',
                'felipe',
                'amanda',
                'bruno',
                'gabriela',
                'eduardo',
                'patricia',
                'renato',
                'leticia',
                'diego',
                'bianca',
                'marcelo',
                'vanessa',
                'rodrigo',
                'natalia',
                'victor',
                'aline',
                'leonardo',
                'priscila',
                'mateus',
                'isabela',
                'andre',
                'carolina',
                'henrique',
                'daniela',
                'sergio',
                'luana',
                'vinicius',
                'monica',
                'samuel',
                'bruna',
                'fabio',
                'renata',
                'caio',
                'tatiana',
                'arthur',
                'alessandra',
                'murilo',
                'debora',
                'cristian',
                'raquel',
                'wesley',
                'flavia',
                'yuri',
                'evelyn'
            ),
            '.',
            ELT(
                1 + MOD((n * 53 + 17), 61),

                'silva',
                'santos',
                'oliveira',
                'souza',
                'costa',
                'pereira',
                'rodrigues',
                'almeida',
                'ferreira',
                'alves',
                'lima',
                'gomes',
                'ribeiro',
                'carvalho',
                'araujo',
                'martins',
                'rocha',
                'barbosa',
                'dias',
                'nascimento',
                'correia',
                'mendes',
                'freitas',
                'vieira',
                'moreira',
                'cardoso',
                'teixeira',
                'ramos',
                'castro',
                'duarte',
                'monteiro',
                'melo',
                'neves',
                'barros',
                'moura',
                'freire',
                'guimaraes',
                'nunes',
                'miranda',
                'braga',
                'farias',
                'campos',
                'cunha',
                'pires',
                'moraes',
                'borges',
                'santana',
                'tavares',
                'siqueira',
                'dantas',
                'mota',
                'bezerra',
                'coelho',
                'sampaio',
                'sales',
                'andrade',
                'brito',
                'viana',
                'macedo',
                'rezende',
                'queiroz'
            ),
            '.',
            LPAD(n, 4, '0'),
            '@domus.com.br'
        )
    ) AS email,

    SHA2(
        CONCAT('Domus@2050#', n),
        256
    ) AS senha_hash,

    CONCAT(
        '(',
        ELT(
            1 + MOD(n * 7, 20),
            '11',
            '19',
            '21',
            '27',
            '31',
            '41',
            '47',
            '48',
            '51',
            '61',
            '62',
            '63',
            '65',
            '67',
            '71',
            '73',
            '79',
            '81',
            '85',
            '91'
        ),
        ') 9',
        LPAD(
            MOD(
                (n * 7393917) + 2847311,
                100000000
            ),
            8,
            '0'
        )
    ) AS telefone,

    CASE
        WHEN n > (@quantidade_usuarios - 300) THEN
            DATE_ADD(
                '2050-10-01 00:00:00',
                INTERVAL MOD(n * 173, 31 * 24 * 60) MINUTE
            )
        ELSE
            DATE_ADD(
                '2025-01-01 00:00:00',
                INTERVAL FLOOR(
                    ((n - 1) * 9434) / (@quantidade_usuarios - 301)
                ) DAY
            )
            + INTERVAL MOD(n * 137, 1440) MINUTE
    END AS data_cadastro,

    CASE
        WHEN MOD(n, 17) = 0 THEN 0
        ELSE 1
    END AS ativo

FROM
(
    SELECT
        a.n
        + (b.n * 10)
        + (c.n * 100)
        + (d.n * 1000)
        + 1 AS n

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

    WHERE
        (
            a.n
            + (b.n * 10)
            + (c.n * 100)
            + (d.n * 1000)
            + 1
        ) <= @quantidade_usuarios
) numeros;

USE domus_ai;

UPDATE usuarios
SET data_cadastro =
    CASE

        /* 2025 - 40 usuários */
        WHEN id_usuario BETWEEN 1 AND 40 THEN
            DATE_ADD(
                '2025-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2026 - 48 usuários */
        WHEN id_usuario BETWEEN 41 AND 88 THEN
            DATE_ADD(
                '2026-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2027 - 56 usuários */
        WHEN id_usuario BETWEEN 89 AND 144 THEN
            DATE_ADD(
                '2027-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2028 - 64 usuários */
        WHEN id_usuario BETWEEN 145 AND 208 THEN
            DATE_ADD(
                '2028-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2029 - 72 usuários */
        WHEN id_usuario BETWEEN 209 AND 280 THEN
            DATE_ADD(
                '2029-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2030 - 80 usuários */
        WHEN id_usuario BETWEEN 281 AND 360 THEN
            DATE_ADD(
                '2030-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2031 - 88 usuários */
        WHEN id_usuario BETWEEN 361 AND 448 THEN
            DATE_ADD(
                '2031-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2032 - 96 usuários */
        WHEN id_usuario BETWEEN 449 AND 544 THEN
            DATE_ADD(
                '2032-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2033 - 104 usuários */
        WHEN id_usuario BETWEEN 545 AND 648 THEN
            DATE_ADD(
                '2033-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2034 - 112 usuários */
        WHEN id_usuario BETWEEN 649 AND 760 THEN
            DATE_ADD(
                '2034-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2035 - 120 usuários */
        WHEN id_usuario BETWEEN 761 AND 880 THEN
            DATE_ADD(
                '2035-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2036 - 128 usuários */
        WHEN id_usuario BETWEEN 881 AND 1008 THEN
            DATE_ADD(
                '2036-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2037 - 136 usuários */
        WHEN id_usuario BETWEEN 1009 AND 1144 THEN
            DATE_ADD(
                '2037-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2038 - 144 usuários */
        WHEN id_usuario BETWEEN 1145 AND 1288 THEN
            DATE_ADD(
                '2038-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2039 - 152 usuários */
        WHEN id_usuario BETWEEN 1289 AND 1440 THEN
            DATE_ADD(
                '2039-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2040 - 160 usuários */
        WHEN id_usuario BETWEEN 1441 AND 1600 THEN
            DATE_ADD(
                '2040-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2041 - 170 usuários */
        WHEN id_usuario BETWEEN 1601 AND 1770 THEN
            DATE_ADD(
                '2041-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2042 - 178 usuários */
        WHEN id_usuario BETWEEN 1771 AND 1948 THEN
            DATE_ADD(
                '2042-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2043 - 186 usuários */
        WHEN id_usuario BETWEEN 1949 AND 2134 THEN
            DATE_ADD(
                '2043-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2044 - 194 usuários */
        WHEN id_usuario BETWEEN 2135 AND 2328 THEN
            DATE_ADD(
                '2044-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2045 - 202 usuários */
        WHEN id_usuario BETWEEN 2329 AND 2530 THEN
            DATE_ADD(
                '2045-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2046 - 210 usuários */
        WHEN id_usuario BETWEEN 2531 AND 2740 THEN
            DATE_ADD(
                '2046-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2047 - 218 usuários */
        WHEN id_usuario BETWEEN 2741 AND 2958 THEN
            DATE_ADD(
                '2047-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2048 - 226 usuários */
        WHEN id_usuario BETWEEN 2959 AND 3184 THEN
            DATE_ADD(
                '2048-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 366 * 24 * 60) MINUTE
            )

        /* 2049 - 234 usuários */
        WHEN id_usuario BETWEEN 3185 AND 3418 THEN
            DATE_ADD(
                '2049-01-01 08:00:00',
                INTERVAL MOD(id_usuario * 197, 365 * 24 * 60) MINUTE
            )

        /* 2050 - 242 usuários, somente outubro */
        WHEN id_usuario BETWEEN 3419 AND 3660 THEN
            DATE_ADD(
                '2050-10-01 00:00:00',
                INTERVAL MOD(id_usuario * 197, 31 * 24 * 60) MINUTE
            )

    END;