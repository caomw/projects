#PBS -S /bin/bash

#PBS -N parallel
#PBS -l select=64:ncpus=8
#PBS -l walltime=10:00:00
#PBS -j oe
##PBS -W group_list=a0801 # put correct group here
#PBS -m e

numProc=4
dirIn=/nobackupnfs1/oalexan1/projects/albedo/DIM_input_160mpp
dirOut=/nobackupnfs1/oalexan1/projects/albedo/DIM_input_640mpp
mkdir $dirOut
#cmd="gdal_translate -scale 0 32767 0 255 -co compress=lzw -ot Byte"
cmd="gdal_translate -outsize 25% 25% -co compress=lzw"
cd $dirIn
if [ "$PBS_NODEFILE" != "" ]; then 
    sshFileOption="--sshloginfile $PBS_NODEFILE"
else
    sshFileOption=""
fi
ls *.tif | parallel -P $numProc -u $sshFileOption "cd $dirIn; if [ ! -e $dirOut/{} ]; then $cmd {} $dirOut/{}; else echo File: $dirOut/{} exists; fi"

# dirIn=/nobackupnfs1/oalexan1/projects/albedo/DEM_tiles_sub4
# dirOut=/nobackupnfs1/oalexan1/projects/albedo/DEM_tiles_sub11
# mkdir $dirOut
# #cmd="gdal_translate -scale 0 32767 0 255 -co compress=lzw -ot Byte"
# cmd="gdal_translate -outsize 400% 400% -co compress=lzw"
# cd $dirIn
# if [ "$PBS_NODEFILE" != "" ]; then 
#     sshFileOption="--sshloginfile $PBS_NODEFILE"
# else
#     sshFileOption=""
# fi
# ls *.tif | parallel -P $numProc -u $sshFileOption "cd $dirIn; $cmd {} $dirOut/{}"

#cd $PBS_O_WORKDIR
#echo "Workdir is $(pwd)"
#echo "Lead node is $(uname -a)"
#echo "The nodes are $(cat $PBS_NODEFILE)" 
#seq 64 | parallel -j 4 -u --sshloginfile $PBS_NODEFILE "cd $PWD;./many.sh {} $PBS_NODEFILE"

#DI=/byss/moon/apollo_metric/apollo_15_16_17/DIM_input_1024ppd
#DI=DIM_input_sub4
#cmd="gdal_translate -scale 0 32767 0 255 -ot Byte -outsize 400% 400% -co compress=lzw"
#cmd="gdal_translate -outsize 400% 400% -co compress=lzw"
#cat drg.txt | xargs -P $numProc -I {} $cmd $DI/{} DIM_input_sub1/{}

#DR=/byss/moon/apollo_metric/apollo_15_16_17/DEM_release
#DR=DEM_tiles_sub4
#cmd="gdal_translate -outsize 400% 400% -co compress=lzw"
#cat dem.txt | xargs -P $numProc -I {} $cmd $DR/{} DEM_tiles_sub1/{}

# dirIn=$HOME/projects/albedo
# cmd="~/StereoPipeline/src/asp/Tools/reconstruct --drg-directory DIM_input_sub4 --dem-tiles-directory DEM_tiles_sub4 -d DEM_input_sub4 -s albedo_tiles4_sub4_iter3/cubes -e albedo_tiles4_sub4_iter3/exposure -r albedo_tiles4_sub4_iter3 -b 6:10:-10:-9 -t 1 --tile-size 4 --pixel-padding 5 -f albedo_tiles4_sub4_iter3/imagesList.txt -c photometry_init_1_settings.txt -i ";
# cd $dirIn
# ls DIM_input_sub4/*tif | parallel -P 1 -u --sshloginfile $PBS_NODEFILE "cd $dirIn; $cmd {}"

