#!/usr/bin/env python

# findlitoverlaps_hist.py - This program takes some number of text files which are the output of ISIS hist, and extracts some relevant information.
#
# Copyright (C) 2012 Ross A. Beyer

import sys

for hist in sys.argv[1:]:
    f = open( hist, 'r')
    cube = None
    valid = 0
    lit = 0
    for line in f:
        if 'Cube:' in line: cube = line.split(':')[1].strip()
        if 'Valid Pixels:' in line: valid = line.split(':')[1].strip()
        if line.startswith('2,'): lit = line.split(',')[1].strip()
    f.close()
    if cube: print ','.join( (cube,str(lit),str(valid)) )
