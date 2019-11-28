args = commandArgs(trailingOnly=TRUE)

n.sim <- as.numeric(args[1])
template.path <- args[2]
xml.folder <- args[3]
data.folder <- args[4]

#template.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/simulated/xmls/"
#xml.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/simulated/xmls/xml/"
#data.folder <- "/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/simulated/data/"

sequence.length = c("Medium","Short")
length = c(1000,500)
model = c("Category","Cons")


taxa = 120

	for (l in 1:2){
		for (m in model){
        	template.lines <- readLines(paste0(template.path,sequence.length[l],m,taxa,"taxa_template.xml"))
        	data.file <- readLines(paste0(data.folder,taxa,"taxaAlignmentLength_",length[l],".xml"))
            data <- paste0(data.file[2:(length(data.file)-6)],collapse ="\n")
            	for (sim.idx in 1:n.sim) {
	            	for (line in template.lines) {
                		line <- gsub("\\[DataHere\\]", data, line)
                    	line <- gsub("\\[SimHere\\]", sim.idx, line)
                    	write(line, file=paste0(xml.folder,sequence.length[l],m,taxa,"taxa_",sim.idx,".xml"), append=TRUE)
                	 }
                 }
        }
    }

