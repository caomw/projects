#!/bin/bash

if [ "$#" -lt 3 ]; then 
    echo Usage: $0 file.tif 'meters-per-pixel number-of-processors'
    exit
fi
file=$1; mpp=$2; numProc=$3

ORTHOPROJECT=$HOME/StereoPipeline/src/asp/Tools/orthoproject

cubeDir="cubeDir"               # input
drgDir=DIM_input_"$mpp"mpp"_v2" # output

if [ "$PBS_O_WORKDIR" != "" ]; then cd $PBS_O_WORKDIR; fi
echo "Will run $* in $(pwd)"

#ulimit -f 4000000000 # 4GB max file size
. ./isis_setup.sh
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HOME/projects/base_system/lib/

num=$(echo $file | perl -pi -e "s#^.*?AS(\d+).*?\$#\$1#g") # from dir/AS17-M-0305... get the value '16'
prefix=$(echo $file | perl -pi -e "s#^.*\/##g" | perl -pi -e "s#^.*?(AS\d+-M-\d+).*?\$#\$1#g") # get AS17-M-0305
cub=$cubeDir/$prefix.cub
if [ ! -e "$cub" ]; then echo ERROR: File $cub does not exist; exit; fi

# Fix the time in the sub1 cube by using the time from the sub4 cube
sub4cub=$(ls apollo_metric/cubes/a$num/sub4_cubes/$prefix*cub)
sub4time=$($ISISROOT/bin/catlab from=$sub4cub | grep -A 10 "Group = Instrument" | grep StartTime | awk '{print $3}')
$ISISROOT/bin/editlab from=$cub option=modkey grpname=Instrument keyword=StartTime value=$sub4time

# Spice init on the cube
$ISISROOT/bin/spiceinit from=$cub

# Get the isis_adjust file
isis_adjust=$(ls isis_adjust_sol_20110919/$prefix*)

echo cub is $cub
echo adjust is $isis_adjust
echo mpp is $mpp

currDir=$(pwd)
outDir=$prefix
rm -rfv ./$outDir
mkdir -p ./$outDir

mkdir -p $drgDir
finalTif=$drgDir/$prefix.tif

# If the tif obtained after orthoproject exists, then don't orthoproject again
if [ -e $finalTif ]; then 
    echo "File $finalTif exists, will not extract it again"
else
    # Orthoproject on individual tiles in the list of tiles
    ls DEM_tiles_sub4/*tif | parallel -P $numProc -u "cd $currDir; ./orthoproject_cube_parallel.sh $ORTHOPROJECT {} $cub $isis_adjust $mpp $outDir"
    
    # Combine the output files into one virtual image
    vrtFile=$outDir/output.tif
    gdalbuildvrt $vrtFile $outDir/*tif

    # Create a proper image from the virtual image
    gdal_translate -co compress=lzw $vrtFile $finalTif
    echo Created file $drgDir/$prefix.tif
fi

#rm -fv $cub
rm -rfv ./$outDir
