args = commandArgs(trailingOnly=TRUE)
library(ape)

data.name <- args[1]
n.taxa <- as.numeric(args[2])
tree.file.foler <- args[3]

#data.name <- "anolis"
#n.taxa <- 29
#tree.file.foler <- "~/Desktop/"

strees <- read.nexus(paste0(tree.file.foler, data.name, ".trees"))
target <- read.nexus(paste0(tree.file.foler, "summary_", data.name,".trees"))

#temp.tree1 <- write.tree(target)
#temp.tree2 <- gsub("\\d", "", temp.tree1)
#target.tree <- gsub(":.", "", temp.tree2)

mapped.tree.order <- c()
i <- 1
j <- 1
while (i <= length(strees)) {
  #temp.tree3 = write.tree(strees[[i]])
  #temp.tree4 = gsub("\\d", "", temp.tree3)
 # this.tree = gsub(":.", "", temp.tree4)
  #if (target.tree == this.tree) {
  if (all.equal(target, strees[[i]], use.edge.length=FALSE)) {
    mapped.tree.order[j] = i
    j = j + 1
    print(i)
  } 
  i = i + 1
}

#trees.2.save <- strees[mapped.tree.order]
#write.tree(trees.2.save, file = paste0(tree.file.foler, data.name, "_filtered.trees"))

template.lines <- readLines(paste0(tree.file.foler, data.name, ".trees"))

last.valid.line <- 10 + n.taxa * 2
Lines <- 1 : last.valid.line
Lines <- c(Lines, mapped.tree.order + last.valid.line)

for (line.Nr in Lines) {
  line = template.lines[line.Nr]
  write(line, file = paste0(tree.file.foler, "filtered_", data.name, ".trees"), append=TRUE)
}

