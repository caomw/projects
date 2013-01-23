#!/bin/bash

# Make cubes 4 times smaller
reduce from=sub4_cubes_25deg/AS15-M-0754.lev1.cub to=AS15-M-0754_sub4.cub sscale=4
reduce from=sub4_cubes_25deg/AS15-M-0755.lev1.cub to=AS15-M-0755_sub4.cub sscale=4


stereo sub4_cubes_25deg/AS15-M-0754.lev1.cub sub4_cubes_25deg/AS15-M-0755.lev1.cub res1
stereo AS15-M-0754_sub4.cub AS15-M-0755_sub4.cub res4/out

hp time stereo -s stereo_parabola.default sub4_cubes_45deg/AS15-M-1430.lev1.cub sub4_cubes_45deg/AS15-M-1431.lev1.cub data/res-par-45-30-31-sub4/out > output_par-45-30-31-sub4.txt 2>&1&

