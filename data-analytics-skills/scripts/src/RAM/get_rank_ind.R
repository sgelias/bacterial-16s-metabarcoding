get_rank_ind <- function(rank) 
{
  tax.classes <- c("kingdom", "phylum", "class", "order", 
                   "family", "genus", "species")
  tax.classes.plural <- c("kingdoms", "phyla", "classes", 
                          "orders", "families", "genera", "species")
  tax.classes.short <- c("k", "p", "c", "o", "f", "g", "s")
  tax.classes.pattern <- c("k__", "p__", "c__", "o__", "f__", 
                           "g__", "s__")
  tax.classes.all <- c(tax.classes, tax.classes.plural, tax.classes.short, 
                       tax.classes.pattern)
  val <- unique(which(toupper(rank) == toupper(tax.classes.all))%%length(tax.classes))
  if (val == 0) {
    val <- 7
  }
  return(val)
}
