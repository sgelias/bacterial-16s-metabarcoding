valid_OTU <- function(otu1, otu2 = NULL) 
{
  given.both <- !is.null(otu2)
  if (!is.data.frame(otu1)) {
    stop("the given object for otu1 is not a data frame.")
  }
  tax <- dim(otu1)[2]
  if (names(otu1)[tax] != "taxonomy") {
    stop("no 'taxonomy' column detected in otu1. Please ensure the last column of the table is titled 'taxonomy' (capitalization matters) and try again.")
  }
  if (!all(apply(otu1[, -tax, drop = FALSE], is.numeric, MARGIN = 1))) {
    stop("OTU data other than taxonomic information is not numeric in otu1. Please fix the data and try again.")
  }
  if (any(otu1[, -tax] < 0)) {
    stop("negative counts detected in otu1; cannot continue. Please ensure all counts are positive and try again.")
  }
  if (any(colSums(otu1[, -tax, drop = FALSE]) == 0)) {
    warning("some samples in otu1 have zero counts. Some functions may behave bizarrely as a result.")
  }
  missing.tax <- which(otu1[, tax, drop = FALSE] == "")
  if (length(missing.tax) != 0) {
    missing.tax.percent <- 100 * (length(missing.tax)/dim(otu1)[1])
    warning(paste("taxonomic data is missing for ", format(missing.tax.percent, 
                                                           digits = 3), "% of OTUs in otu1.", sep = ""))
  }
  if (given.both) {
    if (!identical(names(otu1), names(otu2))) {
      stop("the samples for otu1 and otu2 do not match. Please ensure you have matching otu1 and otu2 data.")
    }
    if (!is.data.frame(otu2)) {
      stop("the given object for otu2 is not a data frame.")
    }
    tax <- dim(otu2)[2]
    if (names(otu2)[tax] != "taxonomy") {
      stop("no 'taxonomy' column detected in otu2. Please ensure the last column of the table is titled 'taxonomy' (capitalization matters) and try again.")
    }
    if (!all(apply(otu2[, -tax, drop = FALSE], is.numeric, 
                   MARGIN = 1))) {
      stop("OTU data other than taxonomic information is not numeric in otu2. Please fix the data and try again.")
    }
    if (any(otu2[, -tax, drop = FALSE] < 0)) {
      stop("negative counts detected in otu2; cannot continue. Please ensure all counts are positive and try again.")
    }
    if (any(colSums(otu2[, -tax, drop = FALSE]) == 0)) {
      warning("some samples in otu2 have zero counts. Some functions may behave bizarrely as a result.")
    }
    missing.tax <- which(otu2[, tax, drop = FALSE] == "")
    if (length(missing.tax) != 0) {
      missing.tax.percent <- 100 * (length(missing.tax)/dim(otu2)[1])
      warning(paste("taxonomic data is missing for ", 
                    format(missing.tax.percent, digits = 3), "% of OTUs in otu2.", 
                    sep = ""))
    }
  }
}
