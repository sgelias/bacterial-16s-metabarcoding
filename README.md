# Desafio NeoBioinformatics e NeoDataAnalytics

## Breve descrição

Esse repositório contém os resultados do desafio Neoprospecta de Bioinformática e Análise de dados.

## Estrutura

Os arquivos contidos nesse repositório possuem os resultados do desafio Neoprospecta em Bioinformática e Análise de Dados. A estrutura de pastas pode ser observada na árvore de diretórios abaixo. Essa inclui um diretório nomeado `data` que contém os dados brutos fornecidos para a realização desse desafio, assim como os dados processados produzidos após a execução da pipeline contida no diretório `bioinformatic-skills`. Os dados produzidos após a execução da pipeline contida em `bioinformatic-skills` são utilizados durante a posterior análise de dados. A análise de dados é realizada através dos scripts contidos no diretório `data-analytics-skills`.

```bash
.
├── bioinformatic-skills
│   └── scripts
│       └── src
├── data
│   ├── fqs_raw
│   │   └── fastqc
│   ├── fqs_trimmed
│   │   ├── fasta
│   │   ├── fastq
│   │   └── fastqc
│   ├── output_tables
│   │   ├── annotation
│   │   └── out_table
│   └── reference_database
│       └── fasta_file
└── data-analytics-skills
    └── scripts
        ├── main_files
        │   └── figure-html
        └── src
            └── RAM
```

IMPORTANTE: alguns arquivos/diretórios foram omitidos do repositório github por possuírem tamanho elevado. Antes de iniciar as análises baixe o arquivo ZIP contendo os softwares necessários (`bio-softwares.zip`) para a realização desse tutorial assim como os arquivos de entrada e saída da pipeline de processamento das sequencias brutas através desse [link](https://drive.google.com/drive/folders/13av26PoO0RYlh9O9hpZyCTY4npC2TNv1?usp=sharing). Ambos os arquivos devem ser descompactados no mesmo diretório em que os diretórios acima citados estão incluídos.

Ambos os diretórios `bioinformatic-skills` e `data-analytics-skills` contém arquivos README contendo maiores detalhes sobre os passos executados em cada etapa do processo de análise de dados, assim, nessa página não serão fornecidos detalhes sobre os scripts.

IMPORTANTE: os arquivos contidos no diretório `data` são compartilhados entre as duas etapas da análise dos dados de sequenciamento. Portanto, com exceção dos arquivos brutos de entrada, não altere manualmente os arquivos ou sobrescreva-os.

___
Let's code and be happy!!!
