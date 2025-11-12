# Tarefa final

Para a tarefa final será necessário um trabalho investigativo, buscando diversas informações sobre os suspeitos de roubarem uma carga 🚚 de vinho🍷. O cenário deste fato ocorre em uma país-estado chamado Montérgio que é dividido em 3 cidades, onde aproximadamente 45 mil pessoas residem. Considere que este local possui uma grande organização de dados, apesar de não contar com tanta tecnologia (ainda). 

<aside>
🎲

> *Reforçando que todos os dados gerados aqui são fictícios, gerados de forma randômica com o objetivo de divertir a etapa de aprendizado sobre banco de dados e análise de dados.*
> 
</aside>

Uma carga avaliada em mais de R$ 300 mil foi interceptada e roubada. Foram 900 garrafas dos mais variados tipos de vinhos. A partir de algumas pistas e orientação do investigador você deve buscar uma lista final de suspeitos, a partir dos dados disponíveis na base e novas requisições.

### Registro da ocorrência

O crime ocorreu no dia `18/11/2024 , as 9:50 am`, na cidade Vale da Erva, bairro Relva, Rua 48, próximo do cruzamento com a Rua 49. Uma caminhonete ou caminhão de pequeno porte de cor azul escuro, da marca Ford, que estava no mesmo sentido, pouco a frente, fechou a rodovia, impedindo a passagem do caminhão com a carga. Imediatamente 2 homens armados saíram do veículo fazendo gesto para o motorista parar e descerem todos do veículo. Foi identificado que eram 3 elementos suspeitos.

## Provas coletadas

Elementos importantes coletados.

Referente ao que foi roubado foi obtido uma cópia dos itens:

[Dados dos Produtos Transportados](./nota/nota-produtos-roubo.txt)

Mapa do ocorrido:

A partir do depoimento das vítimas foi projetado um mapa da região. O local exato do roubo é definido pelo símbolo ☠. Foi visto que a caminhonete `ingressou na Rua 49, do bairro Relva`, esta rua fica próximo do bairro Santa Maria, e na ponte sobre o Rio Relva existe um `posto de controle (pedágio)`, identificado pelo símbolo: 💂. Neste ponto de controle (pedágio) é feito o registro de todos os veículos que passam por ali antes de ingressarem efetivamente em outro bairro (Santa Maria). Com isso é possível verificar a placa do veículo, caso tenha passado por este local, no sentido Relva para Santa Maria.

![mapa_ocorrencia.png](./img/mapa_ocorrencia.png)

A região do roubo é uma área rural, com alguns sítios e fazendas. 

## Depoimento

Foram coletados depoimento das vítimas.

Conforme análise da nota fiscal, os itens tinham valores bem distintos.

**Perguntas ao dono da empresa (loja)**

Perguntas feita ao seu Gianpaolo Peano Beyer, dono da loja de vinhos que teve a carga roubada.

| # | Pergunta | Resposta |
| --- | --- | --- |
| 1 | A compra seria para repor estoque ou seria para atender encomendas? | Seria para repor estoque e também atender possíveis novos pedidos, existe uma maior procura por vinhos mais caros. |
| 2 | As entregas são realizadas em dias fixos da semana ou mês? | Não, depende de quando a carga chega no porto, temos uma estimativa e nos avisam 1 dia antes confirmando que chegou. |
| 3 | O grupo de profissionais é sempre o mesmo ? | Sim. |
| 4 | Quanto tempo faz que todos os envolvidos estão trabalhando nos seus postos? | O Ermes trabalha há anos, já o Aldo e o Pomponio trabalham faz cerca de 8 meses. |
| 5 | Algum tipo de problema ou insatisfação deles? | Não tenho conhecimento de nada. |
| 6 | A carga possui seguro? | Sim, porém demoro 3 meses para receber e existe uma taxa a ser paga. Não compensa pois precisarei fazer um novo pedido. |

**Perguntas ao motorista do caminhão**

Perguntas feita ao motorista, Ermes Marques:

| # | Pergunta | Resposta |
| --- | --- | --- |
| 1 | Há quanto tempo você é motorista de cargas? | Faz mais de 40 anos. |
| 2 | Desde quando você trabalha neste trajeto? | Acredito que uns 8 anos. |
| 3 | Quando foi feito o carregamento do caminhão? | Hoje pela manhã mesmo, como sempre é feito. |
| 4 | Em relação a todos os procedimentos, ocorreu algo diferente? | Não notei nada de diferente, tudo normal. |
| 5 | A carga saiu no mesmo horário de sempre? | Não tem um horário fixo, depende de outros caminhões que estão carregando também. |
| 6 | Lembra de ver alguém diferente no momento que foi carregada a carga? | Não vi ninguém novo ou diferente lá. |
| 7 | Já foi assaltado antes?  | Não, esta foi a primeira vez. |
| 8 | Algum comentário que possa auxiliar na busca? | Claro. Eu consegui ver 2 meliantes, um deles, que portava uma arma grande tinha um sotaque urban. Cabelo vermelho, cabelos longos, barba e bigode, estava de óculos escuro e era alto e rápido. Pode ter certeza que foi o pessoal do morro alto, aquele pessoal (os “urban”) não são de confiança. Teve uma vez que eu estava em um bar e urban começou uma briga sem razão do nada … (interrompido pelo investigador). |

