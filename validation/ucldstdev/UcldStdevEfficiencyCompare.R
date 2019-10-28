args = commandArgs(trailingOnly=TRUE)
library(ggplot2)

n.sim <- args[1]
ess.file.path <- args[2]
output.file.path <- args[3]
output.figure.folder <- args[4]


#n.sim <- 2
#ess.file.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/ucldstdev/ess/"
#output.file.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/ucldstdev/output/"
#output.figure.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/ucldstdev/figures/"
  
ucldstdev <- seq(0.1, 1.0, length.out = 10)
Time.df = c()
Ucld.df = c()
Test = c()
i <- 1
for (ucld in 1:10) {
	#calculation time in screen log file

	for (sim in 1:n.sim) {
		output.txt = readLines(paste0(output.file.path, "output_simulated_ucldstdev", ucld, "_", sim, ".txt"))
		timeLine = output.txt[grep("Total calculation time", output.txt)]
		Time.df[i] = as.numeric(gsub(" .+", "", gsub(".+[:] ", "", timeLine))) / 3600 
		Ucld.df[i] = ucldstdev[ucld]
		Test[i] = 1
		i = i + 1
	}
}
	#read loganalyser output of all simulations
	ESS.txt <- read.table(paste0(ess.file.path,"ESS_ucldstdev.txt"),sep="\t", header=T)
  #ESS of ucldstdev
	ucldstdev.Efficiency.df <- ESS.txt$ucldStdev.ESS / Time.df
  
	plot.df <- data.frame(cbind(Test, ucldstdev.Efficiency.df, Ucld.df))
	

pdf (file=paste0(output.figure.folder, "UcldstdevEfficiencyCompare.pdf"),width=4,height=3)
ggplot(data=plot.df,aes(x=factor(Test),y=ucldstdev.Efficiency.df,color=as.character(Ucld.df))) + 
    geom_point(position = position_jitterdodge(jitter.width = 0.2),size=2) + 
    scale_color_discrete(name="True value")  +
    xlab("Test") + ylab("ESS per hour of Ucldstdev") +
    theme(
      panel.grid.minor = element_blank(),
      panel.border = element_blank(),
      panel.background = element_blank(),
      plot.background = element_blank(),
      plot.title = element_text(hjust=0.5),
      axis.line = element_line(),
      axis.ticks = element_line(color="black"),
      axis.text.x = element_text(color="black", size=10),
      axis.text.y = element_text(color="black", size=10),
      axis.title.x = element_text(size=12),
      axis.title.y = element_text(size=12)
    )
dev.off()








