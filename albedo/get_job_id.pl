#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Fcntl qw(:flock SEEK_END); # import LOCK_* and SEEK_END constants

MAIN:{

  # Given an integer maxNum, return one number from 0 to maxNum - 1.
  # Repeated calls to this script return different numbers, until
  # all numbers are exhausted. File locking is used, in case this script
  # is called simultaneously by several callers.
  
  if (scalar(@ARGV) < 3){
    print "Usage: $0 maxNum dirName callerMachine\n";
    exit(0);
  }

  my $maxNum        = shift @ARGV;
  my $dirName       = shift @ARGV;
  my $callerMachine = shift @ARGV;

  # Init all jobs as not done
  my %doneJobs;
  for (my $count = 0; $count < $maxNum; $count++){
    $doneJobs{$count} = 0;
  }
  
  # Open the jobs file for reading/writing with a lock so that only
  # one process can modify it at a time. Throw an error if a job was
  # done more than once.
  my (@doneJobs, %duplicateTracker);
  my $doneJobsFile = "$dirName/doneJobs.txt";
  open (JFILE,"+< $doneJobsFile") or die "Cannot open $doneJobsFile.\n";
  flock(JFILE, LOCK_EX) or die "Cannot lock $doneJobsFile!\n";
  #print "Will sleep 2;\n"; sleep 2; # for debugging
  @doneJobs = <JFILE>;
  seek(JFILE, 0, 0); truncate(JFILE, 0); # Wipe the file

  foreach my $line (@doneJobs){
    next unless ($line =~ /^(\d+)\s+/);
    my $key = $1;
    if (exists $duplicateTracker{$key}){
      print "Error: Duplicate key: $key\n";
      exit(1);
    }
    $doneJobs{$key}         = 1;
    $duplicateTracker{$key} = 1;
  }

  my $date = qx(date); $date =~ s/\s*$//g;

  my $id = -1; # Will return -1 if ran out of jobs to do
  foreach my $key (keys %doneJobs){
    if ($doneJobs{$key} == 0){
      push(@doneJobs, "$key $callerMachine $date\n");
      print JFILE join("", @doneJobs);
      print "Job: $key $callerMachine $date\n"; # For debugging
      $id = $key;
      last;
    }
  }
  print "jobID=$id\n";
  close(JFILE);
}

