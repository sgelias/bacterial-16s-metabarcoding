
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
    )
  )
  
  parser <- OptionParser(usage = "%prog [options]", option_list = option_list)
  args <- parse_args(parser, positional_arguments = 0)
  return(args$options)
}

opt = get_options()


# **************************************************************************** #
# Create the function to efectivelly render the notebook.
render_notebook <- function(dataset, exp_design) {
  rmarkdown::render(
    "./main.Rmd", 
    encoding = 'UTF-8', 
    params = list(
      dataset = dataset,
      exp_design = exp_design
    )
  )
}

render_notebook(opt$otu_table, opt$exp_design)
