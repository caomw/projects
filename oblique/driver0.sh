#PBS -S /bin/bash
#PBS -N group0

# This example uses the Harpertown nodes
# User job can access ~7.6 GB of memory per Harpertown node.
# A memory intensive job that needs more than ~0.9 GB
# per process should use less than 8 cores per node
# to allow more memory per MPI process. This example
# asks for 64 nodes and 4 MPI processes per node.
# This request implies 64x4 = 256 MPI processes for the job.
#PBS -l select=4:ncpus=8
#PBS -l walltime=20:00:00
#PBS -j oe
#PBS -W group_list=s1219 
#PBS -m e

num=0
tag=run5
angle=25
sub=4

label=$tag"_sub"$sub"_"$angle"deg";

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi

#list=""; for ((i=0; i <= 9999; i++)); do list="$list $i"; done

currDir=$(pwd)
if [ "$PBS_NODEFILE" == "" ]; then
    PBS_NODEFILE="localMachines.txt"
fi

run="./run_pair.pl $sub $angle $tag stereo.default {}"

cat list$num.txt | parallel -P 2 -u --sshloginfile $PBS_NODEFILE "cd $currDir; $run" > output"_"$label.txt
