select * from pessoa_caracteristica where bigode = '1'
	and barba = 'Sim'
	and cor_cabelo = 'vermelho'
	and formato_cabelo = 'longo'
	and altura = 'alto'
	and peso IN ('mediano','magro')
	and raca = 'urban';

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
