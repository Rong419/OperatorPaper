#!/bin/sh
#SBATCH -J simSq_120taxa         # The job name
#SBATCH -A nesi00390            # The account code
#SBATCH --time=03:59:00       # The walltime
#SBATCH --mem=6G               # total Memory in MB ie. ? * 1024
#SBATCH --cpus-per-task=8       # OpenMP Threads
#SBATCH --ntasks=1              # not use MPI
#SBATCH --hint=multithread      # A multithreaded job, also a Shared-Memory Processing (SMP) job
#SBATCH -D /nesi/project/nesi00390/rong/operator/calibrated/output    # The initial directory
#SBATCH -o output_simSq_120taxa.txt         # The output file
#SBATCH -e error_simSq_120taxa.txt         # The error file

module load beagle-lib/3.0.1-gimkl-2017a
module load Java/1.8.0_144

srun java -Xmx2800m -Djava.library.path=$BEAGLE_LIB_PATH -jar /nesi/project/nesi00390/rong/operator/ConstantDistanceOperator.jar -threads 8 -beagle_SSE /nesi/project/nesi00390/rong/operator/calibrated/xml/getPriorSamplesFor120Taxa.xml
