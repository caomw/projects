#!/usr/bin/python

import sys
import os
import re # Perl-style regular expressions
import time
from Queue import Queue
from threading import Thread

class Worker(Thread):
    """Thread executing tasks from a given tasks queue"""
    def __init__(self, tasks):
        Thread.__init__(self)
        self.tasks = tasks
        self.daemon = True
        self.start()

    def run(self):
        while True:
            func, args, kargs = self.tasks.get()
            try:
                func(*args, **kargs)
            except Exception, e:
                print e
            finally:
                self.tasks.task_done()

class ThreadPool:
    """Pool of threads consuming tasks from a queue"""
    def __init__(self, num_threads):
        self.tasks = Queue(num_threads)
        for _ in range(num_threads): Worker(self.tasks)

    def add_task(self, func, *args, **kargs):
        """Add a task to the queue"""
        self.tasks.put((func, args, kargs))

    def wait_completion(self):
        """Wait for completion of all the tasks in the queue"""
        self.tasks.join()

if __name__ == '__main__':

    def wait_delay(d, t):
        print('start thread %d %d' % (d, t) )
        time.sleep(5)

    pool = ThreadPool(3)

    for d in range(10):
        t = d + 1
        pool.add_task(wait_delay, d, t)

    pool.wait_completion()


# def myfunc(i):
#     print "sleeping 5 sec from thread %d" % i
#     time.sleep(5)
#     print "finished sleeping from thread %d" % i

# for i in range(10):
#     t = Thread(target=myfunc, args=(i,))
#     t.start()
