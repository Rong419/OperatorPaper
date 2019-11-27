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
	assign(paste0(data.name, "cat.time.df"), cat.time.df)
	
	#read loganalyser output of all simulations
	cat.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Category.txt"), sep="\t", header=T)

	#ESS/hour of paramaters of interest
	assign(paste0(data.name, "cat.ess.df"), get.efficiency(cat.ess.txt, 1, data.name))

	#read Cons efficiency
	p <- "Random"
  	cons.output.txt.path = paste0(data.file.path, "others/", p, "/", data.name, "Cons/output/output_", data.name, "_", 2,"_")
  
  	cons.time.df <- c()
  	for (sim in 1:n.sim) {
    output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
    timeLine = output.txt[grep("Total calculation time", output.txt)]
    cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
  	}
  	
  	assign(paste0(data.name, "cons.time.df"), cons.time.df)
  	cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Cons", p, ".txt"), sep="\t", header=T)
  
  	#ESS/hour of paramaters of interest
  	assign(paste0(data.name, "cons.ess.df"), get.efficiency(cons.ess.txt, 1, data.name))
  
}
### make tables
time.table <- cbind(anoliscat.time.df,anoliscons.time.df,RSV2cat.time.df,RSV2cons.time.df,Shankarappacat.time.df,Shankarappacons.time.df)
write.table(time.table,"~/Desktop/RealDataTimeTable.txt",quote = F, sep = "\t")
min.cat.ess <- c()
min.para <- c()
con.ess <- c()
i <- 1
for (data.name in real.data.names) {
  cat.average.ess = apply(get(paste0(data.name,"cat.ess.df")), 2, mean)
  min.cat.ess[i] = min(cat.average.ess)
  min.info = which(cat.average.ess == min.cat.ess[i])
  min.pos = as.numeric(min.info)
  min.para[i] = colnames(get(paste0(data.name,"cat.ess.df")))[min.pos]
  con.ess[i] = mean(get(paste0(data.name,"cons.ess.df"))[,min.pos])
  i = i + 1
}
ess.table <- cbind(real.data.names, min.para, min.cat.ess, con.ess)
write.table(ess.table,"~/Desktop/RealDataEssTable.txt",quote = F, sep = "\t")


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
primates.category.ess.df <- get.efficiency(primates.cat.ess.txt, 1, "primates")

#read Cons efficiency
cons.output.txt.path = paste0(data.file.path, "others/primatesCons/output/output_primates_2_")

primates.cons.time.df <- c()
for (sim in 1:n.sim) {
  output.txt = readLines(paste0(cons.output.txt.path, sim, ".txt"))
  timeLine = output.txt[grep("Total calculation time", output.txt)]
  primates.cons.time.df[sim] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
}

primates.cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_primatesCons.txt"), sep="\t", header=T)

primates.cons.ess.df <- get.efficiency(primates.cons.ess.txt, 1, "primates")
### make tables
time.table <- cbind(primates.cat.time.df,primates.cons.time.df)
write.table(time.table,"~/Desktop/PrimatesTimeTable.txt",quote = F, sep = "\t")

  cat.average.ess = apply(primates.category.ess.df, 2, mean)
  min.cat.ess = min(cat.average.ess)
  min.info = which(cat.average.ess == min.cat.ess)
  min.pos = as.numeric(min.info)
  min.para = colnames(primates.category.ess.df)[min.pos]
  con.ess = mean(primates.cons.ess.df[,min.pos])

ess.table <- cbind("primates", min.para, min.cat.ess, con.ess)
write.table(ess.table,"~/Desktop/PrimatesEssTable.txt",quote = F, sep = "\t")


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
		assign(paste0(sequence.length, model.name, ".time.df"), Time.df)
		
		#read loganalyser output of all simulations
		ESS.txt <- read.table(paste0(data.file.path, "simulated/", n.taxa, "/ess/ESS_",sequence.length, model.name, n.taxa,".txt"),sep="\t", header=T)

		#ESS of paramaters of interest
		assign(paste0(sequence.length, model.name, ".ess.df"), get.simulated.efficiency(ESS.txt,1))
	 }
}
### make tables
simulated.time.table <- cbind(ShortCategory.time.df, ShortCons.time.df, MediumCategory.time.df, ShortCons.time.df)
write.table(simulated.time.table,"~/Desktop/SimulatedTimeTable.txt",quote = F, sep = "\t")

min.cat.ess <- c()
min.para <- c()
con.ess <- c()
i <- 1
for (sequence.length in l.sequence) {
  cat.average.ess = apply(get(paste0(sequence.length,"Category.ess.df")), 2, mean)
  min.cat.ess[i] = min(cat.average.ess)
  min.info = which(cat.average.ess == min.cat.ess[i])
  min.pos = as.numeric(min.info)
  min.para[i] = colnames(get(paste0(sequence.length,"Category.ess.df")))[min.pos]
  con.ess[i] = mean(get(paste0(sequence.length,"Cons.ess.df"))[,min.pos])
  i = i + 1
}
simulated.ess.table <- cbind(l.sequence, min.para, min.cat.ess, con.ess)
write.table(simulated.ess.table,"~/Desktop/SimulatedEssTable.txt",quote = F, sep = "\t")





