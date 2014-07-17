#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

# Print how many files are there for each TDI in given list
MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 list.txt\n";
    exit(0);
  }

  my $list = $ARGV[0];
  open(FILE, "<$list");
  my @lines = <FILE>;
  close(FILE);

  my %ccds;
  foreach my $line (@lines){
    my @vals = split(/\s+/, $line);
    next unless (scalar(@vals) >= 3);
    my $tdi = $vals[2];
    #print "--$tdi--\n";
    $ccds{$tdi}++;
  }

  foreach my $tdi (sort { $a <=> $b} keys %ccds){
    print "$tdi $ccds{$tdi}\n";
  }
}
