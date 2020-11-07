custom_pcoa_plot <- function(data, is.OTU = TRUE, meta, factors, rank, stand.method = NULL, 
          dist.method = "morisita", sample.labels = TRUE, top = 20, 
          ellipse = FALSE, main = NULL, file = NULL, ext = NULL, height = 8, 
          width = 10, ggplot2 = TRUE, bw = FALSE) 
{
  num.facs <- length(factors)
  
  if (!is.numeric(top) || length(top) != 1L || top < 0) {
    stop("'top' must be a numeric vector of length 1 and have a value > 0.")
  }
  
  if (!is.logical(sample.labels) || length(sample.labels) != 
      1L || is.na(sample.labels)) {
    stop("'sample.labels' must be a logical vector of length 1.")
  }
  
  if (!is.logical(bw) || length(bw) != 1L || is.na(bw)) {
    stop("'bw' must be a logical vector of length 1.")
  }
  
  if (!any(identical(ellipse, 1), identical(ellipse, 2), identical(ellipse, FALSE))) {
    stop("'ellipse' should be either 1, 2, or FALSE; see ?pcoa.plot for details.")
  }
  
  if (ellipse > num.facs) {
    stop("argument 'ellipse' cannot be greater than the number of factors.")
  }
  
  if (ellipse && ggplot2) {
    warning("drawing the ellipses for groups is not currently supported when 'ggplot2=TRUE'.")
  }
  
  meta.factors <- valid_factor(meta, factors, min.factors = 1, max.factors = 2)
  if (bw && num.facs >= 2) {
    if (ggplot2) {
      separator <- "_"
    }
    else {
      separator <- "/"
    }
    cross.name <- paste(names(meta.factors), collapse = separator)
    meta.factors <- cbind(paste(meta.factors[, 1], meta.factors[, 
                                                                2], sep = separator), meta.factors)
    names(meta.factors)[1] <- cross.name
  }
  for (column in colnames(meta.factors)) {
    if (!is.factor(meta.factors[, column])) {
      warning(paste("column", column, "from 'factors' is not a factor; attempting to coerce now", 
                    "(see ?RAM.factors for help)."))
      meta.factors[, column] <- as.factor(meta.factors[, 
                                                       column])
    }
    if (length(levels(meta.factors[, column])) > 9) {
      warning(paste("there are more than 9 levels in column", 
                    column, "from 'factor'; only 9 will be shown."))
    }
    if (any(summary(meta.factors[, column]) <= 2) && ellipse) {
      warning(paste("column", column, "from 'factor' has less than two", 
                    "observations for a level, this prevents ellipses from", 
                    "being plotted."))
    }
  }
  if (is.OTU) {
    valid_OTU(data)
    if (is.null(rank)) {
      rank <- NULL
      abund <- transpose.OTU(data)
    }
    else {
      rank <- rank
      valid_rank(rank)
      valid_meta(otu1 = data, meta = meta)
      abund <- tax_abund(data, rank = rank, drop.unclassified = TRUE)
    }
  }
  else if (!is.OTU) {
    rank <- NULL
    abund <- data
    abund <- abund[match(rownames(meta), rownames(abund)), ]
    
    if (!identical(rownames(meta), rownames(abund))) {
      stop("data and metadata do not have same samples")
    }
  }
  
  if (!is.null(stand.method)) {
    abund <- decostand(abund, stand.method)
  }
  
  else {
    abund <- abund
  }
  
  dists <- vegdist(abund, method = dist.method)
  k.max <- nrow(abund) - 1
  pcoa <- suppressWarnings(pco(sqrt(dists), k.max))
  
  if (dim(pcoa$points)[2] < 2) {
    stop("less than two axes of ordination were calculated. Please try again with different values for 'stand.method' and/or 'dist.method'.")
  }
  
  sp.scores <- wascores(pcoa$points, abund)
  
  pcoa_ggplot2(abund, pcoa, rank, sp.scores, meta.factors,
               sample.labels, top, ellipse, main, file, ext, height,
               width, bw)
  
}
