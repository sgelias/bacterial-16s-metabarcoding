col_splitup <- function(df, col = "", sep = "", max = NULL, names = NULL, 
          drop = TRUE) 
{
  if (sep == "") {
    stop(paste("\n", "    Error: separator ?  check ?col.splitup  ", 
               "\n", sep = ""))
  }
  if (col == "") {
    stop(paste("\n", "    Error: column to split? check ?col.splitup  ", 
               "\n", sep = ""))
  }
  if (!(col %in% names(df))) {
    stop(paste("\n", "    Error: column to be split is not in the dataframe", 
               "\n", sep = ""))
  }
  if (col %in% names(df)) {
    num.col <- which(names(df) %in% col)
  }
  list <- strsplit(df[[col]], sep, fixed = FALSE)
  vec <- vector()
  for (i in 1:length(list)) {
    vec <- c(vec, length(list[[i]]))
  }
  def.max <- max(c(max, length(names)))
  maximum <- c(max, max(vec), length(names))
  max <- max(maximum)
  if (max(vec) > def.max) {
  }
  else if (max(vec) < def.max) {
  }
  else {
  }
  for (i in 1:length(list)) {
    if (length(list[[i]]) < max) {
      x = rep("", max - length(list[[i]]))
      list[[i]] <- c(list[[i]], x)
    }
    else {
      list[[i]] <- list[[i]]
    }
  }
  new <- as.data.frame(do.call("rbind", list))
  if (is.null(names)) {
    new.name <- colnames(new)
  }
  else {
    if (length(names) == max) {
      new.name <- names
    }
    else if (length(names) < max) {
      new.name <- c(names, colnames(new)[(length(names) + 
                                            1):max])
    }
    else {
      new.name <- colnames(new)
    }
  }
  colnames(new) <- new.name
  if (!drop) {
    df.new <- cbind(df, new)
  }
  else {
    df.new <- cbind(df[, setdiff(colnames(df), col)], new)
  }
  return(df.new)
}
