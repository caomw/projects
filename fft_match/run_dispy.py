#!/usr/bin/python

import sys
import os
import re # Perl-style regular expressions

def local_compute(n):
    #print("r")
    import time, socket
    #time.sleep(1)
    host = socket.gethostname()
    return (host, n)

if __name__ == '__main__':
    import dispy, random
    cluster = dispy.JobCluster(local_compute,  nodes=['10.150.27.22', '10.150.27.23'])
    jobs = []
    for n in range(20):
        job = cluster.submit(2)
        #job = cluster.submit(random.randint(5,20))
        job.id = n
        jobs.append(job)

    print("p")
    #cluster.wait()
    for job in jobs:
        print("q")
        host, n = job()
        print '%s executed job %s at %s with %s' % (host, job.id, job.start_time, n)
        # other fields of 'job' that may be useful:
        # print job.stdout, job.stderr, job.exception, job.ip_addr, job.start_time, job.end_time
    cluster.stats()
