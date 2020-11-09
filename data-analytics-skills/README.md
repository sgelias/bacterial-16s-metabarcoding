# Bacterial 16S metabarcoding pipeline - OTU data analysis

## Brief description

Generate descriptive and comparative analysis of OTU-by-sample results.

## Structure

1. Generate descriptive statistics:
	1. List the 50th most abundant bacterial OTU's by sample.
	2. Generate a stacked-barplot of the 50th most abundant bacterial OTU's by sample.
	3. Test the sampling effectiveness of samples using Hill numbers of order 0 (q0).
	4. Explore the samples relationship through a Principal Coordinates Analysis - PCoA.
2. Generate comparative statistics:
	1. Test the statistical support for community structure dissimilarities given the of the provided groups (time).
	2. Identify differentially abundant bacterial OTU's given the of the provided groups (time).

## Usage

Using a terminal emulator of your choice type and run:

```bash
Rscript main.R \
	--otu_table /home/data/output_tables/otu_table_tax_amostras.tsv \
	--exp_design /home/data/metadata.tsv \
	--main_factor 'time' \
	--taxonomy /home/data/output_tables/tax_table_amostras.tsv \
	--cores 4
```

About the parameters:
1. *otu_table*: The OTU (rows) by sample (columns) TSV table.
2. *exp_design*: A TSV table containing metadata of each sample, including a column witch specify the main factor to partitioning data during the pipeline execution.
3. *main_factor*: The name of the main factor used to partitioning data during the pipeline execution.
4. *taxonomy*: A table containing the taxonomic placement of each OTU (rows) included in the OTU table.
5. *cores*: The number of cores available to run the pipeline.

Path's specified in `otu_table`, `exp_design`, and `taxonomy` arguments are obligately relative to docker image filesystem, thus before run the command you should activate the docker container typing:

```bash
docker-compose run --rm --workdir="/home/scripts/" machine
```

**NOTE**: If you've not build the docker image, skip to the `About the docker image and docker-compose volumes` item (next item) to see build instructions.

The above command should be run in the same directory of `docker-compose.yml` file (the same directory in which this file resides). The `machine` parameter is the name of the main service specified in the docker-compose file, hence you can change it to a name of your choice.

## About the docker image and docker-compose volumes

This pipeline is based in `rocker/rstudio` image. It contains a Rstudio server installation. To map the port to access the Rstudio server in a browser of your choice, include a `-p` flat at the docker-compose command: 

```bash
docker-compose run --rm --workdir="/home/scripts/" -p 8787:8787 machine
```

Otherwise, you can include a `ports` constant to the `docker-compose.yml` file and run the docker-compose command without a `-p` flag, allowing a less verbose initialization of the docker container. The `Dockerfile` includes all linux packages needed to install R dependencies included in this project.

R dependencies are specified at the `packages.R` file available at the `data-analytics-skills/scripts` directory. To install such packages simple run `docker-compose build` command at the same directory of the `docker-compose.yml` file. It is sufficient to install all dependencies from `packages.R` file.

Mapped volumes specified in `docker-compose.yml` file including `data` and `scripts`. The first points to the same directory that the OTU table exists, and scripts indicate the directory containing all R scripts (including the main.R file) needed to resolve this pipeline. Both directories are mapped using the `delegated` mode, thus if you prefer to keep intermediary results only at the docker container, simple remove the `delegated` word from specific volumes input in docker-compose file.

## The pipeline output

The main result generate after execute the main.R file include a html file containing all important charts and tabular results corresponding to each pipeline steps described in `Structure` item. Charts are build using a dynamic mode, them, to save each one simple use the toolbar at the top-right corner of the respective image. The same is valid for dynamic tables.
