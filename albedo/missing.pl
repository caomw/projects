#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Usage: cat file | missing.pl
  my %map;
  my $max = -1;
  foreach my $line (<STDIN>){
    next unless ($line =~ /jobID=(\d+).*?out\s+of\s+(\d+)/);
    my $num = $1;
    $max    = $2 unless ($max >= 0);
    if (exists $map{$num}){
      print "ERROR: $num is reptead\n";
    }
    $map{$num} = 1;
  }
  
  for (my $count = 0; $count < $max; $count++){
    if (! exists $map{$count}){
      print "Missing: $count\n";
    }
  }
}
