#!/bin/sh



settings=("cat" "cons" "nocons")
datasets=("anolis" "medium" "short" "RSV2" "Shankarappa"  "primates")


  for d in "${datasets[@]}"
  do
  for s in "${settings[@]}"
  do
        echo "Beginning ${d} ${s}"
        ~/beast/bin/beast -overwrite -beagle_SSE ../xml/${d}_${s}.xml > "Output_${d}_${s}.txt"
  done
  done

