#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  my $cmd = join(" ", @ARGV);
  $cmd =~ s/\s*$//g;
  @ARGV = split(" ", $cmd);
  
  my $last = $ARGV[ scalar(@ARGV) - 1 ];
  print "last is: $last\n";
  if ( -e $last){
    print "File: $last exists, skipping.\n";
    exit(0);
  }

  print "Will run: $cmd\n";
  qx($cmd);
}
