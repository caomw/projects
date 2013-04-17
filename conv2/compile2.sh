#!/bin/bash

cd /home/oalexan1/projects/StereoPipeline_debug/src/asp/Tools
rm -fv stereo_corr .libs/lt-stereo_corr stereo_corr.o

touch stereo_corr.cc;

time_run.sh g++ -c stereo_corr.cc -I/home/oalexan1/projects/base_system/include/boost-1_52

time_run.sh g++ -L/home/oalexan1/projects/base_system/lib -lboost_date_time-mt-1_52 -lboost_filesystem-mt-1_52 -lboost_iostreams-mt-1_52 -lboost_program_options-mt-1_52 -lboost_system-mt-1_52 -lboost_thread-mt-1_52 -llapack -lblas -lgfortran -o stereo_corr stereo_corr.o

cd /home/oalexan1/projects/conv2

for ((i = 0; i < 10; i++)); do
    /home/oalexan1/projects/StereoPipeline_debug/src/asp/Tools/stereo_corr
done
