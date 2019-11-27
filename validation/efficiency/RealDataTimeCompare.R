args = commandArgs(trailingOnly=TRUE)
source('EfficiencyCompare_utils.R')
#source('~/Desktop/validation/efficiency/EfficiencyCompare_utils.R')

n.sim <- args[1]
data.name <- args[2]
data.file.path <- args[3]
output.figure.folder <- args[4]


#n.sim <- 20
#data.name <- "RSV2"
#data.file.path <- "~/Desktop/validation/efficiency/others/"
#output.figure.folder <- "~/Desktop/validation/efficiency/figures/"
  
### read Category efficiency
cat.output.txt.path <- paste0(data.file.path,data.name,"Category/output/output_",data.name, "_", 1,"_")

#calculation time in screen log file
cat.time.df <- c()
for (sim in 1:n.sim) {
  output.txt = readLines(paste0(cat.output.txt.path, sim, ".txt"))
  timeLine = output.txt[grep("Total calculation time", output.txt)]
  cat.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
}



### read Cons efficiency
proposal <- c("Random", "Bactrian", "Beta")
for (p in proposal) {
  cons.output.txt.path = paste0(data.file.path, p, "/", data.name, "Cons/output/output_", data.name, "_", 2,"_")
  
  cons.time.df <- c()
  for (sim in 1:n.sim) {
    output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
    timeLine = output.txt[grep("Total calculation time", output.txt)]
    cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
  }
  assign(paste0(p, ".time.df"), cons.time.df)
  assign(paste0(p, ".ratio.df"), get(paste0(p, ".time.df")) / cat.time.df)

 
  #Mean <- apply(get(paste0(p, ".ratio.df")), 2, mean, trim=0.05)
  #write.table(t(Mean), file=paste0(output.figure.folder, "TimeTable_",data.name, p, ".txt"), quote = F, sep = "\t", row.names = FALSE)
}


pdf (file = paste0(output.figure.folder, "TimeCompare_", data.name, ".pdf"), width = 7, height = 4)
boxplot(Random.ratio.df, xlim = c(0,2), boxwex = 0.5, col = "deepskyblue", at = 0.5, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = c(0.5, 1, 1.5), labels = c("Random walk","Bactrian", "Beta"), cex.axis = 0.8)
axis(2, cex.axis = 0.8)
title(main = data.name, ylab = c("Ratio of running hours (cons/categories)"))
boxplot(Bactrian.ratio.df, xlim = c(0,2), boxwex = 0.5, col = "mediumseagreen", at = 1 , outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
boxplot(Beta.ratio.df, xlim = c(0,2), boxwex = 0.5, col = "blueviolet", at = 1.5, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
abline(h = 1.0, col = "red", lwd = 1.5)
dev.off()
