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
for (data.name in real.data.names) {
	#read Category efficiency
	cat.output.txt.path <- paste0(data.file.path, "others/", data.name,"Category/output/output_",data.name, "_", 1,"_")

	#calculation time in screen log file
	cat.time.df <- c()
	for (sim in 1:n.sim) {
  	output.txt = readLines(paste0(cat.output.txt.path, sim, ".txt"))
  	timeLine = output.txt[grep("Total calculation time", output.txt)]
  	cat.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
	}
  
	#read loganalyser output of all simulations
	cat.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Category.txt"), sep="\t", header=T)

	#ESS/hour of paramaters of interest
	category.efficiency.df <- get.efficiency(cat.ess.txt, cat.time.df, data.name)
 
	#read Cons efficiency
	p <- "Random"
  	cons.output.txt.path = paste0(data.file.path, "others/", p, "/", data.name, "Cons/output/output_", data.name, "_", 2,"_")
  
  	cons.time.df <- c()
  	for (sim in 1:n.sim) {
    output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
    timeLine = output.txt[grep("Total calculation time", output.txt)]
    cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
  	}
  	
  	cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Cons", p, ".txt"), sep="\t", header=T)
  
  	#ESS/hour of paramaters of interest
  	cons.efficiency.df <- get.efficiency(cons.ess.txt, cons.time.df, data.name)
  	
  	#ratio of ESS/hour Cons vs Category
  	assign(paste0(data.name, ".ratio.df"), cons.efficiency.df / category.efficiency.df)
 
  	Mean <- apply(get(paste0(data.name, ".ratio.df")), 2, mean, trim=0.05)
  	write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_",data.name, ".txt"), quote = F, sep = "\t", row.names = FALSE)
}

########## primates Data Efficiency
#read Category efficiency
cat.output.txt.path <- paste0(data.file.path, "others/primatesCategory/output/output_primates_1_")

#calculation time in screen log file
primates.cat.time.df <- c()
for (sim in 1:n.sim) {
  output.txt = readLines(paste0(cat.output.txt.path, sim, ".txt"))
  timeLine = output.txt[grep("Total calculation time", output.txt)]
  primates.cat.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
}

#read loganalyser output of all simulations
primates.cat.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_primatesCategory.txt"), sep="\t", header=T)

#ESS/hour of paramaters of interest
primates.category.efficiency.df <- get.efficiency(primates.cat.ess.txt, primates.cat.time.df, "primates")

#read Cons efficiency
cons.output.txt.path = paste0(data.file.path, "others/primatesCons/output/output_primates_2_")

primates.cons.time.df <- c()
for (sim in 1:n.sim) {
  output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
  timeLine = output.txt[grep("Total calculation time", output.txt)]
  primates.cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
}

primates.cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_primatesCons.txt"), sep="\t", header=T)

#ESS/hour of paramaters of interest
primates.cons.efficiency.df <- get.efficiency(primates.cons.ess.txt, primates.cons.time.df, "primates")

#ratio of ESS/hour Cons vs Category
assign("primates.ratio.df", primates.cons.efficiency.df / primates.category.efficiency.df)

Mean <- apply(get("primates.ratio.df"), 2, mean, trim=0.05)
write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_primates.txt"), quote = F, sep = "\t", row.names = FALSE)


########## Simulated Data Efficiency  
n.model <- c("Cons","Category")
l.sequence <- c("Short","Medium")
n.taxa <- "20taxa"
for (sequence.length in l.sequence) {
	
	for (model.name in n.model) {
      
		#calculation time in screen log file
		Time.df <- c()
		for (sim in 1:n.sim) {
		output.txt = readLines(paste0(data.file.path, "simulated/", n.taxa, "/", sequence.length, model.name, "/output/output_", sequence.length, model.name, n.taxa, "_", sim, ".txt"))
		timeLine = output.txt[grep("Total calculation time", output.txt)]
		Time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
		}

		#read loganalyser output of all simulations
		ESS.txt <- read.table(paste0(data.file.path, "simulated/", n.taxa, "/ess/ESS_",sequence.length, model.name, n.taxa,".txt"),sep="\t", header=T)

		#ESS of paramaters of interest
		assign(paste0(model.name,".Efficiency.df"), get.simulated.efficiency(ESS.txt,Time.df))
	 }

    assign(paste0(sequence.length,".Ratio.df"), Cons.Efficiency.df/Category.Efficiency.df)
    
    #Mean <- apply(get(paste0(sequence.length,".Ratio.df")), 2, mean, trim=0.05)
    #write.table(t(Mean),file=paste0(output.figure.folder, "EfficiencyTable_",sequence.length, n.taxa, ".txt"),quote=F,sep="\t",row.names = FALSE)
}




