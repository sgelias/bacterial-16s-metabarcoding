sumcol <- function(X) 
{
  ret = X
  X = as.matrix(X)
  if (dim(X)[1] > 1) 
    ret = colSums(X)
  return(ret)
}
