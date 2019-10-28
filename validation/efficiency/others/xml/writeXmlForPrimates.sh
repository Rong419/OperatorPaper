#!/bin/sh
 
for param in {1..2}
do 
    for sim in {1..20}
    do
    sed "s/FILE/${param}_${sim}/g" ./primates_${param}.xml > ./xml/primates_${param}_${sim}.xml
    echo "use primates_${param}.xml to write primates_${param}_${sim}.xml"
    sed "s/FILE/${param}_${sim}/g" ./primatesMC3_${param}.xml > ./xml/primatesMC3_${param}_${sim}.xml
    echo "use primatesMC3_${param}.xml to write primatesMC3_${param}_${sim}.xml" 
    done
done

