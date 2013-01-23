#PBS -S /bin/bash
#PBS -N cfd

# This example uses the Harpertown nodes
# User job can access ~7.6 GB of memory per Harpertown node.
# A memory intensive job that needs more than ~0.9 GB
# per process should use less than 8 cores per node
# to allow more memory per MPI process. This example
# asks for 64 nodes and 4 MPI processes per node.
# This request implies 64x4 = 256 MPI processes for the job.
#PBS -l select=1:ncpus=8
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -W group_list=s1219 
#PBS -m e

job=3; inJob=$1; if [ "$inJob" != "" ]; then job=$inJob; fi
mpp=1; inMpp=$2; if [ "$inMpp" != "" ]; then mpp=$inMpp; fi

echo job=$job mpp=$mpp


if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi

currDir=$(pwd)
if [ "$PBS_NODEFILE" = "" ]; then
    echo "Run locally"
    export PBS_NODEFILE="localMachines.txt"
else
    echo "Run on supercomputer"
fi

doOrtho=0
left=$(cat list.txt | head -n $job |tail -n 1 | cut -d' ' -f1)
right=$(cat list.txt | head -n $job |tail -n 1 | cut -d' ' -f2)

cmd="./resolve_drg.sh $mpp $doOrtho $left $right"
outFile="output_"$job"_"$mpp"mpp.txt"
echo "$cmd > $outFile"
$cmd > $outFile 2>&1

# run="./runOne.sh {}"

# echo $list | perl -pi -e "s#\s+#\n#g" | parallel -P 1 -u --sshloginfile $PBS_NODEFILE "cd $currDir; $run" > output$job.txt

