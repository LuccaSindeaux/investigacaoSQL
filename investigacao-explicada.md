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
| id    | pessoa_id                                 |
| :---- | :-----------------------------------------|
| 6525  | 41ecc8f8-54b3-40ab-82e8-37a084396177      |
| 12099 | 64b7cfad-8780-4063-9bf4-cf2736660de6      |
| 38239 | 9de5ea7a-ae40-472a-a752-c1568f8f4500      |


<h2>Seguindo os pedidos do investigador responsável(Parte 1):</h2>
<h3>1. Maiores compradores de vinhos nos últimos seis meses.</h3>
 
Apliquei a query abaixo e obtive 271 linhas de resultado:

SELECT
    nome_pessoa,
    pessoa_id,
    COUNT(*) AS numero_de_compras,
    SUM(qtde) AS total_quantidade_comprada <br>
FROM
    investigacao_compra <br>
WHERE
    data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months' <br>
GROUP BY 
    nome_pessoa, pessoa_id <br>
HAVING 
    COUNT(*) > 1 <br>
ORDER BY 
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

SELECT p.* FROM investigacao_pedagio p <br>
	JOIN veiculo v ON p.placa = v.placa
	WHERE v.cor = 'azul escuro' and modelo_id IN (55, 56, 57, 58, 68, 69);

O resultado foi surpreendentemente um único veículo com as seguintes colunas: 
| id  | data_hora           | localizacao | sentido_trajeto    | placa    |
| :-- | :------------------ | :---------- | :----------------- | :------- |
| 422 | 2024-11-17 18:56:28 | Relva_r49   | Santa_Maria->Relva | YOW-5932 |



<h3>5. Listagem das ligações telefônicas</h3>
Com a query " SELECT * FROM investigacao_telefone ", obtive um retorno de 976 linhas, ainda tenho de prosseguir mais na investigação para entender como usar e filtrar estes dados.


<h2>Continuação da investigação (Parte 2):</h2>

Com a placa do veículo suspeito em mãos, fui à tabel "veiculo" e descobri seu id com a query <br>" SELECT * FROM veiculo WHERE placa = 'YOW-5932' "<br>, obtendo o resultado:

| id                                   | modelo_id | cor         | ano  | placa    |
| :----------------------------------- | :-------- | :---------- | :--- | :------- |
| 3992b3c3-cac3-4ee8-832a-8e93c08fe684 | 55        | azul escuro | 1972 | YOW-5932 |

Usando o id do véiculo, fui a proprietario_veiculo, e com a query <br>" SELECT * FROM proprietario_veiculo WHERE veiculo_id = '3992b3c3-cac3-4ee8-832a-8e93c08fe684' "<br>, obtive o id do proprietario com o resultado:

| id    | veiculo_id                           | proprietario_id                      | data_compra |
| :---- | :----------------------------------- | :----------------------------------- | :---------- |
| 15064 | 3992b3c3-cac3-4ee8-832a-8e93c08fe684 | 6b3c4089-5f06-45e3-9253-605a4f63e029 | 2019-08-05  |

Voltando um degrau acima, na tabela proprietario, lancei mão de <br>" SELECT * FROM proprietario WHERE id = '6b3c4089-5f06-45e3-9253-605a4f63e029' "<br> descobri que o proprietario era uma pessoa física. 

| id                                   | tipo_proprietario |
| :----------------------------------- | :---------------- |
| 6b3c4089-5f06-45e3-9253-605a4f63e029 | Pessoa Fisica     |

Fazendo um rápido comparativo com a tabela que obtive usando as informações do caminhoneiro, o id do proprietario do veículo não é igual a nenhum dos 3 resultados urban. Ou seja, é provável que o homem descrito pelo caminhoneiro não é o proprietário do veículo, podendo nos ajudar a encontrar outro dos 3 meliantes usando este id na tabela proprietario_pessoa_fisica com a query <br>" SELECT * FROM proprietario_pessoa_fisica WHERE proprietario_id = '6b3c4089-5f06-45e3-9253-605a4f63e029' " <br>; obtendo o resultado: 

