#!/bin/bash

ls sub64_cubes_45deg/*cub | parallel ./run_pair.pl 64 45 run1 stereo.default {}




