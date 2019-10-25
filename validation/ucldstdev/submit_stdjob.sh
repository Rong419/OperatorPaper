#!/bin/sh
TEMPLATE=stdtemplate.sh


for ucld in $(seq 1 10)
do 
    for sim in {1..2}
    do
    sed "s/FILE/simulated_ucldstdev${ucld}_${sim}/g" ${TEMPLATE} > ./temp.sl 
    echo "submit simulated_ucldstdev${ucld}_${sim}.xml"
    sbatch temp.sl 
    rm -f temp.sl 
    sleep 5
    done
done

