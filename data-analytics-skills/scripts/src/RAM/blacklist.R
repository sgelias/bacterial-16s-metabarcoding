blacklist <- function(rank = NULL) 
{
  blacklist <- c("unclassified", "unidentified", "incertae_sedis", 
                 "incertae sedis", "unassignable", "unknown")
  if (!is.null(rank)) {
    valid_rank(rank)
    rank <- get_rank_pat(rank)
    blacklist <- paste(paste(rank, blacklist(), collapse = "|", 
                             sep = ""), paste0(rank, ";"), sep = "|")
  }
  blacklist
}
