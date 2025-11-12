<h2>Investigando os meliantes</h2>

Apesar de haverem algumas informações vagas, o motorista do caminhão entrevistado forneceu muitos delathes sobre um dos 3 meliantes, pensei que através dele poderia chegar nos outros dois, a primeira busca feita foi uma para filtrar possíveis suspeitos. A busca foi feita com a query:

SELECT * from pessoa_caracteristica where bigode = '1'<br>
	AND barba = 'Sim'
	AND cor_cabelo = 'vermelho'
	AND formato_cabelo = 'longo'
	AND altura = 'alto'
	AND peso IN ('mediano','magro')
	AND raca = 'urban';

Eu não utilizei a informação de que ele estava com óculos escuros, porque a coluna de óculos parece ser óculos de grau, com isto minha busca me retornou 3 resultados:
| id    | pessoa_id                                  |
| :---- | :----------------------------------------- |
| 6525  | 41ecc8f8-54b3-40ab-82e8-37a0843961c0        |
| 12099 | 64b7cfad-8780-4063-9bf4-cf2736660de6        |
| 38239 | 9de5ea7a-ae40-472a-a752-c1568f8f4500        |


<h2>Seguindo os pedidos do investigador responsável(Parte 1):</h2>
<h3>1. Maiores compradores de vinhos nos últimos seis meses.</h3>
 
Apliquei a query abaixo e obtive 271 linhas de resultado:

SELECT <br>
    nome_pessoa, <br>
    pessoa_id, <br>
    COUNT(*) AS numero_de_compras, <br>
    SUM(qtde) AS total_quantidade_comprada <br>
FROM <br>
    investigacao_compra <br>
WHERE <br>
    data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months' <br>
GROUP BY <br>
    nome_pessoa, pessoa_id <br>
HAVING <br>
    COUNT(*) > 1 <br>
ORDER BY <br>
    total_quantidade_comprada DESC;

<h3>2. Listando os envolvidos.</h3>
Listei os envolvidos com
SELECT * FROM investigacao_pessoa_transporte

<h3>3. Sobre o veículos suspeito.</h4>
Apenas um: "SELECT * FROM veiculo WHERE cor = 'azul escuro'  " não basta, preciso de mais um filtro;

Indo para a tabela "modelo_veiculo", usei as informações do veículo: sobre ele ser uma caminhonete e ser da Ford:

SELECT * FROM modelo_veiculo WHERE tipo = 'caminhonete' and fabricante = 'Ford'

6 resultados foram encontrados, curiosamente os id de todos eles são bem próximos: 55, 56, 57, 58, 68 e 69. O filtro que precisava era este, rodei a query:

SELECT * FROM veiculo WHERE cor = 'azul escuro' and modelo_id IN (55, 56, 57, 58, 68, 69);

Que gerou 56 linhas de resultado.

<h3>4. Listando com investigacao_pedagio</h3>
Os 56 resultados todos possuem um item na coluna "placa", que também está presente na tabela investigacao_pedagio. Sendo possível fazer um join das tabelas aqui por possuirem um domínio em comum, a query foi:

SELECT p.* FROM investigacao_pedagio p
	JOIN veiculo v ON p.placa = v.placa 
	WHERE v.cor = 'azul escuro' and modelo_id IN (55, 56, 57, 58, 68, 69);

O resultado foi surpreendentemente um único veículo com as seguintes colunas: 
| id  | data_hora           | localizacao | sentido_trajeto    | placa    |
| :-- | :------------------ | :---------- | :----------------- | :------- |
| 422 | 2024-11-17 18:56:28 | Relva_r49   | Santa_Maria->Relva | YOW-5932 |



<h3>5. Listagem das ligações telefônicas</h3>
Com a query " SELECT * FROM investigacao_telefone ", obtive um retorno de 976 linhas, ainda tenho de prosseguir mais na investigação para entender como usar e filtrar estes dados.


<h2>Continuação da investigação (Parte 2):</h2>

