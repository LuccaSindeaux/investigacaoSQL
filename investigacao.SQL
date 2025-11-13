-- Informações do meliante fornecidas pelo caminhoneiro
select * from pessoa_caracteristica where bigode = '1'
	and barba = 'Sim'
	and cor_cabelo = 'vermelho'
	and formato_cabelo = 'longo'
	and altura = 'alto'
	and peso IN ('mediano','magro')
	and raca = 'urban';

-- Pedido do investigador: encontrar os compradores dos últimos seis meses que compraram mais de uma vez 
select 
    nome_pessoa, 
    pessoa_id, 
    COUNT(*) AS numero_de_compras, 
    SUM(qtde) AS total_quantidade_comprada 
from 
    investigacao_compra
where 
    data_compra >= (select MAX(data_compra) from investigacao_compra) - INTERVAL '6 months'
GROUP BY 
    nome_pessoa, pessoa_id
HAVING 
    COUNT(*) > 1
ORDER BY 
    total_quantidade_comprada DESC;

SELECT * FROM investigacao_pessoa_transporte

-- Descobrindo os dis dos carros que possuem as características de ser uma caminhonete da Ford
SELECT * FROM modelo_veiculo WHERE tipo = 'caminhonete' and fabricante = 'Ford'

-- Usando os modelos_id da query anterior para filtrar veículos
SELECT * FROM veiculo WHERE cor = 'azul escuro' and modelo_id IN (55, 56, 57, 58, 68, 69);


-- Fazendo o join dos resultados anteriores com a investigação pedágio para descobrir uma placa para o carro
SELECT p.* FROM investigacao_pedagio p
	JOIN veiculo v ON p.placa = v.placa 
	WHERE v.cor = 'azul escuro' and modelo_id IN (55, 56, 57, 58, 68, 69);

-- Obtendo informações do veículo com a placa encontrada da query anterior
SELECT * FROM veiculo WHERE placa = 'YOW-5932'

-- descobrindo o proprietário do veículo com o id descoberto da query anterior
SELECT * FROM proprietario_veiculo WHERE veiculo_id = '3992b3c3-cac3-4ee8-832a-8e93c08fe684'

-- Descobrindo se o proprietário é uma pessoa física ou jurídica
SELECT * FROM proprietario WHERE id = '6b3c4089-5f06-45e3-9253-605a4f63e029'

-- Descobrindo quem é o proprietário parte 1
SELECT * FROM proprietario_pessoa_fisica WHERE proprietario_id = '6b3c4089-5f06-45e3-9253-605a4f63e029'

-- Descobrindo quem é o proprietário parte 2
select * from pessoa where id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62'

-- Verificando se as características batem com o que os ajudantes falaram
SELECT id, oculos, bigode, barba, cor_olho, cor_pele, formato_cabelo, altura, peso, raca, tatuagem 
        FROM pessoa_caracteristica WHERE pessoa_id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62'

-- filtra se Gisbert é dono de empresa de bebida
SELECT
    e.nome AS nome_empresa,
    e.situacao,
    pe.participacao
FROM
    empresa e
JOIN
    proprietario_empresa pe ON e.id = pe.empresa_id
JOIN
    proprietario_pessoa_fisica pf ON pe.proprietario_id = pf.proprietario_id
WHERE
    e.codigo_matriz = 11
    AND pf.pessoa_id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62';

-- filtra se um dos 3 urbans são donos de empresa de bebida 
SELECT
    p.nome,
    e.nome AS nome_empresa,
    pe.participacao
FROM
    empresa e
JOIN
    proprietario_empresa pe ON e.id = pe.empresa_id
JOIN
    proprietario_pessoa_fisica pf ON pe.proprietario_id = pf.proprietario_id
JOIN
    pessoa p ON pf.pessoa_id = p.id
WHERE
    e.codigo_matriz = 11 -- Apenas bebidas
    AND pf.pessoa_id IN (
        '41ecc8f8-54b3-40ab-82e8-37a084396177',
        '64b7cfad-8780-4063-9bf4-cf2736660de6',
        '9de5ea7a-ae40-472a-a752-c1568f8f4500'
    )

