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
	cat.output.txt.path <- paste0(data.file.path, "others/", data.name,"Category/output/output_",data.name, "_Category_")

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
  cons.output.txt.path = paste0(data.file.path, "others/", data.name, "Cons/output/Output_", data.name, "_Cons_")
  
  cons.time.df <- c()
  for (sim in 1:n.sim) {
    output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
    timeLine = output.txt[grep("Total calculation time", output.txt)]
    cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
  }
  	
  cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Cons.txt"), sep="\t", header=T)
  
  #ESS/hour of paramaters of interest
  cons.efficiency.df <- get.efficiency(cons.ess.txt, cons.time.df, data.name)
  	
  #ratio of ESS/hour Cons vs Category
  assign(paste0(data.name, ".ratio.df"), cons.efficiency.df / category.efficiency.df)
 
  #Mean <- apply(get(paste0(data.name, ".ratio.df")), 2, mean, trim=0.05)
  #write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_",data.name, ".txt"), quote = F, sep = "\t", row.names = FALSE)
}

########## primates Data Efficiency
#read Category efficiency
cat.output.txt.path <- paste0(data.file.path, "others/primatesCategory/output/Output_primates_Category_")

#calculation time in screen log file
primates.cat.time.df <- c()
for (sim in 1:n.sim) {
  output.txt = readLines(paste0(cat.output.txt.path, sim, ".txt"))
  timeLine = output.txt[grep("Total calculation time", output.txt)]
  primates.cat.time.df[sim] = 1.4 * as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
}

#read loganalyser output of all simulations
primates.cat.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_primatesCategory.txt"), sep="\t", header=T)

#ESS/hour of paramaters of interest
primates.category.efficiency.df <- get.efficiency(primates.cat.ess.txt, primates.cat.time.df, "primates")

#read Cons efficiency
cons.output.txt.path = paste0(data.file.path, "others/primatesCons/output/Output_primates_Cons_")

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

#Mean <- apply(get("primates.ratio.df"), 2, mean, trim=0.05)
#write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_primates.txt"), quote = F, sep = "\t", row.names = FALSE)


########## Simulated Data Efficiency  
n.model <- c("Cons","Category")
l.sequence <- c("short","medium")
for (sequence.length in l.sequence) {
	
	for (model.name in n.model) {
      
		#calculation time in screen log file
		Time.df <- c()
		for (sim in 1:n.sim) {
		output.txt = readLines(paste0(data.file.path, "simulated/", sequence.length, model.name, "/output/Output_", sequence.length,"_", model.name,"_", sim, ".txt"))
		timeLine = output.txt[grep("Total calculation time", output.txt)]
		Time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
		}

		#read loganalyser output of all simulations
		ESS.txt <- read.table(paste0(data.file.path, "simulated/ess/ESS_",sequence.length, model.name,".txt"),sep="\t", header=T)

		#ESS of paramaters of interest
		assign(paste0(model.name,".Efficiency.df"), get.simulated.efficiency(ESS.txt,Time.df))
	 }

    assign(paste0(sequence.length,".ratio.df"), Cons.Efficiency.df/Category.Efficiency.df)
    
    #Mean <- apply(get(paste0(sequence.length,".Ratio.df")), 2, mean, trim=0.05)
    #write.table(t(Mean),file=paste0(output.figure.folder, "EfficiencyTable_",sequence.length, n.taxa, ".txt"),quote=F,sep="\t",row.names = FALSE)
}




########## Boxplot figures
AT = c(-0.3,1.2,2.7,4,4.5,6.2,7.7,10.2,11.7,13.2,14.7,16.2,17.7,19.2,20.7,22.2) # axis for anolis data
BT = c(0,1.5,3,5.1,6.5,8,9,10.5,12,13.5,15,16.5,18,19.5,21,22.5) # axis for RSV2 data
CT = c(0.3,1.8,3.3,5.4,6.8,8.3,9.3,10.8,12.3,13.8,15.3,16.8,18.3,19.8,21.3,22.8) # axis for Shankarappa data
# parameters names on X axis
XName <- c("posterior","likelihood","prior","birth.rate","death.rate","pop.size","tree.height","tree.length","ucld.mean","ucld.stdev","rate.mean","rate.variance","rate.coeff","kappa","frequency1","frequency2","frequency3","frequency4")
XT = c(0, 1.5,3,4,4.5, 5.2,6.5,8,9.2,10.5,12,13.5,15,16.5,18,19.5,21,22.5) # calibrations on X axis
pdf (file = paste0(output.figure.folder, "EfficiencyCompare_1.pdf"), width = 10, height = 6)
boxplot(anolis.ratio.df, xlim = c(0,23), ylim = c(0,4), boxwex = 0.2, col = "maroon", at = AT, outline = FALSE, xaxt = "n", yaxt = "n")
axis(1, at = XT, labels = XName, las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(RSV2.ratio.df, xlim = c(0,23), ylim = c(0,4), boxwex = 0.2, col = "tomato", at = BT, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
boxplot(Shankarappa.ratio.df, xlim = c(0,23), ylim = c(0,4), boxwex = 0.2, col = "#9400D3", at = CT, outline = FALSE, xaxt = "n", yaxt = "n", add = TRUE)
abline(h = 1.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("anolis","RSV2", "Shankarappa"), fill = c("maroon","tomato", "#9400D3"), box.lty = 0, cex = 0.6)
dev.off()

pdf (file = paste0(output.figure.folder, "EfficiencyCompare_2.pdf"), width = 10, height = 6)
boxplot(primates.ratio.df, xlim = c(0,16),boxwex = 0.2, ylim = c(0,15), at = seq(0,16,length.out=15) - 0.3,col="orange3",outline=FALSE,xaxt="n",yaxt="n")
boxplot(short.ratio.df, xlim = c(0,16), ylim = c(0,15), col="yellow4", boxwex = 0.2, at = seq(0,16,length.out=15),outline=FALSE,xaxt="n",yaxt="n",add=TRUE)
axis(1, at = seq(0,16,length.out=15), labels = colnames(short.ratio.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
boxplot(medium.ratio.df, xlim = c(0,16),boxwex = 0.2, ylim = c(0,15), at = seq(0,16,length.out=15) + 0.3,col="darkseagreen4",outline=FALSE,xaxt="n",yaxt="n",add=TRUE)
abline(h = 1.0, col = "red", lwd = 1.5)
title(main = "Efficiency comparison", ylab = c("Ratio of ESS per hour (cons/categories)"))
legend("topright", inset=.01, c("Primates","500 sites", "1000 sites"), fill = c("orange3","yellow4", "darkseagreen4"), box.lty = 0, cex = 0.6)
dev.off()

names.4.table <- c("anolis", "RSV2", "Shankarappa", "short","medium")
for (data in names.4.table) {
  Mean <- apply(get(paste0(data, ".ratio.df")), 2, mean, trim=0.05)
  write.table(t(Mean), file=paste0(output.figure.folder, "EfficiencyTable_",data, ".txt"), quote = F, sep = "\t", row.names = FALSE)
}


