# Desafio Neoprospecta

## Descrição dos dados de sequenciamento enviado

1. Quais os objetivos do estudo?
    
    1. Estes dados foram gerados com o intuito de compreender a variação da microbiota intestinal natural em resposta ao estado de saúde do hospedeiro;

    2. Foram coletadas **fezes frescas de camundongos** durante **365 dias após a data do desmame**. Foi realizado um sequenciamento de larga escala (MiSeq), usando **primers do gene 16S rRNA para a região V4**;

    3. Durante os primeiros **150 dias após o desmame (dwp)**, nada foi feito com os camundongos, exceto permitir que se alimentassem, engordassem e se divertissem. Nos primeiros **10 dwp**, observou-se um aumento brusco no peso dos camundongos, o que gerou dúvidas se a **microbiota desses 10 dwp era diferente daquela observada entre os dias 140 e 150**;

    4. O arquivo `metadata.csv` oferecido neste desafio, contém a relação entre os arquivos fastq's (que estão no diretório fqs) e a idade de desmame dos camundongos. Os dados são parciais, muitos dos arquivos foram omitidos a fim de facilitar a execução dos desafios.

    5. Junto dos dados a processar é disponibilizado um pequeno banco de **sequências de referência** FASTA (fasta_file.fasta) que contém sequências de bactérias com definição a nível de espécie.

    6. Como dois dos três desafios dependem das análises dos dados descritos nos subitens 1.1 à 1.5, caso o candidato precise, estamos disponibilizamos uma **OTU table** e uma **Tax table** que podem ser usadas nos desafios subsequentes que dependeriam destes arquivos. Os arquivos estão dentro do diretório tables: `otu_table_tax_amostras.tsv` e `tax_table_amostras.tsv`.

## OS DESAFIOS

Os desafios serão divididos em três frentes, a saber: **1)** Competência básica para bioinformática, **2)** Competência básica para análise de dados e **3)** Conhecimentos de bioinformática (questões dissertativas sobre montagem de genoma). Cada uma das competências será avaliada de forma separada, sendo que as mesmas foram pensadas para melhor avaliar o perfil do candidato frente a nossas demandas. 

Não é necessário completar todos os desafios, apenas aqueles que se sentir mais confortável para resolver (motivo pelo qual enviamos os dados 'resolvidos' para caso deseje 'pular' uma etapa).

Preferencialmente, use a linguagem `Python` para a competência de bioinformática e `R` para a competência de análise de dados, visto que são as linguagens que serão utilizadas na Neoprospecta.

**Todos os scripts devem ser disponibilizados junto da resolução do teste, com commit no GitHub**. A avaliação do código será tão ou mais importante quanto os resultados em si.

1. **Competência básica para bioinformática**: o objetivo deste desafio será o de gerar um script (recomendado utilizar a linguagem Python) que contemple os seguintes steps:
    
    1. Efetuar trimagem dos dados, por qualidade, usando algum trimador de sua preferência;
    
    2. Gerar reports da qualidade PHRED antes e após trimagem dos dados;
    
    3. Fazer identificação taxonômicas das sequências que passaram pelo filtro de qualidade usando um banco de referência e um programa de sua escolha;
    
    4. Gerar uma OTU table, onde as linhas serão taxonomias e as colunas os nomes das amostras. A intersecção de colunas e linhas devem mostrar as contagens da taxonomia na amostra em questão (vide arquivo em 'Desafio_Neoprospecta/tables');
    
    5. Realizar todos os steps anteriores de forma automatizada
    
    6. O código deve ser colocado em um container Docker, e depositado em uma conta do GitHub. Construa o requirements.txt e demais instruções para instalação. Descreva as instruções para a execução do pipeline. Recomendamos testar a instalação e execução completa do código do Docker antes de sua submissão final.

