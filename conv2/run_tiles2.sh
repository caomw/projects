#!/bin/sh

sub=2
qsub="qsub -N tile -l select=1:ncpus=8 -l walltime=24:00:00 -W group_list=s1219 -j oe -m e --"
#qsub="qsub -q devel -N tile -l select=1:ncpus=8 -l walltime=0:01:00 -W group_list=s1219 -j oe -m e --"

cmd="$qsub $(pwd)/run21.sh $sub 1 0   $(pwd)"; echo $cmd; $cmd
# cmd="$qsub $(pwd)/run21.sh $sub 5 0   $(pwd)"; echo $cmd; $cmd
# cmd="$qsub $(pwd)/run21.sh $sub 5 0.7 $(pwd)"; echo $cmd; $cmd
