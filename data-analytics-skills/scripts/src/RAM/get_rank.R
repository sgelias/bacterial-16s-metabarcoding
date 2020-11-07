get_rank <- function(ind, pretty = FALSE) 
{
  tax.classes <- c("kingdom", "phylum", "class", "order", 
                   "family", "genus", "species")
  if (pretty) {
    pretty.rank <- tax.classes[ind]
    pretty.rank <- .capitalize(pretty.rank)
    pretty.rank
  }
  else {
    tax.classes[ind]
  }
}