2. **Competência básica para análise de dados**: o objetivo deste desafio será o de gerar análises gráficas (descritivas e estatísticas) a partir de dados de sequenciamento (recomendado utilizar a linguagem R). Utilize como base os arquivos gerados na etapa 1.4. Caso não consiga gerar um arquivo no formato esperado, você pode utilizar o arquivo em `Desafio_Neoprospecta/tables`:
    
    - OBS1. Tente automatizar as etapas quando possível, evitando etapas manuais.
    
    - OBS2: Lembre de disponibilizar o código usado para gerar os gráficos e informações/métricas, assim como descrever quaisquer etapas manuais usadas para manipular os dados com comentários no código (ex: '#a tabela de OTUs foi transposta no LibreOfficeCalc antes desta etapa').
    
    1. Plotar um gráfico de barras que mostre a contagem absoluta das 50 bactérias mais abundantes, agrupadas por tempo (dia após o desmame);
    
    2. Plotar um gráfico de PCoA (Principal Coordinates Analysis) mostrando o perfil de agrupamento entre as amostras por dia após o desmame;
    
    3. Usar alguma métrica que mostre as bactérias diferencialmente abundantes entre os dias de desmame (edegR ou DESeq2, por exemplo). Em um arquivo (PDF, HTML, DOC ou similar), descreva os resultados obtidos e explique quais foram os critérios de escolha dos métodos analíticos usados.

