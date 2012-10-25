#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 albedoDir\n";
    exit(1);
  }
  my $dir = "$ARGV[0]/costFun";
  my @tiles = <$dir/tile*>;


  my %sum; 
  foreach my $tile (@tiles){
    #print "$tile\n";
    open(FILE, "<$tile");
    my @vals = <FILE>;
    my $count = 0;
    foreach my $val (@vals){
      $val =~ s/\n//g;
      #print $val . "\n";
      if (! exists $sum{$count}) { $sum{$count} = 0; }
      $sum{$count} += $val;
      $count++;
    }
    close(FILE);
  }

  foreach my $key ( sort { $a <=> $b } keys %sum){
    print "$key $sum{$key}\n";
  }


}

