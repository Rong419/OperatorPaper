library(corrplot)
library(gplots)

source('CorrelationUtils.R')
args = commandArgs(trailingOnly=TRUE)

data.name <- args[1]
n.taxa <- as.numeric(args[2])
log.file.path <- args[3]
output.figure.folder <- args[4]

#data.name <- "ratites"
#n.taxa <- 7
#log.file.path <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/correlation/"
#output.figure.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/correlation/figures/"
#data.name <- "anolis"
#n.taxa <- 29
#log.file.path <- "~/Desktop/validation/correlation/"
#output.figure.folder <- "~/Desktop/validation/correlation/figures/"

#Ex.log <- read.table(file = paste0(log.file.path, "Ex_", data.name, ".log"), sep = "\t", header = T)
#In.log <- read.table(file = paste0(log.file.path, "In_", data.name, ".log"), sep = "\t", header = T)
#Monophyly.log <- read.table(file = paste0(log.file.path, "Mon.log"), sep = "\t", header = T)

#monophyly <- Monophyly.log
#for (i in 2:length(Monophyly.log)) {
  #monophyly = monophyly[which(monophyly[, i]==1) ,]
#}

#sample.Nr <- monophyly$state

#Ex.df <- Ex[sample.Nr,]
#In.df <- In[sample.Nr,]

#Ex.df <- Ex.log
#In.df <- In.log

#n.internal <- n.taxa - 2
#n.external <- n.taxa  
#log.rate.df <- log(cbind(Ex.df[,2:(n.external+1)],In.df[,2:(n.internal+1)]))
#log.length.df <- log(cbind(Ex.df[,(n.external+2):length(Ex.df)],In.df[,(n.internal+2):length(In.df)]))
Rates.log <- read.table(file = paste0(log.file.path,data.name, "_branch_rate.log"), sep = "\t", header = T)
Lengths.log <- read.table(file = paste0(log.file.path, data.name, "_branch_length.log"), sep = "\t", header = T)
log.rate.df <- log(Rates.log[,-c(1)])
log.length.df <-log(Lengths.log[,-c(1)])

coeff.matrix <- cor(log.rate.df,log.length.df)

pdf(paste(output.figure.folder,"correlation", data.name, ".pdf"), height=8, width=8)
corrplot(coeff.matrix, method="circle",tl.srt=90, tl.col="black",tl.cex=0.5)
dev.off()

#coeff.matrix <- cor(log.length.df,log.rate.df)

#pdf(paste(output.figure.folder,"correlation", data.name, ".pdf"), height=10, width=10)
#corrplot(coeff.matrix, method="circle",tl.srt=360, tl.col="black",tl.pos = "n")
#corrplot(coeff.matrix, method="circle",tl.srt=90, tl.col="black",tl.cex=0.5)
#corrplot(coeff.matrix, method="circle",tl.srt=90, tl.col="black",tl.cex=0.5,order = "hclust",hclust.method = "single")
#dev.off()

#pdf(paste(output.figure.folder,"correlation_heatmap", data.name, ".pdf"), height=8, width=13)
#heatmap.2(coeff.matrix, Colv=FALSE, dendrogram="row",margins = c(8, 9),col=bluered)
#heatmap.2(coeff.matrix, Rowv=FALSE, dendrogram="column",margins = c(8, 9),col=bluered)
#heatmap.2(coeff.matrix,dendrogram="both", symm=TRUE, margins = c(8, 9),col=bluered)
#dev.off()











