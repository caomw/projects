#!/bin/bash

set -x

pwd

rm -fv bug bug.o

touch bug.cc

g++ -c bug.cc -I/home/oalexan1/projects/base_system/include/boost-1_52

g++ \
    -o bug bug.o \
    -L/home/oalexan1/projects/base_system/lib \
    -lboost_thread-mt-1_52 \
    -lsuperlu \
    -llapack -lblas \

set +x

for ((i = 0; i < 100; i++)); do
    ./bug
done
