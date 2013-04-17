#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Cwd;
use List::Util qw[min];
undef $/;          # read one whole file in one scalar

# Run acuppc on a set of tests in paralel on multiple machines and
# report a list of successes and failures.
# See the file /home/olegalex/bin/run_tests.conf for a configuration file.
MAIN:{

  if (scalar(@ARGV) < 1){
    print "Usage: $0 run_tests.conf\n";
    exit(1);
  }

  print "Starting ...\n";

  my $binPath = set_bin_path();
  my $baseDir = getcwd;
  $baseDir    =~ s/\/*\s*$//g;

  my $jobFile = $ARGV[0];
  my ($willRecompile, $sandbox, $loxim_mode, $runDirs, $machines, $numCPUs)
     = parse_job_file($jobFile);

  if ( $willRecompile ){
    recompile($baseDir, $sandbox, $loxim_mode);
  }

  # When launching runs, first start the ones which take longest.
  my $reportFile = "output.txt";
  my $prevRunsTAT = read_report($reportFile);

  mark_all_as_not_started($baseDir, $runDirs, $machines);
  my $numRuns = scalar(@$runDirs);

  # Run a loop until all jobs are finished
  my %dispatchedCount;
  while (1){

    my ($numDone, %numRunning, @notStarted);
    get_status_of_all($baseDir, $runDirs, $machines,        # inputs
                      \$numDone, \%numRunning, \@notStarted # outputs
                     );
    last if ($numDone == $numRuns); # Finished

    my $numNotStartedJobs = scalar(@notStarted);

    # Need this logic to put the runs which we already attempted to start
    # to the end of the queue and the runs which take longest to the top
    # of the queue.
    my %notStartedHash;
    foreach my $job (@notStarted){
      my $prevTAT = 0;
      $prevTAT = $prevRunsTAT->{$job} if (exists $prevRunsTAT->{$job});
      if (exists $dispatchedCount{$job}){
        $notStartedHash{$job} = $dispatchedCount{$job} - $prevTAT/1000;
      }else{
        $notStartedHash{$job} = -$prevTAT/1000;
      }
    }

    my @availableCPUs = get_available_CPUs($machines, $numCPUs, \%numRunning);
    my $numAvailableCPUs = scalar (@availableCPUs);

    my $totalNumRunning = 0;
    foreach my $key (keys %numRunning){
      $totalNumRunning += $numRunning{$key};
    }
    print "Not started: $numNotStartedJobs. Running: $totalNumRunning. " .
       "Num available CPUs: $numAvailableCPUs.\n";

    if ( $numNotStartedJobs    == 0 || # no more runs to start
         $numAvailableCPUs == 0 ){ # no available CPUs
      sleep 5; # Wait for jobs to complete
      next;
    }

    my $numToRun = min($numNotStartedJobs, $numAvailableCPUs);
    my $c = 0;
    foreach my $job (sort { $notStartedHash{$a} <=> $notStartedHash{$b} }
                              keys %notStartedHash ){
      dispatchRun($job, $baseDir, $availableCPUs[$c],
                  $binPath, $sandbox, $loxim_mode
                 );
      $dispatchedCount{$job}++; # Count how many times a job was started
      $c++;
      last if ($c >= $numToRun);
      sleep 1;
    }

  }

  # Print the report
  write_report($reportFile, $baseDir, $runDirs);

  # Send the report
  my $user = qx(whoami);
  $user =~ s/\s*$//g;
  system("mailx $user -s 'Status of tests' < $reportFile");

}

sub set_bin_path{

  # Get this script's dependencies from the directory where the script is located

  my $binPath = $0;
  if ($binPath !~ /^\//){
    $binPath = getcwd . "/" . $binPath;
  }

  # Wipe program name, keep just the path
  $binPath =~ s!^(.*)/.*$!$1!g;

  push(@INC, $binPath);
  require 'test_utils.pl';

  return $binPath;
}
