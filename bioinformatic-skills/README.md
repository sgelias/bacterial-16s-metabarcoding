# Bacterial 16S metabarcoding pipeline - Raw sequences processing

## Brief description

This pipeline generate quality reports, perform taxonomic annotation and generate the OTU-by-sample file from Bacterial 16S metabarcoding sequencing product.

## Structure

This pipeline executes the seven steps:

1. Generate quality reports (in HTML format) from raw reads (FastQC).
2. Trim ends of raw sequence files given a set of filters (Trimmomatic).
3. Generate quality reports (in HTML format) from trimmed reads (FastQC) generated at the step 2.
4. Build a reference database using a pre-build Bacterial 16S dataset (makeblastdb from ncbi-blast+).
5. Convert FASTQ files from Trimmomatic output to FASTA format (Sed editor).
6. Attribute taxonomic identities (blastn from ncbi-blast+).
7. Generate OTU table (L-tables) as input the results of the BLASTn (in house python script).

![Pipeline structure](https://github.com/sgelias/bacterial-16s-metabarcoding/blob/main/bioinformatic-skills/scripts/dag.svg)

The above image contains all steps performed on execution of this pipeline. Details of each pipeline step are included at the header of each snakefile `rule`, including a brief description of the step, the software and version that execute each step, and important parameters to be changed if needed.

## Usage

Using a terminal emulator of your choice type and run:

```bash
snakemake --cores 4
```

**NOTE**: Replace the `4` by the number of cores available in your host machine to execute the pipeline. If some step of the pipeline was also concluded before running the `snakemake` such steps will be ignored. To force revisiting all steps include the -F flag in the command:

```bash
snakemake --cores 4 -F
```

Additional parameters can be used if needed. To see more options simple run `snakemake --help`. File and directory paths should obligately exist in config.yaml file. All paths are relative to docker image filesystem, thus before run the `snakemake` command you should activate the docker container typing:

```bash
docker-compose run --rm --workdir="/home/scripts/" machine
```

The above command should be run in the same directory of `docker-compose.yml` file (the same directory in which this file resides). The `machine` parameter is the name of the main service specified in the docker-compose file, hence you can change it to a name of your choice.

## About the docker image and docker-compose volumes

This pipeline is based in `snakemake/snakemake`, an extension of the `bitnami/minideb` image, a minimalist Debian-based image built specifically to be used as a base image for containers. Layers included by the former including some basic packages to perform files management and the Miniconda installation. Thus several Linux native and Python based packages were added to provide a better experience during bioinformatic analysis (see `Dockerfile` for details).

Mapped volumes specified in `docker-compose.yml` file including `data` and `bio-softwares` directories that contains raw FASTQ files  as the pipeline input and some additional softwares respectively. To reuse this pipeline simple replace files from `data` directory. The `scripts` directory also mapped in volumes including `Snakefile` and `config.yaml` files. Both contains the basic scripts used to process each step of this pipeline. The three directories are mapped using the `delegated` mode, thus if you prefer to keep intermediary results only at the docker container, simple remove the `delegated` word from specific volumes input in docker-compose file.

Samples identification are hard-coded in `samples` item of the `config.yaml` file. Alternatively you can specify only the container directory in `samples` item and dynamically filter `*.fastq` files to turn the process energetically less expensive and this pipeline more generalist.

## The pipeline output

The structure of the pipeline output are shown:

```bash
.
├── fqs_raw
│   └── fastqc
├── fqs_trimmed
│   ├── fasta
│   ├── fastq
│   └── fastqc
├── reference_database
│   └── fasta_file
└── output_tables
    ├── annotation
    └── out_table

```

The `fqs_raw` directory contain all original FASTQ files. After run the first step of the pipeline a dub-directory named `fastqc` is created and outputs of the FastQC are placed here. Each input file has a HTML and a ZIP associated file. Both receives as prefix input filename and include a *_fastqc* suffix with the respective .html and .zip extensions. The HTML should be viewed using the browser of your choice, and the ZIP file include all sources of the HTML file (do not change the content, it can lead to disruption of the HTML file).

The `fqs_trimmed` directory is created after Trimmomatic was finished. It include the `fastq` and `fastqc` sub-directories to store trimmed FASTq files and FastQC quality reports, respectively. The `fastqc` after the third step running (see **Structure** topic). The `fasta` directory contain FASTA files, created after the 5th step running to convert the trimmed FASTq files to simple FASTA format.

The `reference_database` contain a FASTA file used to build the reference database used as *Subject* for BLASTn. After running the 4th step (build the reference database using `makeblastdb`) a subdirectory containing the same name of the reference FASTA file is created, and contain the binary reference files (`.nhr`, `.nin`, and `.nsq` formats).

Finally, the `output_tables` contain the `annotation` directory that stores the tabular (TSV) results of the BLASTn analysis, and the `out_table` directory, containing the OTU-by-sample table (TSV), used as input in further community analysis.
