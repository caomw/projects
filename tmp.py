#!/usr/bin/python

import sys
import os
import re # Perl-style regular expressions

installdir = 'base_system'
superlu_la = installdir + '/lib/libsuperlu.la'
blas_la = installdir + '/lib/libblas.lax'
if os.path.exists(superlu_la):

    lines = []
    with open(superlu_la,'r') as f:
        lines = f.readlines()

    with open(blas_la,'w') as f:
        for line in lines:
            line = re.sub('libsuperlu', 'libblas', line)
            line = re.sub('dlname=\'.*?\'', 'dlname=\'libblas.so\'', line)
            line = re.sub('library_names=\'.+?\'', 'library_names=\'libblas.so\'', line)
            line = re.sub('dependency_libs=\'.*?\'', 'dependency_libs=\' -L' + installdir + '/lib -lsuperlu -lm\'', line)

            f.write( line )
