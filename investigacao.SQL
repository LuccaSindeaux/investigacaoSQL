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