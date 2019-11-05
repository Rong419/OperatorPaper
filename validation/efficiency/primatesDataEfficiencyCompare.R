args = commandArgs(trailingOnly=TRUE)
source('EfficiencyCompare_utils.R')
#source('~/Desktop/validation/efficiency/EfficiencyCompare_utils.R')


n.sim <- args[1]
data.file.path <- args[2]
output.figure.folder <- args[3]

data.name = primates  
Model <- c("Cons","Category")

for (model in Model) {

	simulated.folder = paste0(data.file.path,data.name,model,"/")

	if (model == "Cons") {
		model.Nr = 2
	} else {
		model.Nr = 1
	}
	output.txt.folder = paste0(simulated.folder,"error/error_",data.name, "MC3_", model.Nr,"_")


	#calculation time in screen log file
	Time.df <- c()
	for (sim in 1:n.sim) {
		output.txt = readLines(paste0(output.txt.folder, sim, ".txt"))
		timeLine = output.txt[grep("real", output.txt)]
		time = strsplit(gsub("real\t", "", timeLine),"m")
		minitue = time[[1]][1]
		second = strsplit(time[[1]][2],"s")
		Time.df[sim] = (as.numeric(minitue) * 60 + as.numeric(second)) / 3600 
	}

	#read loganalyser output of all simulations
	ESS.txt <- read.table(paste0(data.file.path,"ess/ESS_",data.name,model,".txt"),sep="\t", header=T)

	#ESS of paramaters of interest

		assign(paste0(model,".Efficiency.df"), get.primates.efficiency(ESS.txt,Time.df))


}

ratio.df <- Cons.Efficiency.df/Category.Efficiency.df
Mean <- apply(ratio.df,2,mean,trim=0.05)
write.table(t(Mean),file=paste0(output.figure.folder, "EfficiencyTable_",data.name,".txt"),quote=F,sep="\t",row.names = FALSE)

pdf (file=paste0(output.figure.folder, "EfficiencyCompare_",data.name,".pdf"),width=7,height=4)
boxplot(Cons.Efficiency.df/Category.Efficiency.df, xlim = c(0,15), boxwex = 0.5, at = seq(0,15,length.out=15),outline=FALSE,xaxt="n",yaxt="n")
axis(1, at = seq(0,15,length.out=15), labels = colnames(Cons.Efficiency.df),las=2,cex.axis=0.8)
axis(2,cex.axis=0.8)
abline(h=1.0,col="red",lwd=2.0)
title(main=data.name, ylab = c("Ratio of ESS per hour (cons/categories)"))
dev.off()