-- descobrindo quem dos 4 suspeitos até então possui telefone 
SELECT pf.pessoa_id, pt.telefone_id
FROM proprietario_pessoa_fisica pf
JOIN proprietario_telefone pt ON pf.proprietario_id = pt.proprietario_id
WHERE pf.pessoa_id IN (
    'ab8cfb5c-2329-4e53-b9a9-5819a5179c62', -- Gisbert
    '41ecc8f8-54b3-40ab-82e8-37a084396177', -- Urban 1
    '64b7cfad-8780-4063-9bf4-cf2736660de6', -- Urban 2
    '9de5ea7a-ae40-472a-a752-c1568f8f4500'  -- Urban 3
);

-- verifica se os telefones dos suspeitos estão dentro da tabela de investigacao
SELECT *
FROM investigacao_telefone
WHERE
    origem_telefone_id IN (886, 11610, 14283)
    OR destino_telefone_id IN (886, 11610, 14283)
ORDER BY
    data_hora DESC;

select * from investigacao_pessoa_transporte

-- pegando os ids das vítimas que não são o dono
SELECT pessoa_id, papel FROM investigacao_pessoa_transporte;

-- pegando os telefones das vítimas
SELECT pf.pessoa_id, pt.telefone_id
FROM proprietario_pessoa_fisica pf
JOIN proprietario_telefone pt ON pf.proprietario_id = pt.proprietario_id
WHERE pf.pessoa_id IN (
    'd0c5e337-3816-49c8-8f04-ead661176e6a',
    '7c681882-9217-4ffd-946b-b1bff920e7e8',
    '2930cef3-3adb-4bf4-a04d-3256519902e9'
);

-- números que ligaram para os 3 funcionários no dia do assalto, verificando quem são seus donos.
SELECT
    p.nome,
    p.sobrenome,
    pf.pessoa_id,
    pt.telefone_id
FROM
    proprietario_telefone pt
JOIN
    proprietario_pessoa_fisica pf ON pt.proprietario_id = pf.proprietario_id
JOIN
    pessoa p ON pf.pessoa_id = p.id
WHERE
    pt.telefone_id IN (
        -- Contatos do Pomponio (17627)
        21161,  
        21919,  
        18647,
        16958,
        
        -- Contatos do Aldo (40756)
        41293, 
        7994,
        19351,
        37072,
        
        -- Contatos do Ermes (334, 10062)
        12494, 
        25730, 
        5710,
        41080,
        32376,
        7096,
        30644
    );

-- filtrando Heinz, principal suspeito que ligava para Pomponio, o ajudante
SELECT * FROM pessoa_caracteristica where pessoa_id = ' 066ba2eb-d189-4536-9e6a-69d3702a7622'

-- Pegando o telefone dos 271 maiores compradores
SELECT DISTINCT pt.telefone_id
FROM proprietario_telefone pt
JOIN proprietario_pessoa_fisica pf ON pt.proprietario_id = pf.proprietario_id
WHERE pf.pessoa_id IN (
    -- Esta é a sua Query 1 (dos 271 compradores)
    SELECT pessoa_id
    FROM investigacao_compra
    WHERE data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months'
    GROUP BY pessoa_id
    HAVING COUNT(*) > 1
);

-- Rota alternativa de investigação: heinz ou Gisbert não são só exceutores do crime, mas também o mandantes donos de uma empresa que vai revender a carga roubada
SELECT
    p.nome AS nome_suspeito,
    p.sobrenome AS sobrenome_suspeito,
    e.razao_social,
    e.ramo_atuacao,
    e.faturamento_anual,
    e.situacao
FROM
    pessoa p
JOIN
    proprietario_pessoa_fisica pf ON p.id = pf.pessoa_id
JOIN
    proprietario_empresa pe ON pf.proprietario_id = pe.proprietario_id
JOIN
    empresa e ON pe.empresa_id = e.id
WHERE
    p.id IN (
        '066ba2eb-d189-4536-9e6a-69d3702a7622',
        'ab8cfb5c-2329-4e53-b9a9-5819a5179c62'  
    );