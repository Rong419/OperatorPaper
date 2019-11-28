#!/bin/sh
# This shell script is used to generate 100 xml files
# by replacing values of some parameters 
# including tree, frequencies, rates, kappa, ucld

taxa=20
TEMPLATE=SimulateAlignment${taxa}taxa_template.xml

for length in {500,1000}
do
	sed "s/LENGTH/${length}/g" ./${TEMPLATE} > ./xml/${taxa}taxaAlignmentLength_${length}.xml
done


