setwd("/Users/laylameghjee/Desktop/plink")
library(tidyverse)
# Read eigenvalues
eigenval <- scan("stick.eigenval")

pca_raw <- read_table2("stick.eigenvec", col_names = FALSE)
#sorting columns
pca <- pca_raw
pca <- pca[,-(1:2)]
ind <- pca_raw$X1
#removes any directory path that might be in sample name
ind <- gsub('^.*/','', ind)
#removes file suffix
ind <- gsub('\\.rmd\\.bam$','', ind)
#put identifiers back as first column
pca <- cbind(ind = ind, pca)
#naming the PC columns
names(pca)[2:ncol(pca)] <- paste0('PC', 1:(ncol(pca) - 1))

#assigning species labels
spp <- rep(NA, length(pca$ind))
spp[grep('Cist',pca$ind)] <- 'cist'
spp[grep('Obse',pca$ind)] <- 'obse'
spp[grep('Obsm',pca$ind)] <- 'obsm'
spp[grep('Scad',pca$ind)] <- 'scad'

#assigning location labels
loc <- rep(NA, length(pca$ind))
loc[grep('Cist',pca$ind)] <- 'lochcist'
loc[grep('Obs',pca$ind)] <- 'lochobs'
loc[grep('Scad',pca$ind)] <- 'lochscad'

#combines species and locations
spp_loc <- paste0(spp, '_', loc)
pca_plot <- as_tibble(data.frame(pca, spp = spp, loc = loc, spp_loc = spp_loc))

#calculating percentage variance
pve <- data.frame(
  PC = seq_along(eigenval),
  pve = eigenval / sum(eigenval) * 100
)

#plotting
graph <- ggplot(pca_plot, aes(PC1, PC2, col = spp, shape = loc)) +
  geom_point(size = 3) +
  coord_equal() +
  theme_light() +
  scale_colour_manual(values = c('red','blue','green','yellow')) +
  labs(
    title = 'Principle Component Analysis (PCA) of stickleback individuals',
    x = ('PC1 (', signif(pve$pve[1],3),'%)'),
    y = ('PC2 (', signif(pve$pve[2],3),'%)')
  )
#visualise plot
graph

