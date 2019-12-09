library(corrplot)
library(gplots)

args = commandArgs(trailingOnly=TRUE)

data.name <- args[1]
log.file.path <- args[2]
output.figure.folder <- args[3]

#data.name <- "anolis"
#log.file.path <- "~/Desktop/validation/correlation/anolis/"
#output.figure.folder <- "~/Desktop/validation/correlation/figures/"

Rates.log <- read.table(file = paste0(log.file.path,data.name, "_branch_rate.log"), sep = "\t", header = T)
Lengths.log <- read.table(file = paste0(log.file.path, data.name, "_branch_length.log"), sep = "\t", header = T)

Lengths.log[Lengths.log=="0"] <- NA
Rates.log[Rates.log=="0"] <- NA

log.rate.df <- log(Rates.log[,-c(1)])
log.length.df <-log(Lengths.log[,-c(1)])


coeff.matrix <- cor(log.rate.df,log.length.df, use = "pairwise.complete")

pdf(paste(output.figure.folder,"correlation_", data.name, ".pdf"), height=12, width=12)
corrplot(coeff.matrix, method="circle",tl.srt=90, tl.col="black",tl.cex=0.6,na.label = "circle",na.label.col = "white")
dev.off()







