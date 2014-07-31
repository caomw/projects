%How to deal with CCD artifacts:
%
%1. Find the average disparity:
%   g=a100                      
%   qsub -N $g -l select=1:ncpus=8 -l walltime=15:00:00 -W group_list=s1219 \
%   -j oe -m n -- $(pwd)/driver.sh $(pwd)/$g                          
%
%   The average disparities will go to dx.txt and dy.txt in some subdirectories.
%
%   Need to ensure that in homography_rectification() in
%   src/asp/Core/InterestPointMatching.cc, the cropping output_bbox is turned off
%   to not shift the CCD artifacts from their location.
%
%2. Plot the average disparities for a set of runs with given TDI and
%   scan direction using find_ccds.m.  Manually throw away the noisy
%   ones. At the end, the CCD jumps in x and in y will be saved to
%   text files. The auxiliary tools gen_scandir.m and plot_ccds.m
%   can help with plotting.
%
%3. Hard-code the obtained values in wv_correct.cc.
   
   
  