########## Boxplot figures
for (name in real.data.names) {
pdf (file = paste0(output.figure.folder, name,"_TimeEss.pdf"), width = 13, height = 6)
#attach(mtcars)
layout(matrix(c(1,2),1,2),widths=c(1,3))  
boxplot(get(paste0(name,"cat.time.df")),xlim = c(0,2),at = c(0.5), col="royalblue3", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n")
boxplot(get(paste0(name,"cons.time.df")),xlim = c(0,2), at = c(1.5) ,col="springgreen", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
axis(1, at = c(0.5,1.5), labels = c("Category","Cons"), cex.axis = 0.8)
axis(2, cex.axis = 0.8)
title(ylab = c("Running time (hour)"))

boxplot(get(paste0(name,"cat.ess.df")),xlim = c(0,20),at = seq(0, 20, length.out = 16) - 0.3, col="royalblue3", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
boxplot(get(paste0(name,"cons.ess.df")),xlim = c(0,20), at = seq(0, 20, length.out = 16) + 0.1, col="springgreen", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n" ,add=TRUE)
axis(1, at = seq(0,20,length.out=16), labels = colnames(get(paste0(name,"cat.ess.df"))), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
legend("topright", inset=.01, c("Category","Cons"), fill = c("royalblue3", "springgreen"), box.lty = 0, cex = 0.6)
title(ylab = c("ESS"))
#detach(mtcars)
dev.off()
}

pdf (file = paste0(output.figure.folder, "primates_TimeEss.pdf"), width = 13, height = 6)
#attach(mtcars)
layout(matrix(c(1,2),1,2),widths=c(1,3))  
boxplot(primates.cat.time.df,xlim = c(0,2),at = c(0.5), col="royalblue3", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n")
boxplot(primates.cons.time.df,xlim = c(0,2), at = c(1.5) ,col="springgreen", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
axis(1, at = c(0.5,1.5), labels = c("Category","Cons"), cex.axis = 0.8)
axis(2, cex.axis = 0.8)
title(ylab = c("Running time (hour)"))

boxplot(primates.category.ess.df,xlim = c(0,20),at = seq(0, 20, length.out = 15) - 0.3, col="royalblue3", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
boxplot(primates.cons.ess.df,xlim = c(0,20), at = seq(0, 20, length.out = 15) + 0.1, col="springgreen", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n" ,add=TRUE)
axis(1, at = seq(0,20,length.out=15), labels = colnames(primates.category.ess.df), las=2, cex.axis = 0.8)
axis(2, cex.axis = 0.8)
legend("topright", inset=.01, c("Category","Cons"), fill = c("royalblue3", "springgreen"), box.lty = 0, cex = 0.6)
title(ylab = c("ESS"))
#detach(mtcars)
dev.off()


for (name in l.sequence) {
  pdf (file = paste0(output.figure.folder,name,n.taxa,"_TimeEss.pdf"), width = 13, height = 6)
  #attach(mtcars)
  layout(matrix(c(1,2),1,2),widths=c(1,3))  
  boxplot(get(paste0(name,"Category.time.df")),xlim = c(0,2),at = c(0.5), col="royalblue3", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n")
  boxplot(get(paste0(name,"Cons.time.df")),xlim = c(0,2), at = c(1.5) ,col="springgreen", boxwex = 0.6, outline = FALSE, xaxt = "n", yaxt = "n", add=TRUE)
  axis(1, at = c(0.5,1.5), labels = c("Category","Cons"), cex.axis = 0.8)
  axis(2, cex.axis = 0.8)
  title(ylab = c("Running time (hour)"))
  
  boxplot(get(paste0(name,"Category.ess.df")),xlim = c(0,20),at = seq(0, 20, length.out = 15) - 0.3, col="royalblue3", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n")
  boxplot(get(paste0(name,"Cons.ess.df")),xlim = c(0,20), at = seq(0, 20, length.out = 15) + 0.1, col="springgreen", boxwex = 0.3, outline = FALSE, xaxt = "n", yaxt = "n" ,add=TRUE)
  axis(1, at = seq(0,20,length.out=15), labels = colnames(get(paste0(name,"Category.ess.df"))), las=2, cex.axis = 0.8)
  axis(2, cex.axis = 0.8)
  legend("topright", inset=.01, c("Category","Cons"), fill = c("royalblue3", "springgreen"), box.lty = 0, cex = 0.6)
  title(ylab = c("ESS"))
  #detach(mtcars)
  dev.off()
}