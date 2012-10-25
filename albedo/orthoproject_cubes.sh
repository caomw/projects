#PBS -S /bin/bash

#PBS -N extract
#PBS -l select=25:ncpus=8
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -W group_list=s1219
#PBS -m e

mpp=10
numProc=1  # Use just one process per node as extraction takes a lot of memory
numCores=8 # Each process will sprawn this many subprocesses
# To do: Must make mpp 10!!!
# To do: Remove the cube after extraction!!!
# To do: Don't extract again the cubes which were extracted before!!!

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
currDir=$(pwd)

if [ "$PBS_NODEFILE"  != "" ]; then sshFileOption="--sshloginfile $PBS_NODEFILE"
else                                sshFileOption=""; fi

logFile="output$mpp".txt
rm -fv $logFile
ls cubeDir/*cub | parallel -P $numProc -u $sshFileOption "cd $currDir; ./orthoproject_cube_sub1.sh {} $mpp $numCores >> $logFile 2>&1"

