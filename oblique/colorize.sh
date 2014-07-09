#!/bin/bash

if [ "$#" -lt 1 ]; then echo Usage: $0 DEM; exit; fi

dem=$1

source ~/.bashenv

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$HOME/projects/base_system/bin:$HOME/projects/packages/bin:$HOME/bin:$PATH

# Ensure we compile for merope
# rsync -avz $M:projects/StereoPipeline/ ~/projects/StereoPipeline2/; cd ~/projects/StereoPipeline2/; make -j 10

# Path for merope
v=$(stereo_fltr 2>&1 |grep -i "bin/sed" | perl -pi -e "s#\s##g")
if [ "$v" != "" ]; then
    export PATH=$HOME/projects/StereoPipeline2/src/asp/Tools:$HOME/projects/visionworkbench2/src/vw/tools:$HOME/projects/base_system/bin:$HOME/projects/packages/bin:$HOME/bin:$PATH
fi

shaded=${dem/.tif/_shaded.tif}
color=${dem/.tif/_color.tif}
hillshade $dem -o $shaded -e 25

colormap $dem -s $shaded -o $color --min -6367.520 --max 7990



