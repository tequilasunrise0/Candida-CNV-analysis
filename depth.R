options(repos = "https://cloud.r-project.org/")
library(rtracklayer)

files <- "your_sample.depth"
genes_of_interest <- read.csv("Genes-of-interests.csv")
gff <- "C_parapsilosis_CDC317_current_features.gff"

samtools_depth_mean_coverage <- function(samtools_depth_file, gff_file){
  
  cluster <- read.table(samtools_depth_file)
  track <- import(gff_file)
  print(head(track))
  cluster_ranges <- data.frame(seqnames(track), start(track), end(track), track$Name)
  
  all_range_means <- numeric()
  for(i in 1:nrow(cluster_ranges)){
    range_of_interest <- cluster_ranges$start.track[i] : cluster_ranges$end.track[i]
    subset1 <- subset(cluster, subset = cluster_ranges$seqnames.track[i] == cluster$V1 & cluster$V2 %in% range_of_interest)
    range_mean <- mean(subset1$V3)
    all_range_means <- c(all_range_means, range_mean)
    print(i)
  }
  
  cluster_ranges <- cbind(cluster_ranges, all_range_means)
  return(cluster_ranges)
}

for(file in files){
  cluster_ranges <- samtools_depth_mean_coverage(file, gff)
  cluster_ranges <- merge(cluster_ranges, genes_of_interest, by.x = "track.Name", by.y = "Cparap.ID", all.x = T)
  cluster_ranges <- cluster_ranges %>%
    group_by(seqnames.track.) %>%
    mutate(
      avg_read_depth = mean(all_range_means, na.rm = TRUE), 
      depth_ratio = all_range_means / avg_read_depth
    ) %>%
    ungroup()%>%
    arrange(desc(depth_ratio))%>%
    distinct(track.Name, .keep_all = TRUE) %>%
    filter(!is.na(track.Name))
  
  write.csv(cluster_ranges, "your_sample.csv", row.names = F)
}