3. **Conhecimentos de bioinformática**: questões dissertativas sobre montagem de genoma:
    
    1. Descreva todas as etapas que você usaria para realizar a **montagem**, **anotação** e **verificação de qualidade** de um genoma de um **isolado bacteriano**, tendo como base arquivos FASTQ de um sequenciamento **Illumina MiSeq paired-end** (arquivo R1 e R2), com 2 milhões de reads cada. Reads do arquivo R1 tem 306 pares de base, e reads do arquivo R2 tem 206 pares de base. Suponha que a amostra está **bem isolada**, contendo um único organismo.

    A resposta para essa questão pode ser dividida em duas situações: na primeira a identidade do organismo sequenciado é **conhecida** e na segunda **desconhecida**. Ambas as situações são descritas abaixo.

    O primeiro passo realizado para ambas as montagens (com e sem referência) é naturalmente a realização da limpeza dos dados, formalmente conhecido como *trimagem* das sequências (provavelmente soando melhor no inglês como *sequence trimming*). Nesse processo elimina-se sequências - ou somente partes dessas - que apresentem baixa qualidade, e por consequência possam interferir nos próximos passos da análise. Porções de baixa qualidade existem comumente nas porções iniciais e principalmente terminais das leituras geradas pelo sequenciador, podendo variar de acordo com a amostra, a própria química da reação de sequenciamento (diferentes sequenciadores geram diferentes qualidades). Se essas porções não foram eliminadas nas primeiras etapas do processo, podem gerar erros comuns como a observação de falsos positivo para SNP's e mesmo atrapalhar o posterior processo de alinhamento das sequências, levando à montagem de scaffolds com menores tamanhos.
    
    Vários softwares existem com esse propósito, como exemplo pode-se citar o [`Sickle`](https://github.com/najoshi/sickle) e o [Trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic). Possuo maior experiência com o segundo, e portanto esse será adotado na resolução das questões. Ambos os softwares trabalham com sequenciamento *pair-end*. No Trimmomatic algumas configurações importantes devem ser observadas. Primeiramente o tipo de filtragem deve ser especificado. No caso de sequenciamento *pair-end* deve-se utilizar a flag PE na linha de comando de execução do software, e logo após, a versão dos códigos indicadores da qualidade do sequenciamento das bases, o PHRED. No caso de sequenciamento Illumina Miseq e Hiseq é adotado por padrão o PHRED 33.
    
    Logo após são especificados os arquivos de entrada. Se tratando do sequenciamento *pair-end* ambos os alvos R1 e R2 devem ser passados (nessa ordem) como arquivos de entrada. O Trimmomatic (assim como o Sickle) requerem a especificação de dois arquivos para cada direção (forward e reverse). Os dois primeiros referem-se ao arquivo contendo as sequencias que parearam após as filtragens (por padrão recebe o sufixo *filtered*) e o arquivo contendo as sequências que não parearam (por padrão recebe o sufixo *unpaired*), já o terceiro e quarto arquivos contém as sequências pareadas e não pareadas respectivamente.
    
    Após, deve-se realizar a remoção das bases de menor qualidade localizadas na porção inicial das sequências. Por padrão o sequenciamento via **Illumina MiSeq** possui uma porção de aproximadamente 20 pares com menor qualidade (normalmente com PHRED score não inferior a 20, entretando com score médio inferior às porções posteriores). A remoção dessa região pode ser facilmente realizada utilizando-se a opção **HEADCROP** com valor correspondente ao tamanho da porção inicial a ser removida. Desse modo, um valor comumente utilizado é 20 (não confundir com o PHRED score).

    Após a remoção da porção inicial das sequências, parte-se para a remoção de porções de baixa qualidade ao longo da sequência. Essa etapa pode ser configurada através do parâmetro **SLIDINGWINDOW**. O parâmetro recebe dois valores principais separados por ":" (dois pontos, exemplo 5:20). O primeiro especifica o tamanho da "janela" (window) que será utilizada para o cálculo do score PHRED médio. Esse valor médio é confrontado com o ponto de corte especificado no segundo valor do argumento (o score PHRED mínimo para remoção das bases). Nessa etapa a "janela" percorre a sequência completa, calculando a média das bases contidas na janela, e caso esse valor seja inferior ao ponto de corte, a porção é removida. 
    
    Outro parâmetro importante é o **MINLEN**, que como o próprio nome do argumento indica, é o tamanho mínimo que as sequências devem possuir após a aplicação dos demais filtros. Outro parâmetro importante é o **ILLUMINACLIP**. Através desse é especificado o conjunto de adaptadores que possívelmente podem ser encontrados nas sequências. Para **Illumina Miseq** conjunto **TruSeq3** é o conjunto padrão. Adicionalmente, dependendo to sequenciamento (*single-end* ou *pair-end*) deve-se especificar os sufixos SE e PE para somente sequences forward ou forward + reverse. O próprio software Trimmomatic inclui por padrão os arquivos fasta contendo a sequência dos adaptadores, e nesse caso deve-se especificar somente o caminho do arquivo contendo os adaptadores.
    
    A próxima etapa é gerar os relatórios de qualidade para as sequências que passaram pelo processo de limpeza. Esse relatório pode ser gerado utilizando o software FastQC. Através desse, pode-se gerar relatórios individuais (é indispensável que os relatórios sejam gerados individualmente, permitindo identificar anomalias nos resultados do sequenciamento). Considerando que as sequências originais "não devem ser sobrescritas", o mesmo relatório deve ser gerado para os arquivos antes do processo de trimagem, com o objetivo de comparar os resultados da aplicação dos filtros através do Trimmomatic. Idealmente, caso se observe alguma alteração é interessante refazer o processo de trimagem caso as configurações especificadas para os filtros de qualidade não sejam suficientes.
    
    Se tratando de sequenciamento *pair-end*, a saída dos filtros de qualidade aplicados pelo Trimmomatic incluem arquivos *filtered*, contendo as sequências que mantiveram seus pares, e *unpaired*, contendo as demais sequências. Desse modo, para somente as sequencias que mantiveram seus pares, é realizada a concatenação (join) das fitas forward e reverse. O join pode ser realizado utilizando-se o software PEAR. O mesmo pode ser nativamente instalado em sistemas linux e recebe como principais argumentos os arquivos de entrada (um a um) forward e reverse através das flags `-f` e `-r` e o nome do arquivo de saída através da flag `-o`. Já as fitas que não mantiveram seus pares serão utilizadas diretamente no próximo passo, a montagem dos *contigs*.

    Considerando o cenário em que o organismo de referência é conhecido e possui um genoma sequenciado, nessa etapa será realizado o mapeamento das sequências pair-end (para as sequencias que mantiveram seus pares) e single-end (as demais), contra esse genoma. Essa etapa pode ser realizada utilizando-se o software `hisat2`. Esse software pode ser instalado nativamente em máquinas linux e executado também por linha de comando (assim como os demais softwares aqui citados). O primeiro passo na utilização do software é indexar os genomas de referência. Esse objetivo pode ser executado através do comando `hisat2-build`. Esse recebe como argumento de entrada o caminho para um arquivo de referência (arquivo `fna`), e o caminho para o arquivo indexado de saída que será utilizado na próxima etapa.

    O próximo passo é realizar o mapeamento propriamente dito. Esse pode ser realizado através do comando `hisat2`. Nessa etapa todos os arquivos gerados até agora (pair-end e single-end) podem ser incluídos no mapeamento. Os arquivos pair-end são especificados através das flags `-1` para o arquivo forward e `-2` para reverse. Já os arquivos single-end (sem par) são especificados através da flag `-U`. Alguns argumentos adicionais podem ser incluídos, como o caminho para o arquivo de resumo da análise através da `--summary-file`, o número de threads com a flag `-p`, a flag `--no-discordant` para remover alinhamentos discordantes (caso as fitas forward e reverse não forem compatíveis com a mesma região alinhada), o próprio genoma indexado através da flag `-x`, e por último a flag `-S` indicando o arquivo SAM de saída.Após execução do comando anterior, as estatísticas básicas para avaliação dos resultados gerados podem ser observadas no arquivo especificado pela flag `--summary-file`.
    
    O próximo passo é converter o arquivo gerado pelo hisat2 para o formato BAM e ordená-lo, de forma a tornar a utilização do mesmo mais eficiente nas análises posteriores. Esse pode ser realizado utilizando-se a ferramenta Samtools. O comando pare realizar tal tarefa é composto pela chamada do software via linha de comando, através de `samtools view` e alguns argumentos adicionais. Para facilitar o processo a pode-se realizar a conversão e ordenação de uma só vez, utilizando-se o operador pipe ("|") do shell. de modo que:

    `samtools view -bS hisat_results.sam | samtools sort -o hisat_results.bam`

    Com esse comando ambos os passos (conversão e ordenamento) são executados sequencialmente. O próximo passo é indexar o arquivo BAM. Esse pode ser executado o comando `samtools index` e especificando-se como entrada o arquivo BAM criado anteriormente e saída um arquivo contendo a extensão `.bai`, indicando se tratar de um índice.
    
    Por último, para se ter certeza se todos os passos foram executados corretamente, um relatório de qualidade do mapeamento pode ser gerado através do comando `samtools flagstat`, seguido pelo nome do arquivo de BAM ordenado como entrada e o nome do arquivo de saída. Através desse será gerado um arquivo contendo as estatísticas básicas como número de *contigs* gerados, tamanho total do alinhamento e N50 (espera-se um balanço entre uma baixa contagem de contigs, com tamanhos elevados porém adequados ao tamanho do genoma já conhecido da espécie e um alto valor de N50).

    Agora, partindo-se para a segunda situação, em que a identidade do organismo não é conhecida ou não existem genomas de referência para a espécie estudada, ou ainda não existem organismos próximos sequenciados.

    Nesse caso, os primeiros passos em que foram realizadas a trimagem de fragmentos/porções de baixa qualidade e a geração dos relatórios de qualidade são realizadas normalmente, entretanto configurando-se os softwares para executar para tal situação. A grande mudança é realizada a partir desse ponto. Como não existem genomas de referência, é realizado o assembly contra o próprio banco de dados, fruto do processo de trimagem.
    
    Esse processo conhecido como alinhamento `de-novo` pode ser realizado utilizando o software `SPAdes`. Existem outras alternativas que cumprem o mesmo objetivo, porém por vias diferentes, como os softwares `ABySS` e o `SOAPdenovo`. Nesse exemplo utilizaremos o SPAdes. A execução desse pode ser realizada especificando-se simplesmente o caminho para o arquivo executável Python do próprio SPAdes, assim como especificando-se alguns argumentos adicionais. Os primeiros são os arquivos forward e reverse que passaram pelo processo de filtragem e utilizando-se as flags `--pe1-1` e `--pe1-2`, a flag `--careful` que objetiva minimizar o número de `contigs` de baixa qualidade, e a flag `-o`, que especifica o nome do arquivo de saída.
    
    Após o processo de montagem estar completo, relatórios de qualidade devem ser gerados para conferir se durante o processo foram gerados contigs de qualidade (lembrando, longos contigs e em pequeno número e um alto valor de N50). Tal relatório pode ser gerado através do software `Quast`.
    
    2. Descreva como você faria a identificação taxonômica do genoma montado, considerando que a amostra realmente era um isolado bacteriano.
    
    Considerando que os processos de montagem realizados nas etapas anteriores foram realizados com sucesso (e qualidade), o primeiro passo é realizar a extração de genes amplamente presentes nos clados bacterianos. Como importantes alvos pode-se citar os genes rMLST (`Ribosomal Multilocus Sequence Typing Scheme`[DOI](10.1099/mic.0.055459-0)). Tais genes apresentam uma série de características que os tornam importantes marcadores na taxonomia bacteriana. As características incluem: codificar proteínas e estarem sob seleção estabilizadora por estarem ligados a processos funcionais; estarem presentes ao longo dos cromossomos bacterianos; serem *single copy*; assim como a principal característica, estarem presentes em todos os clados bacterianos.
    
    Os produtos dessa busca podem ser comparados a bancos de referência utilizando ferramentas de busca global como o BLAST ou mesmo utilizados na montagem de alinhamentos e com posterior reconstrução da filogenia dos organismos.

    3. Os processo descritos em 3.1 e 3.2 são passíveis de automação? Seria possível montar um script que realize todo o processo, tendo como input apenas os arquivos FASTQ (R1 e R2) do sequenciamento? Discorra sobre a possibilidade disso, e, caso possível, como garantir (ou ao menos medir) a qualidade desta montagem/anotação/identificação. Comente sobre possíveis problemas.

    Baseado na experiência que tive até o presente momento, advogo que sim, porém com ressalvas à genomas de Eucariotos. Todos os passos descritos (e teóricamente executados nos ítems 3.1 e 3.2) são passíveis à automação, inclusive as reconstruções filogenéticas.
    
    Alguns dos grandes problemas residem nos passos ambíguos do processo, como a mensuração da qualidade das montagens por exemplo. 

    Felizmente considerando que todas as etapas do processos podem ser conectadas diretamente utilizando-se algum gerenciador de workflows, poderiam ser estabelecidos parâmetros mínimos para avaliar se cada etapa do processo foi realizada com um mínimo de qualidade. Como exemplo de gerenciador de workflows pode-se citar o `Snakemake`.
    
    Uma alternativa viável para avaliar o processo em tempo real ao longo das camadas de entradas seria com a implantação de ferramentas de análise de Log. Como exemplo pode-se citar o `Logstash` ou `LogDNA`. Tais logs poderiam ser utilizados para disparar avisos aos administradores dos processos, caso alguma das etapas não ocorresse corretamente ou retornasse resultados indesejados.
    
    4. Descreva como você faria a identificação taxonômica do genoma montado, considerando que a amostra não foi bem isolada, e pode conter mais de um organismo (considere que como houve uma tentativa de isolar, ela deve conter entre 1 e 5 organismos).

    Um processo rápido para se realizar a identificação taxonômica de organismos contaminantes é realizar um *screening* dos possíveis gêneros presentes na amostra. Essa etapa pode ser realizada utilizando-se o software Mash (veja [DOI](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0997-x)). Como banco de referência para realizar o screening, pode-se utilizar os genomas bacterianos de referência disponibilizados pelo NCBI RefSeq. Essa abordagem pode ser utilizada apenas para contaminações inter-genéricas. Após a finalização do screening (e identificação de quais são os contaminantes), deve-se realizar um assembly utilizando como referência os genomas identificados como hipótese de espécie. Essa abordagem possibilitará a comprovação das identidades.

    Para contaminações infra-genéricas uma abordagem alternativa é realizar primeiramente a identificação das sequências contaminantes utilizando a pipeline [ConFindr](10.7717/peerj.6995). Nela, os autores utilizam como base os genes rMLST, e partem do fato primordial de tais genes serem single-copy. Assim a detecção de múltiplos alelos de tais genes indica fortes evidências de contaminação infra-genérica. A partir dos variantes observados, pode-se realizar a comparação de tais variantes com bancos de dados de referência e possívelmente chegar à uma identificação taxonômica.

    5. Você identificou a amostra e reconheceu que ela não estava bem isolada. Como você poderia solucionar este genoma? Descreva o que faria para separar os scaffolds em dois arquivos de genoma finais. Como poderia medir a qualidade da montagem final?

    Uma abordagem parecida à resposta do item **3.4** poderia ser adotada. Caso as espécies identificadas como contaminandas pertencerem à gêneros distintos, as sequências referência das espécies poderão ser utilizadas como referencia para o mapeamento das reads. Nesse caso é interessante fazer o mapeamento utilizando todos os genomas de referência, de modo que todas as sequências que derem match com os devidos genomas de referência, deverão ser salvas em arquivos distintos.
    
    Com a utilização dessa abordagem será inevitável que sequências ambíguas sejam encontradas - sequências que alinharam com mais de um genoma. A partir desse ponto três caminhos podem ser tomados: incluir essas sequências em ambos os arquibos, essa opção é uma alternativa para casos em que as espécies são filogenéticamente próximas e muito provavelmente ambas partilham os mesmo gênes; não incluir em nenhom arquivo; ou mesmo incluir em apenas um dos arquivos.

Caso não seja possível realizar algum dos subitens, não há problema em resolver uma frente parcialmente (exemplos: realizar os primeiros 4 subitens da competência de bioinformática, sem criar o Docker do script; ou plotar o gráfico de barras e realizar a análise de abundância diferencial usando R, mas não plotar o gráfico de PCoA, na análise de dados). 
