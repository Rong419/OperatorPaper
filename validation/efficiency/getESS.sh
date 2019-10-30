#!/bin/sh

for data in {Shankarappa,RSV2}
do
model=Cons
	#for model in {Cons,Category}
	#do
	/Applications/BEAST2.6.0/bin/loganalyser -oneline /Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/others/${data}${model}/logs/*.log >/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/others/ess/ESS_${data}${model}.txt
	#done	
done


#for length in {Short,Medium}
#do
	#for model in {Cons,Category}
	#do
	#/Applications/BEAST2.6.0/bin/loganalyser -oneline /Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/simulated/20taxa/${length}${model}/logs/*.log >/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/simulated/20taxa/ess/ESS_${length}${model}20taxa.txt
	#done
#done

#for model in {Cons,Category}
#do
#/Applications/BEAST2.6.0/bin/loganalyser -oneline /Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/others/primates${model}/logs/*.log >/Users/ryanzhang/Documents/UOALearning/OperatorPaper/validation/efficiency/others/ess/ESS_primates${model}.txt
#done


