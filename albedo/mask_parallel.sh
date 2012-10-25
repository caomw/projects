#PBS -S /bin/bash

#PBS -N parallel
#PBS -l select=64:ncpus=8
#PBS -l walltime=10:00:00
#PBS -j oe
##PBS -W group_list=a0801 # put correct group here
#PBS -m e

dirIn=DIM_input_10mpp
dirMask=DIM_input_sub4
dirOut=DIM_input_10mpp_masked

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
currDir=$(pwd)

numProc=4
sshFileOption=""; if [ "$PBS_NODEFILE" != "" ]; then sshFileOption="--sshloginfile $PBS_NODEFILE"; fi
outFile="output_mask.txt"; rm -fv $outFile
ls $dirIn/*tif | parallel -P $numProc -u $sshFileOption \
    "cd $currDir; mask_parallel_one.sh {} $dirMask $dirOut >> $outFile 2>&1"

