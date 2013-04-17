#!/usr/bin/python

import math, sys, time
import pp

def isprime(n):
    """Returns True if n is prime and False otherwise"""
    if not isinstance(n, int):
        raise TypeError("argument passed to is_prime is not of 'int' type")
    if n < 2:
        return False
    if n == 2:
        return True
    max = int(math.ceil(math.sqrt(n)))
    i = 2
    while i <= max:
        if n % i == 0:
            return False
        i += 1
    return True

def sum_primes(n):
    """Calculates sum of all primes below given integer n"""
    return 1
#     time.sleep(10)
#     host = socket.gethostname()
    #print("now in isnum on ", host)
    #return host
    #return sum([x for x in xrange(2,n) if isprime(x)])

# print """Usage: python sum_primes.py [ncpus]
#     [ncpus] - the number of workers to run in parallel,
#     if omitted it will be set to the number of processors in the system
# """

# tuple of all parallel python servers to connect with
ppservers = ("pfe5:12001",)
job_server = pp.Server(ppservers=ppservers)
start_time = time.time()

# The following submits 8 jobs and then retrieves the results
#inputs = (100000, 100100, 100200, 100300, 100400, 100500, 100600, 100700)
inputs=range(60)
jobs = [(input, job_server.submit(sum_primes,(input,), (isprime,),
                                  ("math","math","sys", "time",
                                   "socket"))) for input in inputs]
for input, job in jobs:
    print "Sum of primes below", input, "is", job()

print "Time elapsed: ", time.time() - start_time, "s"
job_server.print_stats()