| id  | proprietario_id                      | pessoa_id                            |
| :-- | :----------------------------------- | :----------------------------------- |
| 958 | 6b3c4089-5f06-45e3-9253-605a4f63e029 | ab8cfb5c-2329-4e53-b9a9-5819a5179c62 |

Com o id da pessoa, posso ir na tabela pessoa descobrir a identidade do proprietário do veículo, usando a query " select * from pessoa where id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62' ":
| nome          | primeiro_nome | sobrenome | apelido | profissao           | doc_identificacao                    | sexo | data_nascimento |
| :------------ | :------------ | :-------- | :------ | :------------------ | :----------------------------------- | :--- | :-------------  |
| Gisbert Bento | Gisbert Bento | Peixoto   | Bento   | Analista de sistemas | 96187b1f-cbf3-4104-8cdd-d1c2caaef34a | M    | 1974-09-02     | 

Obs.: Removi a coluna de estar vivo neste recorte acima para que coubesse no texto sem quebrar, também removi o id, já que ele já é conhecido. 

Indo para pessoa_caracteristica, usei o id de Gisbert Bento Peixoto para obter suas informações com a query 
<br>" SELECT id, oculos, bigode, barba, cor_olho, cor_pele, formato_cabelo, altura, peso, raca, tatuagem 
        FROM pessoa_caracteristica WHERE pessoa_id = 'ab8cfb5c-2329-4e53-b9a9-5819a5179c62' "<br>

Obtendo o resultado abaixo, descobri então que Gisbert é possivlemnte o homem da terra-média que o ajudante  Pomponio Gustavo da Cunha relatou, as características também batem com o que o outro ajudante, Aldo Enno Alves, forneceu.

| id    | oculos | bigode | barba | cor_olho | cor_pele | cor_cabelo | formato_cabelo | altura | peso  | raca        | tatuagem      |
| :---- | :----- | :----- | :---- | :------- | :------- | :--------- | :------------- | :----- | :---- | :---------- | :------------ |
| 17147 | 0      | 1      | Não   | verde    | laranja  | vermelho   | curto          | médio  | magro | terra-média | braço-esquerdo |


<h2>Investigando as empresas</h2>
Com um " select * from matriz_empresa " descobri que o codigo_matriz para a empresas que fabricam bebidas é 11; usei este dado para fazer uma busca mais qualificada na tabela empresa.<br> 

select * from empresa where codigo_matriz = 11;

encontrando 37 negócios, dois quais 3 constam como inativos (faliram).

Primeiramente tentei ver se algum dos 3 urban suspeitos ou Gisbert eram proprietário de uma empresa do ramo de bebidas:

Query de Gisbert: 
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

Query dos urban:
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
 Todas trouxeram resultados nulos.

<h2>Voltando ao telefone</h2>
Lembrei que eu ainda não havia investigado corretamemte os telefones no item 5 da parte 1, mas agora eu possuo o id de Gisbert e mais trÊs suspeitos urban, fiz a query:

SELECT pf.pessoa_id, pt.telefone_id
FROM proprietario_pessoa_fisica pf
JOIN proprietario_telefone pt ON pf.proprietario_id = pt.proprietario_id
WHERE pf.pessoa_id IN (
    'ab8cfb5c-2329-4e53-b9a9-5819a5179c62',
    '41ecc8f8-54b3-40ab-82e8-37a084396177', 
    '64b7cfad-8780-4063-9bf4-cf2736660de6', 
    '9de5ea7a-ae40-472a-a752-c1568f8f4500'  
);

Obtendo o resultado 
| pessoa_id                            | telefone_id |
| :----------------------------------- | :---------- |
| 9de5ea7a-ae40-472a-a752-c1568f8f4500 | 886         |
| ab8cfb5c-2329-4e53-b9a9-5819a5179c62 | 11610       |
| ab8cfb5c-2329-4e53-b9a9-5819a5179c62 | 14283       |

Agora eu sei que 3 dos meus 4 suspeitos possuem telefones, voltando ao item 5 da parte 1, posso usar isto para filtrar quem está na tabela investigacao_telefone... E então o resultado da query abaixo, deu nulo 

