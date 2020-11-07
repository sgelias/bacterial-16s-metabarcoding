get_rank_pat <- function(rank) 
{
  tax.classes.pattern <- c("k__", "p__", "c__", "o__", "f__", 
                           "g__", "s__")
  return(tax.classes.pattern[get_rank_ind(rank)])
}
