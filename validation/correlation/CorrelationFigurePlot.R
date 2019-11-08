library(corrgram)
library(ape)
library(ggblur)

source('CorrelationUtils.R')
args = commandArgs(trailingOnly=TRUE)

log.file.path <- args[1]
output.figure.folder <- args[2]

#log.file.path <- "~/Desktop/validation/correlation/"
#output.figure.folder <- "~/Desktop/validation/correlation/"

ExtRates.log <- read.table(file = paste0(log.file.path, "ExtRates.log"), sep = "\t", header = T)
IntRates.log <- read.table(file = paste0(log.file.path, "IntRates.log"), sep = "\t", header = T)

r_ANDI = ExtRates.log$Branch.Rate.1
r_CASS = ExtRates.log$Branch.Rate.2
r_DIGI = ExtRates.log$Branch.Rate.3
r_EMU = ExtRates.log$Branch.Rate.4
r_KIWI = ExtRates.log$Branch.Rate.5
r_OST = ExtRates.log$Branch.Rate.6
r_RHEA = ExtRates.log$Branch.Rate.7
External.Rates <- data.frame(cbind(r_ANDI,r_DIGI,r_CASS,r_EMU,r_KIWI,r_OST,r_RHEA))
Internal.Rates <- IntRates.log[,2:6]

TreeHeight <- ExtRates.log$Tree.Height
t.AD <-  ExtRates.log$tMRCA.AD.
t.CE <- ExtRates.log$tMRCA.CE.
t.CEK <- ExtRates.log$tMRCA.CEK.
t.CEKO <- ExtRates.log$tMRCA.CEKO.
t.ADKCEKO <- ExtRates.log$tMRCA.ADCEKO.
Monophyly <- ExtRates.log[,9:13]

data.df <- cbind(External.Rates, Internal.Rates, t.AD, t.CE, t.CEK, t.CEKO, t.ADKCEKO, TreeHeight, Monophyly)
S1 <- data.df[which(data.df$Monophyly.AD.==1) ,]
S2 <- S1[which(S1$Monophyly.ADCEKO.==1),]
S3 <- S2[which(S2$Monophyly.CE.==1),]
S4 <- S3[which(S3$Monophyly.CEK.==1),]
S5 <- S4[which(S4$Monophyly.CEKO.==1),]

plot.df <- S5[,-(19:23)]
names(plot.df)<-c("r1","r2","r3","r4","r5","r6","r7","r8","r9","r10","r11","r12","t1","t2","t3","t4","t5","T")

pdf(paste(output.figure.folder,"RatesAndTimeCorrelation.pdf"), height=10, width=10)
corrgram(plot.df)
dev.off()

d1 = r_ANDI * t.AD 
d2 = r_DIGI * t.AD 
d3 = r_CASS * t.CE
d4 = r_EMU * t.CE
d5 = r_KIWI * t.CEK
d6 = r_OST * t.CEKO
d7 = r_RHEA * TreeHeight
d8 = Internal.Rates$Branch.Rate.1 * (t.ADKCEKO - t.AD)
d9 = Internal.Rates$Branch.Rate.2 * (t.CEK - t.CE)
d10 = Internal.Rates$Branch.Rate.3 * (t.CEKO - t.CEK)
d11 = Internal.Rates$Branch.Rate.4 * (t.ADKCEKO - t.CEKO)
d12 = Internal.Rates$Branch.Rate.5 * (TreeHeight - t.ADKCEKO)

distance.df <- cbind(d1,d2,d3,d4,d5,d6,d7,d8,d9,d10,d11,d12,Monophyly)
U1 <- distance.df[which(data.df$Monophyly.AD.==1) ,]
U2 <- U1[which(U1$Monophyly.ADCEKO.==1),]
U3 <- U2[which(U2$Monophyly.CE.==1),]
U4 <- U3[which(U3$Monophyly.CEK.==1),]
U5 <- U4[which(U4$Monophyly.CEKO.==1),]

plot.distance.df <- U5[,1:12]

pdf(paste(output.figure.folder,"DistanceCorrelation.pdf"), height=10, width=10)
corrgram(plot.distance.df)
dev.off()



tao1 <- log(plot.df$t1)
tao2 <- log(plot.df$t1)
tao3 <- log(plot.df$t2)
tao4 <- log(plot.df$t2)
tao5 <- log(plot.df$t3)
tao6 <- log(plot.df$t4)
tao7 <- log(plot.df$T)
tao8 <- log(plot.df$t5-plot.df$t1)
tao9 <- log(plot.df$t3-plot.df$t2)
tao10 <- log(plot.df$t4-plot.df$t3)
tao11 <- log(plot.df$t5-plot.df$t4)
tao12 <- log(plot.df$T-plot.df$t5)
log.tao.df <- data.frame(cbind(tao1,tao2,tao3,tao4,tao5,tao6,tao7,tao8,tao9,tao10,tao11,tao12))
log.rate.df <- data.frame(log(plot.df[,1:12]))

corrgram(plot.distance.df)

for (i in 1:12) {
	tao = log.tao.df[,i]
	for (j in 1:12) {
		rate = log.rate.df[,j]
		coeff.df = data.frame(cbind(tao,rate))
		assign(paste0("t",i,"r",j),get.correlation.plot(coeff.df))
	}
}

ggarrange(p2,p1, ncol = 12, nrow = 12)

plot(x,y,pch=20,cex=1,col="darkblue",xlab ="rate",ylab="branch length ",xaxt="n",yaxt="n")
axis(1,seq(-0.6,0.8,length.out=3))
axis(2,seq(-2.2,1.0,length.out=3))
axis(2,seq(-2.2,-1.0,length.out=3))	











