library(corrplot)

source('CorrelationUtils.R')
args = commandArgs(trailingOnly=TRUE)

n.taxa <- an.numeric(args[1])
log.file.path <- args[2]
output.figure.folder <- args[3]

#n.taxa <- 7
#log.file.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/correlation/"
#output.figure.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/correlation/figures/"

Ex.log <- read.table(file = paste0(log.file.path, "Ex.log"), sep = "\t", header = T)
In.log <- read.table(file = paste0(log.file.path, "In.log"), sep = "\t", header = T)
Monophyly.log <- read.table(file = paste0(log.file.path, "Mon.log"), sep = "\t", header = T)

monophyly <- Monophyly.log
for (i in 2:length(Monophyly.log)) {
  monophyly = monophyly[which(monophyly[, i]==1) ,]
}

sample.Nr <- monophyly$state

Ex.df <- Ex[sample.Nr,]
In.df <- In[sample.Nr,]

n.internal <- n.taxa - 2
n.external <- n.taxa  
log.rate.df <- log(cbind(Ex.df[,2:(n.external+1)],In.df[,2:(n.internal+1)]))
log.length.df <- log(cbind(Ex.df[,(n.external+2):length(Ex.df)],In.df[,(n.internal+2):length(In.df)]))

coeff.matrix <- cor(log.length.df,log.rate.df)

pdf(paste(output.figure.folder,"BranchLengthRateCorrelation2.pdf"), height=10, width=10)
par(mar=c(6,6,6,6))
corrplot(coeff.matrix, method="circle",tl.srt=360, tl.col="black",tl.pos = "n")
dev.off()












