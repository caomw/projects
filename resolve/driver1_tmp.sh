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

mpp=10
inMpp=$1
if [ "$inMpp" != "" ]; then
    mpp=$inMpp
fi

echo mpp=$mpp

jobNum=1
echo Job is $jobNum    

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi

currDir=$(pwd)
if [ "$PBS_NODEFILE" = "" ]; then
    echo "Run locally"
    export PBS_NODEFILE="localMachines.txt"
else
    echo "Run on supercomputer"
fi

doOrtho=0
left=$(cat list.txt | head -n $jobNum |tail -n 1 | cut -d' ' -f1)
right=$(cat list.txt | head -n $jobNum |tail -n 1 | cut -d' ' -f2)

echo ./resolve_drg.sh $mpp $doOrtho $left $right
#./resolve_drg.sh $mpp $doOrtho $left $right > "output"$jobNum"_"$mpp"mpp.txt" 2>&1

# run="./runOne.sh {}"

# echo $list | perl -pi -e "s#\s+#\n#g" | parallel -P 1 -u --sshloginfile $PBS_NODEFILE "cd $currDir; $run" > output$jobNum.txt

