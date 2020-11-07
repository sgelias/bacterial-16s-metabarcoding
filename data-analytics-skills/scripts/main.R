
# **************************************************************************** #
# Install and/or load dependencies
source("./packages.R")


# **************************************************************************** #
# Get arguments from command line
get_options <- function() {
  option_list <- list(
    make_option(
      c("-o", "--otu_table"), 
      type = "character",
      default = FALSE,
      help = "The OTU by sample TSV file path."
    ),
    make_option(
      c("-e", "--exp_design"), 
      type = "character",
      default = FALSE,
      help = "A TSV file path containning the experimental design to be ploted."
    ),
    make_option(
      c("-f", "--main_factor"), 
      type = "character",
      default = FALSE,
      help = "The label of the main factor used to split groups (only one)."
    ),
    make_option(
      c("-t", "--taxonomy"), 
      type = "character",
      default = FALSE,
      help = "A TSV file path containning the OTU taxonomy."
    ),
    make_option(
      c("--cores"), 
      type = "integer",
      default = 1,
      help = "The number of available cores for this work."
    )
  )
  
  parser <- OptionParser(usage = "%prog [options]", option_list = option_list)
  args <- parse_args(parser, positional_arguments = 0)
  return(args$options)
}

opt = get_options()


# **************************************************************************** #
# Create the function to efectivelly render the notebook.
render_notebook <- function(dataset, exp_design, main_factor, taxonomy, cores, is_docker) {
  rmarkdown::render(
    "./main.Rmd", 
    encoding = 'UTF-8', 
    params = list(
      dataset = dataset,
      exp_design = exp_design,
      main_factor = main_factor,
      taxonomy = taxonomy,
      cores = cores,
      is_docker = is_docker
    )
  )
}

render_notebook(
  opt$otu_table, opt$exp_design, opt$main_factor, opt$taxonomy, opt$cores, TRUE)
