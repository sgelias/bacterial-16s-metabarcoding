valid_rank <- function (rank) 
{
  if (!is.character(rank) || !identical(length(rank), 1L)) {
    stop("rank must be a character vector of length 1; see ?RAM.rank.formatting for help.")
  }
  tax.classes <- c("kingdom", "phylum", "class", "order", 
                   "family", "genus", "species")
  tax.classes.short <- c("k", "p", "c", "o", "f", "g", "s")
  tax.classes.pattern <- c("k__", "p__", "c__", "o__", "f__", 
                           "g__", "s__")
  tax.classes.all <- c(tax.classes, tax.classes.short, tax.classes.pattern)
  if (!(rank %in% tax.classes.all)) {
    stop("invalid format for rank. See ?RAM.rank.formatting for help.")
  }
  invisible()
}
