%How to deal with CCD artifacts:
%
%1. Find the average disparity:
%   g=a100                      
%   qsub -N $g -l select=1:ncpus=8 -l walltime=15:00:00 -W group_list=s1219 \
%   -j oe -m n -- $(pwd)/driver.sh $(pwd)/$g                          
%
%   The average disparities will go to dx.txt and dy.txt in some subdirectories.
%
%2. Plot the average disparities for a set of runs using find_ccds.m. ...
%   Manually throw away the noisy ones. At the end, the CCD jumps in x and in y
%   will be saved to text files.
%
%3. Hard-code the obtained values in wv_correct.cc.
   
   
  