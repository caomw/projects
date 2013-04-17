#!/usr/bin/python

import sys
import os
import re # Perl-style regular expressions
import time

from multiprocessing import Pool, Process, Value, Array

def f(x):
    print("val is ", x)
    #print('start process %d ' % x )
    time.sleep(5)
    #return x*x

if __name__ == '__main__':

    V = []
    for i in range(10):
        v = i, [i-1, i+1]
        V.append(v)

    pool = Pool(processes=4)              # start 4 worker processes
    pool.map(f, V)          # prints "[0, 1, 4,..., 81]"
    #print pool.map(f, range(10))          # prints "[0, 1, 4,..., 81]"
#    print pool.map(f, [arr])
#     result = pool.apply_async(f, [10])     # evaluate "f(10)" asynchronously
#     print result.get(timeout=1)           # prints "100" unless your computer is *very* slow
