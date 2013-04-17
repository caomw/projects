#!/bin/bash
# __BEGIN_LICENSE__
#  Copyright (c) 2009-2012, United States Government as represented by the
#  Administrator of the National Aeronautics and Space Administration. All
#  rights reserved.
#
#  The NGT platform is licensed under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance with the
#  License. You may obtain a copy of the License at
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# __END_LICENSE__

# This script performs albedo reconstruction. It should be run as:
# ./reconstruct.sh settingsFile labelStr
# The results will go to albedo_$labelStr
# See the documentation in PhotometryTK/docs

if [ "$#" -lt 2 ]; then 
    echo Usage: $0 settingsFile labelStr
    exit
fi
settingsFile=$1
labelStr=$2

# Path to executables
PHOTOMETRY_TOOLKIT_PATH=$HOME/PhotometryTK
VISION_WORKBENCH_PATH=$HOME/visionworkbench
reconstruct="$PHOTOMETRY_TOOLKIT_PATH/build/src/tools/reconstruct"
image2qtree="$VISION_WORKBENCH_PATH/src/vw/tools/image2qtree"

# Output directory
resDir=albedo_$labelStr

updatePhase=1    # if to update the phase coefficients when performing iterations
updateExposure=0 # updating the exposure makes things worse so we turn it off for now
TAG="" # Use here AS15, AS16, or AS17 to do albedo only for a specific mission

# See if to run the script on multiple machines (such as a
# supercomputer) or just on the local machine. The value of
# PBS_NODEFILE needs to be a file name having the list of computing
# nodes to run the script on.
if [ "$PBS_NODEFILE" != "" ]; then useSuperComp=1; else useSuperComp=0; fi

# Validation
if [ ! -f "$settingsFile" ]; then echo "ERROR: File $settingsFile does not exist.";      exit; fi
if [ ! -x "$reconstruct"  ]; then echo "ERROR: Program $reconstruct is not executable."; exit; fi
if [ ! -x "$image2qtree"  ]; then echo "ERROR: Program $image2qtree is not executable."; exit; fi

imagesList="$resDir/imagesList.txt"
albedoTilesList="$resDir/albedoTilesList.txt"
options="-s $settingsFile -r $resDir -f $imagesList -t $albedoTilesList" 

# Parse some values from the settings file. Make sure to strip the comments
# as to not confuse the parsing.
NUM_PROCESSES=$(  cat $settingsFile | perl -pi -e "s/\#.*?\n/\n/g" | grep NUM_PROCESSES  | awk '{print $2}')
DRG_DIR=$(        cat $settingsFile | perl -pi -e "s/\#.*?\n/\n/g" | grep DRG_DIR        | awk '{print $2}')
MAX_NUM_ITER=$(   cat $settingsFile | perl -pi -e "s/\#.*?\n/\n/g" | grep MAX_NUM_ITER   | awk '{print $2}')
COMPUTE_ERRORS=$( cat $settingsFile | perl -pi -e "s/\#.*?\n/\n/g" | grep COMPUTE_ERRORS | awk '{print $2}')
UPDATE_HEIGHT=$(  cat $settingsFile | perl -pi -e "s/\#.*?\n/\n/g" | grep UPDATE_HEIGHT  | awk '{print $2}')
if [ "$NUM_PROCESSES"  = "" ]; then NUM_PROCESSES=1;  fi
if [ "$MAX_NUM_ITER"   = "" ]; then MAX_NUM_ITER=0;   fi
if [ "$COMPUTE_ERRORS" = "" ]; then COMPUTE_ERRORS=0; fi
if [ "$UPDATE_HEIGHT"  = "" ]; then UPDATE_HEIGHT=0;  fi

# Temporary fix: For robustness, rebuild the indices of images each time it is run to avoid
# invalid indices.
#rm -fv $DRG_DIR/index.txt $DEM_DIR/index.txt

# Wipe the results directory.
rm -rfv $resDir