SELECT *
FROM investigacao_telefone
WHERE
    origem_telefone_id IN (886, 11610, 14283)
    OR destino_telefone_id IN (886, 11610, 14283)
ORDER BY
    data_hora DESC;

select * from investigacao_pessoa_transporte

<h2>Suspeitas internas</h2>
Nesta parte travei por algum tempo, reli todo o documento no GitLab com mais atenção, percebi um detalhe: o caminhoneiro trabalha há 4 décadas nps negócios e foi o que mais descreveu um dos suspeitos; enquanto que os dois ajudantes estão a menos de um ano e deram informações vagas sobre os suspeitos, pensei que um deles poderia estar envolvido com os 3 criminosos. <br>
Indo para a tabela investigacao_pessoa_transporte, peguei os ids das vítimas que não era o dono com a query <br> 
SELECT pessoa_id, papel FROM investigacao_pessoa_transporte; <br> 
Obtendo o resultado: <br>
| pessoa_id                            | papel              |
| :----------------------------------- | :----------------- |
| d0c5e337-3816-49c8-8f04-ead661176e6a | Vítima - Motorista |
| 7c681882-9217-4ffd-946b-b1bff920e7e8 | Vítima - Ajudante  |
| 2930cef3-3adb-4bf4-a04d-3256519902e9 | Vítima - Assistente|

Obs.: há mais elementos na tabela, porém coloquei aqui apenas o que eu buscava, os dis das vítimas que não eram o dono do negócio. <br>

Usei seus ids para obter os ids de seus telefones:<br>
SELECT pf.pessoa_id, pt.telefone_id
FROM proprietario_pessoa_fisica pf
JOIN proprietario_telefone pt ON pf.proprietario_id = pt.proprietario_id
WHERE pf.pessoa_id IN (
    'd0c5e337-3816-49c8-8f04-ead661176e6a',
    '7c681882-9217-4ffd-946b-b1bff920e7e8',
    '2930cef3-3adb-4bf4-a04d-3256519902e9'
); <br>

Obtendo o resultado:

| pessoa_id                            | telefone_id |
| :----------------------------------- | :---------- |
| 2930cef3-3adb-4bf4-a04d-3256519902e9 | 40756       |
| d0c5e337-3816-49c8-8f04-ead661176e6a | 334         |
| d0c5e337-3816-49c8-8f04-ead661176e6a | 10062       |
| 7c681882-9217-4ffd-946b-b1bff920e7e8 | 17627       |

Com os ids do telefone em mãos, coloquei eles na tabela de investigacao_telefone: <br>
SELECT *
FROM investigacao_telefone
WHERE
    origem_telefone_id IN (40756, 334, 10062, 17627)
    OR destino_telefone_id IN (40756, 334, 10062, 17627)
ORDER BY
    data_hora DESC;

Foram retornadas 19 linhas contendo 16 números que entrara em contato com alguma das vítimas. Relendo o documento do gitLab mais uma vez e comparando com a tabela, percebi mais um detalhe que não estava sendo levado em consideração: a hora do crime. O crime foi cometido as 9:50, se algum dos 3 ajudou no crime, ele teria de dar alguma espécie de sinal ou confirmação de que "tudo estava certo" para prosseguir com o roubo. Pomponio, cujo id de telefone é 17627, foi o único que recebeu uma ligação antes do crime, as 7:09. O número que o ligou possui o id 21161. Com isto em mente, montei uma query maior com os 16 ids.

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
        9204,   
        5710,
        41080,
        32376,
        7096,
        30644
    );

O resultado foram as 11 linhas abaixo:

| nome                | sobrenome       | pessoa_id                            | telefone_id |
| :------------------ | :-------------- | :----------------------------------- | :---------- |
| Laura               | Gramsci Chindamo| 0883585e-81f5-49da-be40-04b6520de702 | 5710        |
| Otto Gaspare        | Musatti         | 5f3b7b4f-5d25-49cd-947b-584574db7219 | 7096        |
| Mirco Vincentio     | Souza           | 6ce657d6-ecb8-42b4-9361-127671097b2a | 9204        |
| Maria Sophia Lucia  | Bajamonti Moura | aba729bd-7ded-4f46-bbf5-bb1551438a19 | 12494       |
| Isadora Sophia      | Bohnbach        | c7aa9b3d-9769-4881-8067-efcc2dd09c3e | 18647       |
| Dom Mirko           | Fernandes       | 1e18fb6d-82a9-4f6e-9ce3-9cb4571a2c77 | 19351       |
| Heinz-Walter Juan   | Campos          | 066ba2eb-d189-4536-9e6a-69d3702a7622 | 21161       |
| Traute Clara        | Löchel          | 3c7ccbbc-a628-46a6-a00f-40f6e702e37c | 21919       |
| Edeltraut           | Letta Farias    | 13bc9824-92b7-45fd-97d7-22f6c6eb86e6 | 25730       |
| Detlev              | Leão            | 7ebad347-4bce-4015-a609-7721560f9e31 | 37072       |
| Evangelia Fernanda  | Beier Cichorius | f149e368-7c64-4001-a0f3-93b06fe72caa | 41080       |

Irei focar no dono do telefone de id 21161, que é Heinz-Walter Juan. Usando um<br>
 " SELECT * FROM pessoa_caracteristica where pessoa_id = ' 066ba2eb-d189-4536-9e6a-69d3702a7622' "

 Para descobrir se suas características batem com as descritas pelo caminhoneiro. E o resultado foi que: Heinz-Walter Juan é um urban alto e atlético, sem tatuagem, de cabelo longo e vermelho, com barba e bigode, seus olhos tem cor branco. Os atributos físicos de Juan batem perfeitamenmte com a descrição fornecida pelo caminhoneiro Ermes. 

 <h2>Afunilando</h2>
 Com as buscas de transporte e veiculo, foi descoberto qual era a caminhonete e seu dono: Gisbert Bento Peixoto. Também consegui descobrir que Heinz-Walter Juan mantinha contato com o novo funcionário Pomponio, e le bate perfeitamemte com a descrição de Ermes o caminhoneiro. Sei potencialmente o nome de 2 dos 3 meliantes, penso que se bem interrogados, ou com acordos aequados, eles entregariam o terceiro. Porém, preciso agora descobrir quem é o cérebro por trás de todo o roubo.<br>

 Suspeito então que estes dois e mais um, informados e auxiliados por Pomponio, roubaram os 300.000 de vinho, mas quem vai receber esta carga? Bem, os meliantes não fariam de graça um serviço tão perigoso, aquele por trás disto deve ser um grande comprador de vinho. Relendo o documento do gitLab mais uma vez lembrei do item 1 da parte 1: listar os maiores compradores de vinhos dos últimos seis meses. É provável que que pudesse gastar uma quantia enorme de dinheiro em vinho até seis meses atrás, ainda pode ter este poder de compra no dia do assalto. Assim como Heinz estava em contato com Pomponio, provavelmente o mandante tambéme stá em contato com Hein ou Gisbert.<br>

 Pegando a query do item 1 com os 271 compradores, posso buscar seus telefones com a query: <br>

SELECT DISTINCT pt.telefone_id
FROM proprietario_telefone pt
JOIN proprietario_pessoa_fisica pf ON pt.proprietario_id = pf.proprietario_id
WHERE pf.pessoa_id IN (
    SELECT pessoa_id
    FROM investigacao_compra
    WHERE data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months'
    GROUP BY pessoa_id
    HAVING COUNT(*) > 1
);

Houveram 128 retornos, esta query anterior virará uma subquery que filtrará os 128 e cruzará com a tabela investigacao_telefone, para poder encontrar se um destes 128 recebeu ligação ou ligou para um de nossos suspeitos. A query com as subquerys é:<br>