########## Boxplot figures
pdf (file = paste0(output.figure.folder, "LogEfficiencyCompare_1.pdf"), width = 7, height = 4)
boxplot(log(anolis.ratio.df), xlim = c(0,20), ylim = c(-1,3), boxwex = 0.2, col = "deepskyblue", at = seq(0, 20, length.out = 16) - 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,20,length.out=16), labels = colnames(anolis.ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(log(RSV2.ratio.df), xlim = c(0,20), ylim = c(-1,3), boxwex = 0.2, col = "mediumseagreen", at = seq(0, 20, length.out = 16) , outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
boxplot(log(Shankarappa.ratio.df), xlim = c(0,20), ylim = c(-1,3), boxwex = 0.2, col = "blueviolet", at = seq(0, 20, length.out = 16) + 0.3, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
abline(h = 0.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Log ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("anolis","RSV2", "Shankarappa"), fill = c("deepskyblue","mediumseagreen", "blueviolet"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "LogEfficiencyCompare_2.pdf"), width = 7, height = 4)
boxplot(log(Short.Ratio.df), xlim = c(0,16), ylim = c(-1,3), col="royalblue3", boxwex = 0.2, at = seq(0,16,length.out=15),outline=FALSE,xaxt="n",yaxt="n")
axis(1, at = seq(0,16,length.out=15), labels = colnames(Short.Ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(log(Medium.Ratio.df), xlim = c(0,16),boxwex = 0.2, ylim = c(-1,3), at = seq(0,16,length.out=15) + 0.3,col="springgreen",outline=FALSE,xaxt="n",yaxt="n",add=TRUE)
abline(h = 0.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Log ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("primates","500 sites", "1000 sites"), fill = c("deepskyblue","royalblue3", "springgreen"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "EfficiencyCompare_1.pdf"), width = 7, height = 4)
boxplot(anolis.ratio.df, xlim = c(0,20), ylim = c(0,11), boxwex = 0.2, col = "maroon", at = seq(0, 20, length.out = 16) - 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = seq(0,20,length.out=16), labels = colnames(anolis.ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(RSV2.ratio.df, xlim = c(0,20), ylim = c(0,11), boxwex = 0.2, col = "tomato", at = seq(0, 20, length.out = 16) , outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
boxplot(Shankarappa.ratio.df, xlim = c(0,20), ylim = c(0,11), boxwex = 0.2, col = "darkgoldenrod3", at = seq(0, 20, length.out = 16) + 0.3, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
abline(h = 1.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("anolis","RSV2", "Shankarappa"), fill = c("maroon","tomato", "darkgoldenrod3"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "EfficiencyCompare_2.pdf"), width = 7, height = 4)
boxplot(primates.ratio.df, xlim = c(0,16),boxwex = 0.2, ylim = c(0,9), at = seq(0,16,length.out=15) - 0.3,col="orange3",outline=FALSE,xaxt="n",yaxt="n")
boxplot(Short.Ratio.df, xlim = c(0,16), ylim = c(0,9), col="yellow4", boxwex = 0.2, at = seq(0,16,length.out=15),outline=FALSE,xaxt="n",yaxt="n",add=TRUE)
axis(1, at = seq(0,16,length.out=15), labels = colnames(Short.Ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(Medium.Ratio.df, xlim = c(0,16),boxwex = 0.2, ylim = c(0,9), at = seq(0,16,length.out=15) + 0.3,col="darkseagreen4",outline=FALSE,xaxt="n",yaxt="n",add=TRUE)
abline(h = 1.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("Primates","500 sites", "1000 sites"), fill = c("orange3","yellow4", "darkseagreen4"), box.lty = 0, cex = 0.6)
dev.off()


