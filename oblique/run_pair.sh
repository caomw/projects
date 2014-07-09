#!/bin/bash

if [ "$#" -lt 2 ]; then echo Usage: $0 pwd cub; exit; fi

dir=$1
cub=$2
tag=run

if [ "$dir" != "" ]; then cd $dir; fi

source ~/.bashenv

export PATH=$HOME/projects/StereoPipeline/src/asp/Tools:$HOME/projects/visionworkbench/src/vw/tools:$HOME/projects/base_system/bin:$HOME/projects/packages/bin:$HOME/bin:$PATH

# Ensure we compile for merope
# rsync -avz $M:projects/StereoPipeline/ ~/projects/StereoPipeline2/; cd ~/projects/StereoPipeline2/; make -j 10

# Path for merope
v=$(stereo_fltr 2>&1 |grep -i "bin/sed" | perl -pi -e "s#\s##g")
if [ "$v" != "" ]; then
    export PATH=$HOME/projects/StereoPipeline2/src/asp/Tools:$HOME/projects/visionworkbench2/src/vw/tools:$HOME/projects/base_system/bin:$HOME/projects/packages/bin:$HOME/bin:$PATH
fi
    
export ASP_PYTHON_MODULES_PATH=$HOME/projects/BinaryBuilder/StereoPipelinePythonModules/lib64/python2.6/site-packages:$HOME/projects/BinaryBuilder/StereoPipelinePythonModules/lib64/python2.6/site-packages/GDAL-1.10.0-py2.6-linux-x86_64.egg/osgeo:$HOME/projects/BinaryBuilder/StereoPipelinePythonModules/lib
export PYTHONPATH=$ASP_PYTHON_MODULES_PATH
export LD_LIBRARY_PATH=$ASP_PYTHON_MODULES_PATH

./run_pair.pl $cub