Com a placa do veículo suspeito em mãos, fui à tabel "veiculo" e descobri seu id com a query " SELECT * FROM veiculo WHERE placa = 'YOW-5932' ", obtendo o resultado:

| id                                   | modelo_id | cor         | ano  | placa    |
| :----------------------------------- | :-------- | :---------- | :--- | :------- |
| 3992b3c3-cac3-4ee8-832a-8e93c08fe684 | 55        | azul escuro | 1972 | YOW-5932 |

Usando o id do véiculo, fui a proprietario_veiculo, e com a query " SELECT * FROM proprietario_veiculo WHERE veiculo_id = '3992b3c3-cac3-4ee8-832a-8e93c08fe684' ", obtive o id do proprietario com o resultado:

| id    | veiculo_id                           | proprietario_id                      | data_compra |
| :---- | :----------------------------------- | :----------------------------------- | :---------- |
| 15064 | 3992b3c3-cac3-4ee8-832a-8e93c08fe684 | 6b3c4089-5f06-45e3-9253-605a4f63e029 | 2019-08-05  |

Voltando um degrau acima, na tabela proprietario, lancei mão de <br>" SELECT * FROM proprietario WHERE id = '6b3c4089-5f06-45e3-9253-605a4f63e029' "<br> descobri que o proprietario era uma pessoa física. 

| id                                   | tipo_proprietario |
| :----------------------------------- | :---------------- |
| 6b3c4089-5f06-45e3-9253-605a4f63e029 | Pessoa Fisica     |

Fazendo um rápido comparativo com a tabela que obtive usando as informações do caminhoneiro, o id do proprietario do veículo não é igual a nenhum dos 3 eesultados. Ou seja, é provável que o homem descrito pelo caminhoneiro não é o proprietário do veículo, podendo nos ajudar a encontrar outro dos 3 meliantes usando este id na tabela proprietario_pessoa_fisica com a query " SELECT * FROM proprietario_pessoa_fisica WHERE proprietario_id = '6b3c4089-5f06-45e3-9253-605a4f63e029' " ; obtendo o resultado: 

| id  | proprietario_id                      | pessoa_id                            |
| :-- | :----------------------------------- | :----------------------------------- |
| 958 | 6b3c4089-5f06-45e3-9253-605a4f63e029 | ab8cfb5c-2329-4e53-b9a9-5819a5179c62 |

Com o id da pessoa, posso ir na tabela pessoa descobrir a identidade do proprietário do veículo:
| nome          | primeiro_nome | sobrenome | apelido | profissao           | doc_identificacao                    | sexo | data_nascimento |
| :------------ | :------------ | :-------- | :------ | :------------------ | :----------------------------------- | :--- | :-------------  |
| Gisbert Bento | Gisbert Bento | Peixoto   | Bento   | Analista de sistemas | 96187b1f-cbf3-4104-8cdd-d1c2caaef34a | M    | 1974-09-02     | 

Obs.: Removi a coluna de estar vivo neste recorte acima para que coubesse no texto sem quebrar, também removi o id, já que ele já é conhecido. 

Indo para pessoa_caracteristica, usei o id de Gilberto Bento Peixoto para obter suas informações com a query 
<br>" SELECT id, oculos, bigode, barba, cor_olho, cor_pele, formato_cabelo, altura, peso, raca, tatuagem 
        FROM pessoa_caracteristica WHERE pessoa_id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62' "<br>
Obtendo o resultado abaixo, descobri então que Gilberto é possivlemnte o homem da terra-média que o ajudante  Pomponio Gustavo da Cunha, as características também batem com o que o outro ajudante, Aldo Enno Alves, forneceu.

| id    | oculos | bigode | barba | cor_olho | cor_pele | cor_cabelo | formato_cabelo | altura | peso  | raca        | tatuagem      |
| :---- | :----- | :----- | :---- | :------- | :------- | :--------- | :------------- | :----- | :---- | :---------- | :------------ |
| 17147 | 0      | 1      | Não   | verde    | laranja  | vermelho   | curto          | médio  | magro | terra-média | braço-esquerdo |