**Perguntas ao ajudante do motorista**

Perguntas feito para o ajudante, Pomponio Gustavo da Cunha.

| # | Pergunta | Resposta |
| --- | --- | --- |
| 1 | Há quanto tempo você é trabalha com cargas? | Faz cerca de 8 meses |
| 2 | Desde quando você trabalha neste trajeto? | Desde que iniciei na empresa. |
| 3 | Quando foi feito o carregamento do caminhão? | Hoje pela manhã mesmo, como sempre é feito. |
| 4 | Em relação a todos os procedimentos, ocorreu algo diferente? | Não notei nada de diferente, tudo normal. |
| 5 | A carga saiu no mesmo horário de sempre? | Não tem um horário fixo, depende de outros caminhões que estão carregando também. |
| 6 | Lembra de ver alguém diferente no momento que foi carregada a carga? | Não vi ninguém novo ou diferente lá. |
| 7 | Já foi assaltado antes? | Não, esta foi a primeira vez. |
| 8 | Algum comentário que possa auxiliar na busca? | Não consegui ver nada, fiquei muito nervoso. Talvez fossem pessoas da terra-média. Pode ser que fosse uma pessoa com máscara. |

**Perguntas ao assistente que acompanhava o transporte**

Perguntas feito para o ajudante, Aldo Enno Alves.

| # | Pergunta | Resposta |
| --- | --- | --- |
| 1 | Há quanto tempo você é trabalha com cargas? | Faz cerca de 6 meses |
| 2 | Desde quando você trabalha neste trajeto? | Não tem o hábito de vir muito, apenas quando a carga é maior então acabo pegando carona porque minha casa fica no trajeto. |
| 3 | Quando foi feito o carregamento do caminhão? | Assim que chegamos. |
| 4 | Em relação a todos os procedimentos, ocorreu algo diferente? | Não notei. |
| 5 | A carga saiu no mesmo horário de sempre? | Não tem um horário fixo, depende de outros caminhões que estão carregando também. |
| 6 | Lembra de ver alguém diferente no momento que foi carregada a carga? | Não vi ninguém novo ou diferente lá. |
| 7 | Já foi assaltado antes? | Não, esta foi a primeira vez. |
| 8 | Algum comentário que possa auxiliar na busca? | Eu fiquei bem nervoso, como fui o primeiro a descer do caminhão ele logo mandou eu ficar costa, não consegui ver muito além de que era um cabelo longo, de barba, cabelo vermelho e pele laranja. |
| 9 | Identificou algum sotaque? | Não notei sotaque, acredito que não tinha. Foi muito rápido. |

## Dados requisitados

Alguns dados foram solicitados pelo investigador responsável.

### Parte 1

1. Apresentar maiores compradores de vinhos, considere todos que realizaram mais de 1 compra nos últimos 6 meses. `investigacao_compra`
2. Lista de pessoas envolvidas na entrega (todo fluxo, carregamento, transporte e recebimento) `investigacao_pessoa_transporte`
3. Listagem de veículos com características suspeitas `veiculo`
4. Listagem de pedágio dos veículos com características do suspeito `investigacao_pedagio`
5. Listagem de ligações telefônicas de algumas pessoas investigadas `investigacao_ligacao_telefone`.

<aside>
🔍

*conforme a orientação do investigador, é preciso , primeiramente, reconstruir todos os passos do crime - montar a história, seguindo rigorosamente a ordem dos fatos. Num segundo passo é preciso responder algumas questões sobre a motivação, se foi por interesse financeiro, vingança … Quando se trata de roubo de bens valiosos e de consumo, é preciso compreender se a carga foi roubada para ser revendida ou para interesse próprio. Com isso entender quem seria o(s) possível(is) receptador(es) desses produtos faz parte do processo investigativo.*

</aside>

É esperado que seja apresentado uma lista de pessoas suspeitas (pode ser 1 ou 20).

Para cada suspeito deve ter uma justificativa textual.

A lista de possibilidades (justificativa/motivo) pode ter os seguintes valores:
- perfil pessoa
- historico telefone
- veiculo
- sócio empresa suspeita
- colaborador empresa suspeita
- outro.


### 📋 Entrega da Tarefa

Resposta esperada na tarefa (2 arquivos): 
* `lista-suspeitos.csv`: Lista de suspeitos e motivo, apenas 2 atributos: pessoa_id, motivo;
* `investigacao-explicada.md`: Os passos utilizados para a investigação, descrevendo a linha de raciocínio, com código utilizado para buscar os dados.

