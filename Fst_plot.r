setwd("/Users/laylameghjee/Desktop")

# Load libraries
library(ggplot2)

# Import the data, including column names
fst_data <- read.table("obse_vs_obsm_5kb.windowed.weir.fst", header = TRUE)


#plotting 
#BIN_START used as genomic position along each chrom
#MEAN_FST used as average Fst value for each window
graph <- ggplot(fst_data, aes(x = BIN_START, y = MEAN_FST)) +
  geom_point(size = 0.3, color = "lightpink") +
#splits each chrom into own panel, with own x-axis range
  facet_wrap(~ CHROM, scales = "free_x") +
  labs(title = "Genome-wide Fst scan (5kb windows)",
       x = "Position",
       y = "Mean Fst") +
  theme_minimal()

#visualising plot
graph