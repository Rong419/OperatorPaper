args = commandArgs(trailingOnly=TRUE)
source('EfficiencyCompare_utils.R')
#source('~/Desktop/validation/efficiency/EfficiencyCompare_utils.R')

n.sim <- args[1]
data.file.path <- args[2]
output.figure.folder <- args[3]


#n.sim <- 20
#data.file.path <- "~/Desktop/validation/efficiency/"
#output.figure.folder <- "~/Desktop/validation/efficiency/figures/"
 
########## Real Data Efficiency  
real.data.names <- c("anolis", "RSV2", "Shankarappa")
model.names <- c("Category", "Cons", "NoCons")
for (data.name in real.data.names) {
  for (model in model.names){
  #read running time from output txt file
  output.txt.path <- paste0(data.file.path, "others/", data.name, model, "/output/Output_",data.name, "_", model,"_")
  
  #calculation time in screen log file
  time.df <- c()
  for (sim in 1:n.sim) {
    output.txt = readLines(paste0(output.txt.path, sim, ".txt"))
    timeLine = output.txt[grep("Total calculation time", output.txt)]
    time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
  }
  
  #read loganalyser output of all simulations
  ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, model, ".txt"), sep="\t", header=T)
  
  #ESS/hour of paramaters of interest
  assign(paste0(data.name,".", model, ".efficiency.df"), get.efficiency(ess.txt, time.df, data.name))
  }
}



########## Boxplot figures
pdf (file = paste0(output.figure.folder, "UcldStdevCompareAnolis.pdf"), width = 7, height = 4)
boxplot(anolis.Cons.efficiency.df[,8:11], xlim = c(0,22), ylim=c(1000, 6000), boxwex = 0.5, col = "forestgreen", at = seq(0, 18, length.out = 4) + 1, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,18,length.out=4) + 1.5, labels = colnames(anolis.Cons.efficiency.df[,8:11]), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(anolis.NoCons.efficiency.df[,8:11], xlim = c(0,22), ylim=c(1000, 6000),boxwex = 0.5, col = "dodgerblue", at = seq(0, 18, length.out = 4) + 2, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
#boxplot(anolis.Category.efficiency.df[,8:11], xlim = c(0,22), ylim=c(1000, 6000),boxwex = 0.5, col = "red", at = seq(0, 18, length.out = 4) + 3, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
title(main = "UcldStdev comparison of anolis", ylab = c("ESS per hour"))
legend("topright", inset=.01, c("Cons", "NoCons"), fill = c("forestgreen","dodgerblue"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "UcldStdevCompareRSV2.pdf"), width = 7, height = 4)
boxplot(RSV2.Cons.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0, 1200), boxwex = 0.5, col = "forestgreen", at = seq(0, 18, length.out = 5) + 1, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,18,length.out=5) + 1.5, labels = colnames(RSV2.Cons.efficiency.df[,7:11]), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(RSV2.NoCons.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0,1200),boxwex = 0.5, col = "dodgerblue", at = seq(0, 18, length.out = 5) + 2, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
#boxplot(RSV2.Category.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0,1200),boxwex = 0.5, col = "red", at = seq(0, 18, length.out = 5) + 3, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
title(main = "UcldStdev comparison of RSV2", ylab = c("ESS per hour"))
legend("topright", inset=.01, c("Cons", "NoCons"), fill = c("forestgreen","dodgerblue"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "UcldStdevCompareShankarappa.pdf"), width = 7, height = 4)
boxplot(Shankarappa.Cons.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0,800),boxwex = 0.5, col = "forestgreen", at = seq(0, 18, length.out = 5) + 1, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,18,length.out=5) + 1.5, labels = colnames(Shankarappa.Cons.efficiency.df[,7:11]), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(Shankarappa.NoCons.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0,800),boxwex = 0.5, col = "dodgerblue", at = seq(0, 18, length.out = 5) + 2, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
#boxplot(Shankarappa.Category.efficiency.df[,7:11], xlim = c(0,22), ylim=c(0,800),boxwex = 0.5, col = "red", at = seq(0, 18, length.out = 5) + 3, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
title(main = "UcldStdev comparison of Shankarappa", ylab = c("ESS per hour"))
legend("topright", inset=.01, c("Cons", "NoCons"), fill = c("forestgreen","dodgerblue"), box.lty = 0, cex = 0.6)
dev.off()

anolis.ucld.df = cbind(anolis.Category.efficiency.df$ucld.stdev, anolis.Cons.efficiency.df$ucld.stdev, anolis.NoCons.efficiency.df$ucld.stdev)
RSV2.ucld.df = cbind(RSV2.Category.efficiency.df$ucld.stdev, RSV2.Cons.efficiency.df$ucld.stdev, RSV2.NoCons.efficiency.df$ucld.stdev)
Shankarappa.ucld.df = cbind(Shankarappa.Category.efficiency.df$ucld.stdev, Shankarappa.Cons.efficiency.df$ucld.stdev, Shankarappa.NoCons.efficiency.df$ucld.stdev)

pdf (file = paste0(output.figure.folder, "UcldStdevCompare.pdf"), width = 7, height = 7)
boxplot(log(anolis.ucld.df), xlim = c(0,22), ylim=c(4,9),boxwex = 1.5, col = "maroon", at = c(1,9,17), outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = c(3,11,19), labels = c("Category", "Cons", "NoCons"), cex.axis = 1.0)
axis(2, cex.axis = 1.0)
abline(v = c(7, 15), col = "grey", lwd = 1.5)
boxplot(log(RSV2.ucld.df), xlim = c(0,22),ylim=c(4,9),boxwex = 1.5, col = "tomato", at = c(3,11,19), outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
boxplot(log(Shankarappa.ucld.df), xlim = c(0,22),ylim=c(4,9),boxwex = 1.5, col = "#9400D3", at = c(5,13,21), outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
title(main = "Efficiency comparison of ucld.stdev", ylab = c("ESS per hour in log space"))
legend("topright", inset=.01, c("Anolis", "RSV2", "HIV-1"), fill = c("maroon","tomato", "#9400D3"), box.lty = 0, cex = 0.6)
dev.off()

