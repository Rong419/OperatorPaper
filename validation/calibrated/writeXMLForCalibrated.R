library(ape)
args = commandArgs(trailingOnly=TRUE)

xmltemplate.path <- args[1] 
logfile.folder <- args[2] 
output.txt.folder  <- args[3]

#xmltemplate.path <- "~/validation/calibrated/"
#logfile.folder <- "~/validation/calibrated/priors/" 
#output.txt.folder  <- "~/validation/calibrated/true/" 

# get M samples in log file
# in log file, there 10001 states
#from 101-th state, a sample is obtained after every 100 states
M <- matrix(nrow = 100, ncol = 1)
j <- 1;
for(i in seq(1001, 2000, 10)) {
  M[j] = i;
  j = j + 1;
}



Taxon <- c(20,120)
for (taxa in Taxon) {
	template.path <- paste0(xmltemplate.path,"cal_val_",taxa,"_template.xml")
	
	#read the log file
    Tree.log = read.nexus(file=paste0(logfile.folder,"simSeq_",taxa,"taxa.trees"))
    #read the log file
	L <- read.table(file=paste0(logfile.folder,"simSeq_",taxa,"taxa.log"), sep="\t", header=T)
	
	A=L$BirthRate;
	B=L$kappa;
	C=L$ucldStdev;
	D=L$Tree.height
	E=L$Tree.treeLength
	F1=L$freqParameter.1
	F2=L$freqParameter.2
	F3=L$freqParameter.3
	F4=L$freqParameter.4
	R=L$rate.mean
    
	#birthrates
    I=matrix(nrow = 100, ncol = 1)
   	#kappa
	K=matrix(nrow = 100, ncol = 1)
	#ucld
	U=matrix(nrow = 100, ncol = 1)
	#4 frequency parameters
	S1=matrix(nrow = 100, ncol = 1)
	S2=matrix(nrow = 100, ncol = 1)
	S3=matrix(nrow = 100, ncol = 1)
	S4=matrix(nrow = 100, ncol = 1)
	#Tree statistics
	TreH=matrix(nrow = 100, ncol = 1)
	TreL=matrix(nrow = 100, ncol = 1)
	#mean of branch rates  
	RatM=matrix(nrow = 100, ncol = 1)
    #tree
   	Tree = c()
   	
    j=1;
    for (i in M) {
    	TreH[j]=D[i];
    	TreL[j]=E[i];
		S1[j]=F1[i];
		S2[j]=F2[i];
		S3[j]=F3[i];
		S4[j]=F4[i];
		I[j]=A[i];
		U[j]=C[i];
		K[j]=B[i];
		RatM[j]=R[i];
    	Tree[j] = write.tree(Tree.log[[i]]); 
        j = j + 1;
	}
	
	write.table(S1,file=paste0(output.txt.folder,taxa,"taxa/Freq1.txt"),col.name=F,row.names=F)
	write.table(S2,file=paste0(output.txt.folder,taxa,"taxa/Freq2.txt"),col.name=F,row.names=F)
	write.table(S3,file=paste0(output.txt.folder,taxa,"taxa/Freq3.txt"),col.name=F,row.names=F)
	write.table(S4,file=paste0(output.txt.folder,taxa,"taxa/Freq4.txt"),col.name=F,row.names=F)
    S=cbind(S1,S2,S3,S4)
    write.table(S,file=paste0(output.txt.folder,taxa,"taxa/Freq.txt"),col.name=F,row.names=F)
 	write.table(TreH,file=paste0(output.txt.folder,taxa,"taxa/TreH.txt"),col.name=F,row.names=F)
	write.table(TreL,file=paste0(output.txt.folder,taxa,"taxa/TreL.txt"),col.name=F,row.names=F)
	write.table(I,file=paste0(output.txt.folder,taxa,"taxa/Bir.txt"),col.name=F,row.names=F)
	write.table(K,file=paste0(output.txt.folder,taxa,"taxa/Kap.txt"),col.name=F,row.names=F)
	write.table(U,file=paste0(output.txt.folder,taxa,"taxa/Ucld.txt"),col.name=F,row.names=F)
 	write.table(Tree,file=paste0(output.txt.folder,taxa,"taxa/trees.txt"),col.name=F,row.names=F,quote = F)
    write.table(RatM,file=paste0(output.txt.folder,taxa,"taxa/RatM.txt"),col.name=F,row.names=F)

	template.lines = readLines(template.path)
	for (sim.idx in 1:100) {
		for (line in template.lines) {
        	line = gsub("TREE", Tree[sim.idx], line)
        	line = gsub("FREQUENCIES", paste0(S1[sim.idx]," ", S2[sim.idx], " ", S3[sim.idx], " ", S4[sim.idx]), line)
        	line = gsub("KAPPA", K[sim.idx], line)
        	line = gsub("UCLDSTD", U[sim.idx], line)
        	line = gsub("SIM", sim.idx, line)
        	write(line, file=paste0(xmltemplate.path,"xml/Calibrated_",taxa,"taxa_",sim.idx,".xml"), append=TRUE)
        }
	}
	
}

