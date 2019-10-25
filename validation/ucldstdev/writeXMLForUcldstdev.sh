#!/bin/sh


TEMPLATE=Simulated_Ucldstdev_tempplate.xml
k=1
for ucld in $(seq 0.1 0.1 1)
do 
   for sim in {1..2}
   do
   sed "s/FILEHERE/simulated_ucldstdev${k}_${sim}/g; s/UCLDHERE/${ucld}/g" ./${TEMPLATE} > ./xml/simulated_ucldstdev${k}_${sim}.xml
   done
   let "k += 1"
done

