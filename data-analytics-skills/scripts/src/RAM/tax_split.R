tax_split <- function(otu1, otu2 = NULL, rank = NULL) 
{
  valid_OTU(otu1, otu2)
  single.otu <- is.null(otu2)
  single.rank <- !is.null(rank)
  tax.classes <- c("kingdom", "phylum", "class", "order", 
                   "family", "genus", "species")
  if (!single.otu) {
    output <- list()
    output$otu1 <- tax_split(otu1 = otu1, rank = rank)
    output$otu2 <- tax_split(otu1 = otu2, rank = rank)
    return(output)
  }
  if (single.rank) {
    valid_rank(rank)
    tax.ind <- get_rank_ind(rank)
  }
  suppressWarnings(otu1.split <- col_splitup(otu1, col = "taxonomy", 
                                             sep = "; ", max = length(tax.classes), names = tax.classes, 
                                             drop = TRUE))
  max <- dim(otu1)[2] - 1
  otu1.split[, -(1:max)] <- gsub("k__|p__|c__|o__|f__|g__|s__|;", 
                                 "", as.matrix(otu1.split[, -(1:max)]))
  if (single.rank) {
    return(otu1.split[, names(otu1.split) %in% c(names(otu1)[1:max], 
                                                 tax.classes[tax.ind])])
  }
  else {
    otu1.taxa <- vector("list", length(tax.classes))
    names(otu1.taxa) <- tax.classes
    for (i in 1:length(tax.classes)) {
      otu1.taxa[i] <- list(otu1.split[, names(otu1.split) %in% 
                                        c(names(otu1)[1:max], tax.classes[i])])
    }
    return(otu1.taxa)
  }
}
