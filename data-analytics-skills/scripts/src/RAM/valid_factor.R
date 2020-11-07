valid_factor <- function (meta, factors, min.factors = 1, max.factors = Inf) 
{
  if (max.factors < min.factors || max.factors < 1 || min.factors < 
      0) {
    stop("something has gone wrong internally; please contact the package maintainer.")
  }
  if (!is.data.frame(meta)) {
    stop("'meta' must be a data frame.")
  }
  if (!is.character(factors)) {
    stop("'factors' must be a character vector; see ?RAM.factors for help.")
  }
  factors.len <- length(factors)
  if (factors.len < min.factors) {
    stop(paste("only", factors.len, "factor(s) were given where", 
               min.factors, "were needed."))
  }
  if (length(names(factors)) != factors.len) {
    warning("not all factors are named; converting the names of ALL factors to column names; see ?RAM.factors for help.")
    names(factors) <- factors
  }
  if (factors.len > max.factors) {
    warning(paste(factors.len, "factors were given, this function supports up to", 
                  max.factors, "factor(s); ignoring the others."))
    factors <- factors[1:max.factors]
    names(factors) <- names(factors)[1:max.factors]
  }
  if (!all(factors %in% names(meta))) {
    stop("not all factors were found in 'meta', please check your spelling and try again.")
  }
  output <- meta[, factors, drop = FALSE]
  names(output) <- names(factors)
  output
}
