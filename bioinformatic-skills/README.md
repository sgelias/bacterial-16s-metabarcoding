# Bacterial 16S metabarcoding pipeline

## Brief description

This pipeline generate quality reports and perform taxonomic annotation for Bacterial 16S metabarcoding sequencing product.

## Structure

This pipeline executes the seven steps:

1. Generate quality reports from raw reads (Fastqc).
2. Trim raw reads (Trimmomatic).
3. Generate quality reports from trimmed reads (Fastqc).
4. Build a reference database using a Bacterial 16S dataset (ncbi-blast+).
5. Convert FASTQ files as the Trimmomatic output to FASTA format (Sed editor).
6. Attribute taxonomic identities (ncbi-blast+).
7. Generate OTU table (L-tables) from the previous step results.

![Pipeline structure](https://github.com/sgelias/bacterial-16s-metabarcoding/blob/main/bioinformatic-skills/scripts/dag.svg)

## Usage

Using a terminal emulator of your choice type and run:

```bash
snakemake --cores 4
```

**NOTE**: Replace the `4` by the number of cores available in your host machine to execute the pipeline.

Additional parameters can be used if needed. To see more options simple run `snakemake --help`. File and directory paths should obligately exist in config.yaml file. All paths are relative to docker image filesystem, thus before run the `snakemake` command you should activate the docker container typing:

```bash
docker-compose run --rm --workdir="/home/" machine
```

The above command should be run in the same directory of `docker-compose.yml` file (the same directory in which this file resides). The `machine` parameter is the name of the main service specified in the docker-compose file, hence you can change it to a name of your choice.

## About the docker image and docker-compose volumes

This pipeline is based in `snakemake/snakemake`, an extension of the `bitnami/minideb` image, a minimalist Debian-based image built specifically to be used as a base image for containers. Layers included by the former including some basic packages to perform files management and the Miniconda installation. Thus several Linux native and Python based packages were added to provide a better experience during bioinformatic analysis (see `Dockerfile` for details).

Mapped volumes specified in `docker-compose.yml` file including `data` and `bio-softwares` directories that contains raw FASTQ files  as the pipeline input and some additional softwares respectively. To reuse this pipeline simple replace files from `data` directory. The `scripts` directory also mapped in volumes including `Snakefile` and `config.yaml` files. Both contains the basic scripts used to process each step of this pipeline. The three directories are mapped using the `delegated` mode, thus if you prefer to keep intermediary results only at the docker container, simple remove the `delegated` word from specific volumes input in docker-compose file.

Samples identification are hard-coded in `samples` item of the `config.yaml` file. Alternatively you can specify only the container directory in `samples` item and dynamically filter `*.fastq` files to turn the process energetically less expensive and this pipeline more generalist.

## About the pipeline

Details of each step of the current pipeline are described here.

### Step 1 - Generate quality reports from raw reads (Fastqc)

Desctiption...

### Step 2 - Trim raw reads (Trimmomatic)

Desctiption...

### Step 3 - Generate quality reports from trimmed reads (Fastqc).

Description...

### Step 4 - Build a reference database using a Bacterial 16S dataset (ncbi-blast+).

Description...

### Step 5 - Convert FASTQ files as the Trimmomatic output to FASTA format (Sed editor).

Description...

### Step 6 - Attribute taxonomic identities (ncbi-blast+).

Description...

Describe parameters of blastn `outfmt (10 qaccver saccver pident length mismatch gapopen qstart qend sstart send evalue bitscore score)`

* **qaccver** - Query accesion.version
* **saccver** - Subject accession.version
* **pident** - Percentage of identical matches
* **length** - Alignment length
* **mismatch** - Number of mismatches
* **gapopen** - Number of gap openings
* **qstart** - Start of alignment in query
* **qend** - End of alignment in query
* **sstart** - Start of alignment in subject
* **send** - End of alignment in subject
* **evalue** - Expect value
* **bitscore** - Bit score

### Step 7 - Generate OTU table (L-table) from taxonomically annotated sequences.

Description...

### Next steps

Run community analysis ...
