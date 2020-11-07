tax_abund <- function(otu1, otu2 = NULL, rank = NULL, drop.unclassified = FALSE, 
          top = NULL, count = TRUE, mode = "number") 
{
  single.otu <- is.null(otu2)
  valid_OTU(otu1, otu2)
  single.rank <- !is.null(rank)
  filter <- !is.null(top)
  if (!is.logical(drop.unclassified) || length(drop.unclassified) != 
      1L) {
    stop("argument 'drop.unclassified' must be a logical vector of length one.")
  }
  if (!is.logical(count) || length(count) != 1L) {
    stop("argument 'count' must be a logical vector of length one.")
  }
  if (!is.character(mode) || !any(mode %in% c("number", "percent"))) {
    stop("argument 'mode' must be one of 'number' or 'percent'.")
  }
  if (!single.otu) {
    drop <- drop.unclassified
    output <- list()
    output$otu1 <- tax_abund(otu1, rank = rank, drop.unclassified = drop, 
                             top = top, count = count, mode = mode)
    output$otu2 <- tax_abund(otu2, rank = rank, drop.unclassified = drop, 
                             top = top, count = count, mode = mode)
    return(output)
  }
  if (single.rank) {
    valid_rank(rank)
    tax.list <- list(tax_split(otu1, rank = rank))
  }
  else {
    tax.list <- tax_split(otu1)
  }
  for (i in seq(along = tax.list)) {
    names(tax.list[[i]])[dim(tax.list[[i]])[2]] <- "taxonomy"
    tax.list[[i]] = stats::aggregate(tax.list[[i]][, -dim(tax.list[[i]])[2]], 
                                     by = list(tax.list[[i]]$taxonomy), FUN = sumcol)
    rownames(tax.list[[i]]) <- tax.list[[i]][, 1]
    tax.list[[i]] <- tax.list[[i]][, -1]
    tax.list[[i]] <- as.data.frame(t(tax.list[[i]]))
    if (!count) {
      tax.list[[i]] <- vegan::decostand(tax.list[[i]], 
                                        method = "total")
    }
    tax.list[[i]] <- tax.list[[i]][, order(colSums(tax.list[[i]]), 
                                           decreasing = TRUE), drop = FALSE]
    tax.list[[i]] <- tax.list[[i]][, colSums(tax.list[[i]]) > 
                                     0, drop = FALSE]
    if (!single.rank) {
      names(tax.list[[i]])[names(tax.list[[i]]) == "V1"] <- paste("unclassified_below_", 
                                                                  get_rank(i - 1), sep = "")
    }
    else {
      names(tax.list[[i]])[names(tax.list[[i]]) == "V1"] <- paste("unclassified_below_", 
                                                                  get_rank(get_rank_ind(rank) - 1), sep = "")
    }
    if (drop.unclassified) {
      remove.pat <- gsub(get_rank_pat(get_rank(i)), 
                         "", paste0(blacklist(get_rank(i)), "|no_taxonomy"))
      tax.list[[i]] <- tax.list[[i]][, !grepl(remove.pat, 
                                              names(tax.list[[i]]), ignore.case = TRUE), drop = FALSE]
    }
    if (filter) {
      tax.list[[i]] <- .select.top(tax.list[[i]], top, 
                                   count, mode)
    }
  }
  tax.out <- list()
  index <- 1
  for (i in 1:length(tax.list)) {
    tax <- tax.list[[i]]
    if (is.null(tax)) {
      break
    }
    lab <- names(tax.list)[i]
    if (is.null(lab)) {
      lab1 <- index
    }
    else {
      lab1 <- lab
    }
    names(tax) <- gsub(" ", "_", names(tax))
    tax.out[[lab1]] <- tax
    index <- index + 1
  }
  if (single.rank) {
    return(tax.out[[1]])
  }
  else {
    return(tax.out)
  }
}
