pcoa_ggplot2 <- function(abund, pcoa, rank, sp.scores, meta.factors, sample.labels, 
          top, ellipse, main, file, ext, height, width, bw) 
{
  num.facs <- length(meta.factors)
  save <- !is.null(file)
  samples <- as.data.frame(cbind(Sample = rownames(pcoa$points), X = pcoa$points[, 1], Y = pcoa$points[, 2]))
  
  for (i in 1:num.facs) {
    samples <- cbind(samples, meta.factors[[i]])
    names(samples)[i + 3] <- names(meta.factors)[i]
  }
  
  samples$X <- as.numeric(as.character(samples$X))
  samples$Y <- as.numeric(as.character(samples$Y))
  samples$Sample <- as.character(samples$Sample)
  otus <- as.data.frame(cbind(OTU = rownames(sp.scores), X = sp.scores[, 1], Y = sp.scores[, 2]))
  otus$X <- as.numeric(as.character(otus$X))
  otus$Y <- as.numeric(as.character(otus$Y))

  if (dim(otus)[1] < top) {
    if (!is.null(rank)) {
      warning(paste("there are less than", top, "taxon groups at the given rank; plotting them all."))
    } else {
      warning(paste("there are less than", top, "taxon groups in the input data; plotting them all."))
    }
    top <- dim(sp.scores)[1]
  }
  
  otus <- otus[1:top, ]
  
  if (num.facs >= 2) {
    if (bw) {
      samples.aes <- aes_string(x = "X", y = "Y", label = "Sample", shape = names(samples)[4])
    } else {
      samples.aes <- aes_string(x = "X", y = "Y", label = "Sample", shape = names(samples)[4], colour = names(samples)[5])
    }
  } else if (num.facs == 1) {
    samples.aes <- aes_string(x = "X", y = "Y", label = "Sample", shape = names(samples)[4])
  }
  
  p <- ggplot(samples, samples.aes) + geom_point(alpha = 0.65, size = 7)
  shape <- c(16, 17, 15, 3, 7, 8, 1:2, 4:6, 9:15, 18, 48:57)
  
  if (num.facs == 1) {
    len <- length(levels(factor(samples[[names(samples)[4]]])))
    if (len <= 6) {
      p <- p + scale_shape_identity() + scale_shape_discrete(name = names(samples)[4])
    } else {
      p <- p + scale_shape_identity() + scale_shape_manual(name = names(samples)[4], values = shape[0:len])
    }
  } else if (num.facs >= 2) {
    len1 <- length(levels(factor(samples[[names(samples)[4]]])))
    len2 <- length(levels(factor(samples[[names(samples)[5]]])))
    len <- max(len1, len2)
    
    if (bw) {
      
      if (len <= 6) {
        p <- p + scale_shape_identity() + scale_shape_discrete(name = names(samples)[4])
      } else {
        p <- p + scale_shape_identity() + scale_shape_manual(name = names(samples)[4], values = shape[0:len])
      }
      
    } else {
      
      if (len <= 6) {
        p <- p + scale_shape_identity() + scale_shape_discrete(name = names(samples)[4]) + 
          scale_color_discrete(name = names(samples)[5])
      } else {
        p <- p + scale_shape_identity() + scale_shape_manual(name = names(samples)[4], values = shape[0:len]) + scale_color_discrete(name = names(samples)[5])
      }
      
    }
  }
  
  num.samples <- length(unique(samples$Sample))
  v.jitter <- sample(c(2.8, 0.5), size = num.samples, replace = TRUE)
  
  v.jitter <- sapply(v.jitter, FUN = function(x) {
    if (x != 0.5 && runif(1) < 0.5) {
      x * -1
    }
    else {
      x
    }
  })
  
  h.jitter <- sapply(v.jitter, FUN = function(x) {
    if (x != 0.5) {
      0.5
    }
    else {
      sample(c(-0.4, 1.4), size = 1)
    }
  })
  
  # Add an interactive OTU labels
  if (top != 0) {
    p <- p + geom_text_interactive(
      aes_string(
        x = "X", 
        y = "Y", 
        label = "OTU", 
        colour = NULL, 
        shape = NULL,
        tooltip = "OTU"
      ), 
      data = otus, 
      size = 4, 
      colour = "darkgrey", 
      alpha = 0.8
    )
  }
  
  # Add sample sables
  if (sample.labels) {
    p <- p + geom_text(
      size = 3, 
      colour = "black", 
      vjust = v.jitter, 
      hjust = h.jitter
    )
  }
  
  x.lab <- paste0("Axis I (", round(100 * pcoa$eig[1]/sum(pcoa$eig), digits = 2), "%)")
  y.lab <- paste0("Axis II (", round(100 * pcoa$eig[2]/sum(pcoa$eig), digits = 2), "%)")
  
  if (is.null(main)) {
    main.title = ""
  } else {
    main.title = main
  }
  
  p <- p + ggtitle(main.title) + xlab(x.lab) + ylab(y.lab)
  p <- p + theme(
    panel.background = element_rect(fill = "white"), 
    panel.border = element_rect(colour = "black", fill = "transparent")
  )
  
  if (len <= 12) {
    p <- p + scale_fill_viridis(discrete = T)
    #p <- p + scale_color_brewer(palette = "Set1")
  } else {
    col.func <- grDevices::colorRampPalette(RColorBrewer::brewer.pal(9, "Set1"))
    p <- p + scale_color_manual(values = col.func(len))
  }
  
  if (save) {
    .ggsave.helper(file, ext, width, height, plot = p)
  }

  p
}
