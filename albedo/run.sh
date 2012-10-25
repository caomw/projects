#PBS -S /bin/bash
#PBS -N cfd

# This example uses the Harpertown nodes
# User job can access ~7.6 GB of memory per Harpertown node.
# A memory intensive job that needs more than ~0.9 GB
# per process should use less than 8 cores per node
# to allow more memory per MPI process. This example
# asks for 64 nodes and 4 MPI processes per node.
# This request implies 64x4 = 256 MPI processes for the job.
#PBS -l select=9:ncpus=8
#PBS -l walltime=48:00:00
#PBS -j oe
#PBS -W group_list=s1219 
#PBS -m e

cd ~/projects/albedo

PBS_NODEFILE="machines.txt"
if [ "$PBS_NODEFILE"  != "" ]; then sshFileOption="--sshloginfile $PBS_NODEFILE"
else                                sshFileOption=""; fi

#cat files.txt  | parallel -P 4 -u $sshFileOption "cd ~/projects/albedo; echo output goes to {}_dem.txt {}_dem_timed.txt; /usr/bin/time --output={}_dem_timed.txt ~/StereoPipeline/src/asp/Tools/reconstruct -c photometry_mosaic_10mpp.txt -r mosaic_10mpp -f mosaic_10mpp/imagesList.txt --init-dem -i {} > {}_dem.txt" 

cat files.txt  | parallel -P 4 -u $sshFileOption "cd ~/projects/albedo; echo output goes to {}.txt {}_timed.txt; /usr/bin/time --output={}_timee.txt ~/StereoPipeline/src/asp/Tools/reconstruct -c photometry_mosaic_10mpp.txt -r mosaic_10mpp -f mosaic_10mpp/imagesList.txt --init-albedo --is-last-iter -i {} > {}.txt"

#cat files.txt | perl -pi -e "s#mosaic_10mpp#test640mpp_2#g" | parallel -P 4 -u --sshloginfile machines.txt "cd ~/projects/albedo; /usr/bin/time --output={}_time.txt ~/StereoPipeline/src/asp/Tools/reconstruct -c photometry_mosaic_640mpp_2.txt -r test640mpp_2 -f test640mpp_2/imagesList.txt --init-albedo --is-last-iter -i {} > {}.txt" 


