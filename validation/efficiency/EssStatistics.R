args = commandArgs(trailingOnly=TRUE)
source('EfficiencyCompare_utils.R')
#source('~/Desktop/validation/efficiency/EfficiencyCompare_utils.R')

n.sim <- args[1]
data.file.path <- args[2]
output.figure.folder <- args[3]

n.sim <- 20
data.file.path <- "~/Desktop/validation/efficiency/"
output.figure.folder <- "~/Desktop/validation/efficiency/figures/"

real.data.names <- c("anolis", "RSV2", "Shankarappa")

cat.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Category.txt"), sep="\t", header=T)

cons.ess.txt <- read.table(paste0(data.file.path, "others/", "ess/ESS_", data.name, "Cons", p, ".txt"), sep="\t", header=T)

assign(paste0(data.name, "cons.ess.df"), get.efficiency(cons.ess.txt, 1, data.name))

