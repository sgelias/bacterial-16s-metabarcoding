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
    
    1. Descreva todas as etapas que você usaria para realizar a montagem, anotação e verificação de qualidade de um genoma de um isolado bacteriano, tendo como base arquivos FASTQ de um sequenciamento Illumina MiSeq paired-end (arquivo R1 e R2), com 2 milhões de reads cada. Reads do arquivo R1 tem 306 pares de base, e reads do arquivo R2 tem 206 pares de base. Suponha que a amostra está bem isolada, contendo um único organismo. 
    
    2. Descreva como você faria a identificação taxonômica do genoma montado, considerando que a amostra realmente era um isolado bacteriano.
    
    3. Os processo descritos em 3.1 e 3.2 são passíveis de automação? Seria possível montar um script que realize todo o processo, tendo como input apenas os arquivos FASTQ (R1 e R2) do sequenciamento? Discorra sobre a possibilidade disso, e, caso possível, como garantir (ou ao menos medir) a qualidade desta montagem/anotação/identificação. Comente sobre possíveis problemas.
    
    4. Descreva como você faria a identificação taxonômica do genoma montado, considerando que a amostra não foi bem isolada, e pode conter mais de um organismo (considere que como houve uma tentativa de isolar, ela deve conter entre 1 e 5 organismos).

    5. Você identificou a amostra e reconheceu que ela não estava bem isolada. Como você poderia solucionar este genoma? Descreva o que faria para separar os scaffolds em dois arquivos de genoma finais. Como poderia medir a qualidade da montagem final?

Caso não seja possível realizar algum dos subitens, não há problema em resolver uma frente parcialmente (exemplos: realizar os primeiros 4 subitens da competência de bioinformática, sem criar o Docker do script; ou plotar o gráfico de barras e realizar a análise de abundância diferencial usando R, mas não plotar o gráfico de PCoA, na análise de dados). 
