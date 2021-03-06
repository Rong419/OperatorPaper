args = commandArgs(trailingOnly=TRUE)

source('OperatorValidationUtils.R')

n.sim <- as.numeric(args[1])
taxa <- args[2]
log.file.path <- args[3]
true.txt.path <- args[4]
output.figure.folder <- args[5]

#log.file.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/calibrated/logs/"
#true.txt.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/calibrated/true/"
#output.figure.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/calibrated/figures/"

# the prefix of true data file .txt
# which is also the abbreviations of parameters to compare
parameter.names <- c("TreH","TreL","Kap","Ucld","Bir","RatM","Freq1","Freq2","Freq3","Freq4")

# read true data from .txt files
for (para.name in parameter.names) {
     assign(paste0("true.",para.name),read.table(file=paste0(true.txt.path,taxa,"taxa/",para.name,".txt"), sep="\t"))
     
     # intilaize the data frame to save the sampled data from .log files
     assign(paste0("log.",para.name), data.frame(matrix(ncol=3, nrow=n.sim)))
}

# iterating all the simulations to get 95% HPD and posterior mean
for (i in 1:n.sim) {
   this.sim.df = read.table(file=paste0(log.file.path,"/calibrated",taxa,"taxa_",i,".log"),sep="\t",header=T)
   u=length(this.sim.df$Sample)
   l=0.1*u
   log.TreH[i,1:3] = get.95(this.sim.df$Tree.height[l:u])
   log.TreL[i,1:3] = get.95(this.sim.df$Tree.treeLength[l:u])
   log.Kap[i,1:3] = get.95(this.sim.df$kappa[l:u])
   log.Ucld[i,1:3] = get.95(this.sim.df$ucldStdev[l:u])
   log.Bir[i,1:3] = get.95(this.sim.df$BirthRate[l:u])
   log.RatM[i,1:3] = get.95(this.sim.df$rate.mean[l:u])
   log.Freq1[i,1:3] = get.95(this.sim.df$freqParameter.1[l:u])
   log.Freq2[i,1:3] = get.95(this.sim.df$freqParameter.2[l:u])
   log.Freq3[i,1:3] = get.95(this.sim.df$freqParameter.3[l:u])
   log.Freq4[i,1:3] = get.95(this.sim.df$freqParameter.4[l:u])
   #log.TreH[i,1:3] = get.95(this.sim.df$Tree.height[501:5001])
   #log.TreL[i,1:3] = get.95(this.sim.df$Tree.treeLength[501:5001])
   #log.Kap[i,1:3] = get.95(this.sim.df$kappa[501:5001])
   #log.Ucld[i,1:3] = get.95(this.sim.df$ucldStdev[501:5001])
   #log.Bir[i,1:3] = get.95(this.sim.df$BirthRate[501:5001])
   #log.RatM[i,1:3] = get.95(this.sim.df$rate.mean[501:5001])
   #log.Freq1[i,1:3] = get.95(this.sim.df$freqParameter.1[501:5001])
   #log.Freq2[i,1:3] = get.95(this.sim.df$freqParameter.2[501:5001])
   #log.Freq3[i,1:3] = get.95(this.sim.df$freqParameter.3[501:5001])
   #log.Freq4[i,1:3] = get.95(this.sim.df$freqParameter.4[501:5001])
}

TreH.res <- get.calibrated.plot(true.TreH,log.TreH, n.sim, 0,2,0,2,"TreeHeight")
TreL.res <- get.calibrated.plot(true.TreL,log.TreL, n.sim, 0,8,0,8,"TreeLength")
Kap.res <- get.calibrated.plot(true.Kap,log.Kap, n.sim, 1,5,1,5,"Kappa")
Ucld.res <- get.calibrated.plot(true.Ucld,log.Ucld, n.sim, 0,0.6,0,0.6,"UcldStdev")
Bir.res <- get.calibrated.plot(true.Bir,log.Bir, n.sim,2,30,2,30,"BithRate")

#TreL.res <- get.calibrated.plot(true.TreL,log.TreL, n.sim, 5,20,5,20,"TreeLength")

Freq1.res <- get.calibrated.plot(true.Freq1,log.Freq1, n.sim,0,0.6,0,0.6,"Frequency1")
Freq2.res <- get.calibrated.plot(true.Freq2,log.Freq2, n.sim,0,0.6,0,0.6,"Frequency2")
Freq3.res <- get.calibrated.plot(true.Freq3,log.Freq3, n.sim,0,0.6,0,0.6,"Frequency3")
Freq4.res <- get.calibrated.plot(true.Freq4,log.Freq4, n.sim,0,0.6,0,0.6,"Frequency4")
RatM.res <- get.rate.calibrated.plot(log.RatM,n.sim,"RateMean")

Figure <- ggarrange(TreH.res[[3]],TreL.res[[3]],Kap.res[[3]] ,Bir.res[[3]], Freq1.res[[3]], Freq2.res[[3]], Freq3.res[[3]], Freq4.res[[3]], Ucld.res[[3]] ,RatM.res[[3]], ncol=4,nrow=3)

True <- c()
False <- c()
j <- 1
for (para.name in parameter.names) {
True[j] <- get(paste0(para.name,".res"))[[1]]
False[j] <- get(paste0(para.name,".res"))[[2]]
j = j + 1
}
cover.df = data.frame(cbind(parameter.names,True,False))
write.table(cover.df,file = paste(output.figure.folder,taxa,"taxaCalibratedCoverageTable.txt"),quote=FALSE,row.names = FALSE)


pdf(paste(output.figure.folder,taxa,"taxaCalibratedCoverageFigure.pdf"), height=10, width=10)
annotate_figure(Figure,top = text_grob("Compare of true and estimated values in well-calibrated simulation study",face = "bold", size = 14))
dev.off()