SELECT *
FROM investigacao_telefone
WHERE
    -- Meliantes ligando para compradores
    origem_telefone_id IN (21161, 11610, 14283)
    AND destino_telefone_id IN (
        SELECT DISTINCT pt.telefone_id
        FROM proprietario_telefone pt
        JOIN proprietario_pessoa_fisica pf ON pt.proprietario_id = pf.proprietario_id
        WHERE pf.pessoa_id IN (
            SELECT pessoa_id
            FROM investigacao_compra
            WHERE data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months'
            GROUP BY pessoa_id
            HAVING COUNT(*) > 1
        )
    )
OR
    -- Compradores ligando para meliantes
    destino_telefone_id IN (21161, 11610, 14283)
    AND origem_telefone_id IN (
        SELECT DISTINCT pt.telefone_id
        FROM proprietario_telefone pt
        JOIN proprietario_pessoa_fisica pf ON pt.proprietario_id = pf.proprietario_id
        WHERE pf.pessoa_id IN (
            SELECT pessoa_id
            FROM investigacao_compra
            WHERE data_compra >= (SELECT MAX(data_compra) FROM investigacao_compra) - INTERVAL '6 months'
            GROUP BY pessoa_id
            HAVING COUNT(*) > 1
        )
    );

Mas, o resultado deu NULO.

<h2>Rota alternativa</h2>
A oinvestigação parecia ter dado em nada mais uma vez, mas pensei um pouco, e se Heinz ou Gisbert fossem na verdade os compradores/recpetadores da mercadoria E partícepes do assalto? Faria sentido ao meu ver que, um revendedor de vinho, soubesse reconhecer o valor da mercadoria roubada e não roubasse "qualquer vinho", talvez o mandante tenha sentido necesisdade dele mesmo participar do crime para ter certeza que os itens certos fossem roubados. e com esta minha nova rota investigativa, fui buscar se um deles era dono de uma empresa do mesmo ramo que a de Gianpaolo Peano Beyer. Usando a query:<br>

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

Obtive dois resultados: 

| nome_suspeito     | sobrenome_suspeito | razao_social | ramo_atuacao | faturamento_anual | situacao |
| :---------------- | :----------------- | :----------- | :----------- | :---------------- | :------- |
| Heinz-Walter Juan | Campos             | (null)       | Agricultura  | 1063233.096...    | Ativa    |
| Heinz-Walter Juan | Campos             | Garrison     | Comércio     | 531144            | Ativa    |

Heinz possui duas empresas, uma delas inclsuive com um faturamento muito maior que a outra. Coincidentemente, a empresa de comércio é a que fatura menos, e talvez fosse uma fachada perfeita para lavagem de dinheiro.<br>

O terceiro meliante, o urban não identificado, pode ser duas pessoas segundo a investigação até agora: Vladimir Dionigi Montenegro, Giole Montenegro ou Leonardo Ferenc. Ambos estão desempregados e poderiam se aproveitar de um golpe destes. Verifiquei se eles tiveram contato direto com Heinz: <br>

SELECT pf.pessoa_id, pt.telefone_id
FROM proprietario_pessoa_fisica pf
JOIN proprietario_telefone pt ON pf.proprietario_id = pt.proprietario_id
WHERE pf.pessoa_id IN (
    '41ecc8f8-54b3-40ab-82e8-37a084396177', -- Vladimir
    '64b7cfad-8780-4063-9bf4-cf2736660de6',  -- Giole
    '87df4c53-f705-4c08-82fa-6ef1a97fa277' -- Leonardo Ferenc
);

Mas... o resultado foi nulo mais uma vez. A única opção que resta era pensar que eles poderiam ter contato direto com Heinz ao invés de uso de telefone. Mas não possuindo mais rotas que consegui pensar para a investigação, tive de encerrar aqui a investigação.

<h2>Conclusão</h2>

Há fortes inídicios de que Pomponio  Gustavo era um informante interno; o empresário Heinz-Walter Juan Campos bate perfeitamente com as descições descritas pelo caminhoneiro Ermes, e também possui uma empresa de comércio do ramo varejista que pode ser usada para lavagem de dinheiro. Gisbert Bento é o dono do carro que foi usado no assalto. Por fim, o último meliante pode ter sido um dos três urban suspeitos: Vladimir e Giole Montenegro, ou Leonardo Ferenc.