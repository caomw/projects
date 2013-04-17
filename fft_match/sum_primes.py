#!/usr/bin/python

import math, sys, time
import socket
import pp

def isnum(n):
    """Returns True if n is num and False otherwise"""
    #host = socket.gethostname()
    #print("now in isnum on ", host)
    #time.sleep(1)
    #return True
    #return str(n)
    return n

#     if not isinstance(n, int):
#         raise TypeError("argument passed to is_num is not of 'int' type")
#     if n < 2:
#         return False
#     if n == 2:
#         return True
#     max = int(math.ceil(math.sqrt(n)))
#     i = 2
#     while i <= max:
#         if n % i == 0:
#             return False
#         i += 1
#     return True

def sum_nums(n):
    """Calculates sum of all nums below given integer n"""
    #print("now in sum_nums")

    ans = 0
    for x in range(n):
        ans = ans + isnum(x)

# print """Usage: python sum_nums.py [ncpus]
#     [ncpus] - the number of workers to run in parallel,
#     if omitted it will be set to the number of processors in the system
# """

print("now in main")
#ppservers = ("pfe25",)
ppservers = ("pfe25:12001",)
#ppservers = ("pfe25",)
#ppservers=("0.0.0.0:12001",)
#js = pp.Server(ppservers=ppservers) #Creates job server
#print 'Detected', js.get_ncpus(), 'workers'
#sys.exit(0)

# # tuple of all parallel python servers to connect with
# #ppservers = ("pfe25",) #, "pfe25")
# ppservers = ("0.0.0.0:12001",)#, "pfe25")

# #ppservers = ("10.0.0.1",)

num = 1
if len(sys.argv) > 1:
  num = int(sys.argv[1])

# #    ncpus = int(sys.argv[1])
# #     # Creates jobserver with ncpus workers
# #     job_server = pp.Server(ncpus, ppservers=ppservers)
# # else:
# #     # Creates jobserver with automatically detected number of workers
job_server = pp.Server(ppservers=ppservers, socket_timeout = 1000000)
print "Starting pp with", job_server.get_ncpus(), "workers"

# # Submit a job of calulating sum_nums(100) for execution.
# # sum_nums - the function
# # (100,) - tuple with arguments for sum_nums
# # (isnum,) - tuple with functions on which function sum_nums depends
# # ("math",) - tuple with module names which must be imported before sum_nums execution
# # Execution starts as soon as one of the workers will become available
job1 = job_server.submit(sum_nums, (num,), (isnum,),
                         ("math","sys", "time", "socket") # module dependencies
                         )

# # Retrieves the result calculated by job1
# # The value of job1() is the same as sum_nums(100)
# # If the job has not been finished yet, execution will wait here until result is available
result = job1()
print "Sum of nums below ", num, " is", result

# # start_time = time.time()
# # # The following submits 8 jobs and then retrieves the results
# # inputs = (100000, 100100, 100200, 100300, 100400, 100500, 100600, 100700)
# # jobs = [(input, job_server.submit(sum_nums,(input,), (isnum,), ("math",))) for input in inputs]
# # for input, job in jobs:
# #     print "Sum of nums below", input, "is", job()
# # print "Time elapsed: ", time.time() - start_time, "s"
# # job_server.print_stats()
