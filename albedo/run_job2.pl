#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Cwd;
use Time::HiRes qw(usleep);
MAIN:{

  # Ask the server for an image to run. Each image will be run on
  # exactly one machine.

  if (scalar(@ARGV) < 3){
    print "Error: Expecting at least 3 input arguments\n";
    exit(1);
  }
  
  my $iterFile  = shift @ARGV;
  my $pwd       = shift @ARGV;

  my $currMachine = qx(uname -n); $currMachine =~ s/\s*$//g;
  $currMachine =~ s/\..*?$//g;

  # To better distribute the jobs among machines
  my $val = rand(10);
  print "Will sleep for $val microseconds on $currMachine\n";
  usleep($val);
  
  my @images;
  open(FILE, "<$iterFile") || die "Error: Cannot read file $iterFile";
  @images = <FILE>; close(FILE);
  
  my $numImages = scalar(@images);
  #my $sscmd = "ssh byss $pwd/get_job_id.pl $numImages $pwd $currMachine 2>&1";
  #my $sscmd = "ssh byss \"cd $pwd; java JobClient $currMachine\" 2>/dev/null";
  my $sscmd = "cd $pwd; java JobClient $currMachine 2>&1";
  print "Command is $sscmd\n";

  # Do several attempts to get a job id (and therefore an image to run).
  my $jobID = -1;
  my $numAttempts = 1000;
  for (my $attempt = 1; $attempt <= $numAttempts; $attempt++){
    my $output = qx($sscmd);
    print "Result is\n$output\n";
    if ($output =~ /jobID\s*=\s*([\-\d]+)/){
      $jobID = $1;
      print "jobID=$jobID\n";
      last;
    }else{
      print "Error: Could not get a job id in attempt $attempt/$numAttempts at date: "
         . qx(date) . ". Will try again.\n";
      sleep 2;
    }
  }
  
  if ($jobID < 0){
    print "No more jobs!\n";
    exit(0);
  }

  if ($jobID >= scalar(@images)){
    print "Error: Out of bounds in run_job2.pl\n";
    exit(1);
  }
  
  my $currImage = $images[$jobID];
  if ($currImage =~ /^.*?\s([^\s]*?\.tif)\s.*?$/){
    $currImage = $1;
  }else{
    print "Error: Could not find image in: $currImage\n";
    exit(1);
  }
  print "Will run image: $currImage\n";
  
  my $cmd = join(" ", @ARGV);
  print "$cmd\n";

  if ( $cmd !~ /^(.*?\s-i\s+)[^\s]+(.*?)$/){
    print "Error: cannot find an image field in $cmd\n";
    exit(1);
  }
  $cmd = $1 . $currImage . $2;
  print "Will execute $cmd\n";
  
  # Execute the command for the current image
  system($cmd);
}

