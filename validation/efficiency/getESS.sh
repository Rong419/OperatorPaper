#!/bin/sh

for data in {anolis,Shankarappa,RSV2}
do
	for model in {Cons,Category,NoCons}
	do
	/Applications/BEAST2.6.0/bin/loganalyser -oneline ~/OperatorPaper/validation/efficiency/others/${data}${model}/logs/*.log >~/OperatorPaper/validation/efficiency/others/ess/ESS_${data}${model}.txt
	done	
done


for length in {Short,Medium}
do
	for model in {Cons,Category,NoCons}
	do
	/Applications/BEAST2.6.0/bin/loganalyser -oneline ~/OperatorPaper/validation/efficiency/simulated/${length}${model}/logs/*.log >~/OperatorPaper/validation/efficiency/simulated/ess/ESS_${length}${model}.txt
	done
done


for model in {Cons,Category}
	do
	model=Cons
	/Applications/BEAST2.6.0/bin/loganalyser -oneline ~/OperatorPaper/efficiency/others/primates${model}/logs/*.log >~/OperatorPaper/validation/efficiency/others/ess/ESS_primates${model}.txt
done


model=Cons
for proposal in {Random,Bactrian,Beta}
do
	for data in {anolis,Shankarappa,RSV2}
	do
	/Applications/BEAST2.6.0/bin/loganalyser -oneline ~/OperatorPaper/validation/efficiency/others/${proposal}/${data}${model}/logs/*.log >~/OperatorPaper/validation/efficiency/others/ess/ESS_${data}${model}${proposal}.txt
	done
done


