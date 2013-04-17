#!/usr/bin/python

import sys
import os
import re # Perl-style regular expressions

def wipe_existing_threads_arg(call):
    p = '--threads';
    while p in call:
        r = call.index(p)
        if r < len(call): del call[r] # rm '--threads'
        if r < len(call): del call[r] # rm value of '--threads'

call = ['a', 'b', '--threads', '9', 'xx', '--threads', '99', 'xuxa'];
print('array is ', call);

wipe_existing_threads_arg(call)

print('array is ', call);
