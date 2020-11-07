valid_meta <- function(otu1, otu2 = NULL, meta) 
{
  valid_OTU(otu1, otu2)
  if (is.null(meta)) {
    return(invisible(TRUE))
  }
  if (!is.data.frame(meta)) {
    stop("'meta' must be a data frame.")
  }
  otu1.samples <- names(otu1)[-dim(otu1)[2]]
  meta.samples <- rownames(meta)
  if (!identical(otu1.samples, meta.samples)) {
    in.otu1 <- setdiff(otu1.samples, meta.samples)
    in.meta <- setdiff(meta.samples, otu1.samples)
    error.msg <- paste("Sample names for otu1 and meta differ. They may be out of order.\nIn otu1, not in meta:\n", 
                       paste(in.otu1, collapse = " "), "\nIn meta, not in otu1:\n", 
                       paste(in.meta, collapse = " "))
    stop(error.msg)
  }
  if (!is.null(otu2)) {
    otu2.samples <- names(otu2)[-dim(otu2)[2]]
    if (!identical(otu2.samples, meta.samples)) {
      in.otu2 <- setdiff(otu2.samples, meta.samples)
      in.meta <- setdiff(meta.samples, otu2.samples)
      error.msg <- paste("Sample names for otu2 and meta differ. They may be out of order.\nIn otu2, not in meta:\n", 
                         paste(in.otu2, collapse = " "), "\nIn meta, not in otu2:\n", 
                         paste(in.meta, collapse = " "))
      stop(error.msg)
    }
  }
  invisible(TRUE)
}
