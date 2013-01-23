#!/bin/bash

grep right output-run6_sub16_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > right_sub16.txt

grep right output-run6_sub4_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > right_sub4.txt

grep left output-run6_sub16_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > left_sub16.txt

grep left output-run6_sub4_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > left_sub4.txt


grep -E "left|right" output-run7_sub16_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > all7_sub16.txt

grep -E "left|right" output-run7_sub4_25deg_1390_1391.txt |g vector| print_col.pl 4 6 | perl -pi -e "s#Vector\d+##ig" | perl -pi -e "s#[\(\)]##ig" | perl -pi -e "s#[, ]+# #g" > all7_sub4.txt
