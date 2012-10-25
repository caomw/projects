#!/usr/bin/env python

from glob import glob
import sys, re

def addVec(v1, c, v2):
    return tuple([v1[i] + c * v2[i] for i in xrange(len(v1))])

posIn = file('spacecraftpos_prebundleadjust.txt', 'r')
pre = []
for line in posIn:
    index, x, y, z = line.split()
    match = re.match('^(AS1\d-M-\d+)', index)
    if not match: continue
    index = match.group(1)
    pos = (float(x), float(y), float(z))
    pre.append((index, pos))
posIn.close()

#print pre

post = []
for index, pos in pre:
    fileName = '../isis_adjust/%s.lev2.isis_adjust' % index
    dposFile = file(fileName, 'r')
    dposLines = dposFile.read().splitlines()
    x = dposLines[1].strip()
    y = dposLines[2].strip()
    z = dposLines[3].strip()
    dpos = (float(x), float(y), float(z))
    post.append((index, addVec(pos, 1e-3, dpos)))
dposFile.close()
#print post

posOut = file('spacecraftpos_postbundleadjust.txt', 'w')
for index, pos in post:
    posOut.write('%s %0.16g %0.16g %0.16g\n' % (index, pos[0], pos[1], pos[2]))
posOut.close()