refImage=$(ls $DRG_DIR/*.tif | head -n 1) # Need this to get the GeoReference
if [ "$refImage" = "" ]; then echo "Error: No images."; exit; fi

# Iteration 0:
# Take as input the box in which to compute the albedo, generate the
# list of DRG images intersecting that box, create the albedo tiles,
# and also the index files if missing.
overrideOptions="--initial-setup"
$reconstruct $options $overrideOptions -i $refImage
status=$?
# Must check the exit status and not continue if the above command failed
if [ "$status" -ne 0 ]; then exit; fi

# The files $imagesList and $albedoTilesList must exist after the initial setup run
if [ ! -f "$imagesList" ]; then echo "ERROR: File $imagesList does not exist."; exit; fi
if [ ! -f "$albedoTilesList"  ]; then echo "ERROR: File $albedoTilesList does not exist.";  exit; fi

# If $TAG is not empty, create the albedo only for the specified mission (AS15, AS16, AS17).
if [ "$TAG" != "" ]; then 
    cat $imagesList | grep $TAG > tmp.txt; cat tmp.txt > $imagesList
fi

#cat $imagesList | filter.pl badImages.txt -v > tmp.txt; cat tmp.txt > $imagesList

# Create the list of drg images and tiles as expected by reconstruct.cc.
DRG_FILES=$( cat $imagesList      | awk '{print $2}')
TILE_FILES=$(cat $albedoTilesList | awk '{print $2}')

numIter=$(perl -e "print 5 + 4*$MAX_NUM_ITER")
if [ "$numIter" = "" ]; then echo "The value of MAX_NUM_ITER is invalid"; exit; fi

# We need to do an extra iteration if we compute the error
if [ "$COMPUTE_ERRORS" -ne 0 ]; then ((numIter++)); fi;

# We need to do exactly 6 iterations if we update the height
if [ "$UPDATE_HEIGHT" -ne 0 ]; then numIter=6; fi;

for ((i = 1; i <= $numIter; i++)); do

    echo start step $i at $(date)
    
    # See if this is the last iteration
    if [ "$i" -eq "$numIter" ]; then isLastIter=1; else isLastIter=0; fi
    
    # If we have to compute the errors, we do it at the last iteration
    computeErrors=0
    if [ "$COMPUTE_ERRORS" -ne 0 ] && [ "$isLastIter" -ne 0 ]; then computeErrors=1; fi
    
    # If we have to compute the update the height, we do it at the last iteration
    updateHeight=0
    if [ "$UPDATE_HEIGHT" -ne 0 ] && [ "$isLastIter" -ne 0 ]; then updateHeight=1; fi

    # Enforce that iteration 10 uses same options as iteration 6, iteration 11 as 7, etc.
    # This because iterations 6, 10, 14,... update the exposure, while iterations
    # 7, 11, 15... update the phase coeffs, etc.
    # Also, iterations 1, 4, 6 are over images, iterations 2, 3, 5, 7, 9 are over tiles,
    # and iteration 8 combines the results over all times.
    rem=$i
    while [ $rem -gt 9 ]; do ((rem = rem - 4)); done
    if  [ $rem -eq 2 ] || [ $rem -eq 3 ] || [ $rem -eq 5 ] ||   \
        [ $rem -eq 7 ] || [ $rem -eq 9 ] ||                     \
        [ $computeErrors -ne 0 ] || [ $updateHeight -ne 0 ]; then
        # Iterate over albedo tiles
        VALS="$TILE_FILES"
    elif [ $rem -eq 8 ]; then
        # Combine the results from all tiles        
        VALS="$refImage"
    else
        # Iterate over input DRGs
        VALS="$DRG_FILES"
    fi
    overrideOptions=""
    if   [ $rem -eq 1 ]; then overrideOptions="--save-weights"; 
    elif [ $rem -eq 2 ]; then overrideOptions="--init-dem";                      
    elif [ $rem -eq 3 ]; then overrideOptions="--compute-weights-sum";                      
    elif [ $rem -eq 4 ]; then overrideOptions="--init-exposure";                 
    elif [ $rem -eq 5 ]; then overrideOptions="--init-albedo";                   
    elif [ $rem -eq 6 ] && [ $updateExposure -ne 0 ]; then overrideOptions="--update-exposure";               
    elif [ $rem -eq 7 ] && [ $updatePhase -ne 0 ]; then overrideOptions="--update-tile-phase-coeffs";      
    elif [ $rem -eq 8 ] && [ $updatePhase -ne 0 ]; then overrideOptions="--update-phase-coeffs";           
    elif [ $rem -eq 9 ]; then overrideOptions="--update-albedo";
    fi
    
    # The case when we compute errors needs to be handled a bit differently.
    if [ $computeErrors -ne 0 ]; then overrideOptions="--compute-errors"; fi
    
    # The last iteration.
    if [ "$isLastIter" -ne 0 ]; then overrideOptions="$overrideOptions --is-last-iter"; fi
    
    # The case when we update the height needs to be handled a bit differently.
    if [ "$updateHeight" -ne 0 ]; then overrideOptions="--update-height"; fi

    # Run all jobs for the current stage
    image="{}" # will be filled in by xarg
    run="$reconstruct $options $overrideOptions -i $image"
    # The 'xargs' and 'parallel' commands expect different formats
    if [ "$useSuperComp" -eq 1 ]; then
        currDir=$(pwd)
        echo $VALS | perl -pi -e "s#\s+#\n#g" | parallel -P $NUM_PROCESSES -u --sshloginfile $PBS_NODEFILE "cd $currDir; $run"
    else
        xargs="xargs -n 1 -P $NUM_PROCESSES -I {} $run"
        echo $VALS | perl -pi -e "s#\s+#\n#g" | $xargs
    fi

    echo end step $i at $(date)
    
done # end all iterations

if [ $useSuperComp -eq 0 ]; then 
    # Visualize the results t 1/4th the original resolution
    # The output goes to $shoDir
    shoDir=$resDir/albedo_sub4
    tilesVrt=$resDir/tilesVrt.tif
    mkdir $shoDir
    for i in $resDir/albedo/*.tif; do 
        echo $i;
        o=${i/albedo\//albedo_sub4\/} 
        echo "oFile = $o" 
        gdal_translate -outsize 25% 25% $i $o 
    done
    # Build a vrt as a workaround to the bug in image2qtree
    # which makes it not be able to handle more than 1000 images.
    gdalbuildvrt $tilesVrt $shoDir/*.tif
    $image2qtree -m kml $tilesVrt -o $shoDir
fi

