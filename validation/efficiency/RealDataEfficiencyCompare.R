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

#read loganalyser output of all simulations
cat.ess.txt <- read.table(paste0(data.file.path, "ess/ESS_", data.name, "Category.txt"), sep="\t", header=T)

#ESS/hour of paramaters of interest
category.efficiency.df <- get.efficiency(cat.ess.txt, cat.time.df, data.name)


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
  
  cons.ess.txt <- read.table(paste0(data.file.path, "ess/ESS_", data.name, "Cons", p, ".txt"), sep="\t", header=T)
  
  #ESS/hour of paramaters of interest
  assign(paste0(p, ".efficiency.df"), get.efficiency(cons.ess.txt, cons.time.df, data.name))
  
  # ratio of ESS/hour Cons vs Category
  assign(paste0(p, ".ratio.df"), get(paste0(p, ".efficiency.df")) / category.efficiency.df)
 
  #Mean <- apply(get(paste0(p, ".ratio.df")), 2, mean, trim=0.05)
  #write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_",data.name, p, ".txt"), quote = F, sep = "\t", row.names = FALSE)
}


pdf (file = paste0(output.figure.folder, "LogEfficiencyCompare_", data.name, ".pdf"), width = 7, height = 4)
boxplot(log(Random.ratio.df), xlim = c(0,20), boxwex = 0.2, col = "deepskyblue", at = seq(0, 20, length.out = 16) - 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,20,length.out=16), labels = colnames(Random.ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
title(main = data.name, ylab = c("Ratio of ESS per hour (cons/categories)"))
boxplot(log(Bactrian.ratio.df), xlim = c(0,20), boxwex = 0.2, col = "mediumseagreen", at = seq(0, 20, length.out = 16) , outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
boxplot(log(Beta.ratio.df), xlim = c(0,20), boxwex = 0.2, col = "blueviolet", at = seq(0, 20, length.out = 16) + 0.3, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
abline(h = 0.0, col = "red", lwd = 1.5)
legend("topright", inset=.01, c("Random walk","Bactrian", "Beta"), fill = c("deepskyblue","mediumseagreen", "blueviolet"), box.lty = 0, cex = 0.6)
dev.off()
