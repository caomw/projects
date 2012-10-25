#!/bin/bash

cmd="$HOME/Python-2.7.2/build/bin/python $HOME/bin/gsutil-mp/gsutil"
for ((i = 0; i < 20; i++)); do
    $cmd rm -f gs://olegtest$i/*
    $cmd rb gs://olegtest$i
done

# This is a big one
$cmd rm -f gs://olegtest
$cmd rb gs://olegtest
