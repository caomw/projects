#PBS -S /bin/bash         # shell type
#PBS -N cfd               # job name
#PBS -l select=10:ncpus=8 # 10 cpus, with 8 cores each
#PBS -l walltime=48:00:00 # wall time
#PBS -j oe                # whatever this means
#PBS -m e                 # whatever this means
#PBS -W group_list=s1219  # group

job=1; inJob=$1; if [ "$inJob" != "" ]; then job=$inJob; fi
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

