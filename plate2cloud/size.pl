#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use IO::File;
$| = 1; # flush each line
MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 fileName\n";
    exit(1);
  }
  
  my $start = time;

  my $iter = 0;
  my $sum = 0;
  
  my $filename = $ARGV[0];
  my $fh = new IO::File($filename, "r") or die "could not open $filename: $!\n";
  while (my $line = $fh->getline()) { # read one line at a time, not all of them
    next unless ($line =~ /^\s*(\d+)\s/);
    $iter++;
    $sum += $1;

    if ($iter % 100000 == 0){
      my $diffTime = time - $start;
      print "Size is " . int($sum/1000000 + 0.5) . " MB, num lines is $iter\n";
    }
  }
  $fh->close();
  
  $sum /= 1000000;
  print "Total is: $sum MB\n";
}
