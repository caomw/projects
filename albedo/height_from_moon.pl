#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Get a list from standard input. Keep only the items
  # satisfying the filters coming from file.
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 spaceraftpost.txt\n";
    exit(0);
  }

  open(FILE, "<$ARGV[0]");
  &parse(<FILE>);
  close(FILE);

}

sub parse{

  my $MR = 1737.4; # moon radius

  my %hash;
  foreach my $line (@_){
    $line =~ s/\n//g;
    next unless ($line =~ /(AS1\d-M-\d+).*?\s+(.*?)$/);
    my $key = $1; my $val = $2;

    my @a = split(" ", $val);
    if (scalar(@a) != 3){
      print "Need to have three values in $val\n";
      exit(0);
    }
    foreach my $v (@a){ $v =~ s/[,\(\)]//g; }
    my $dist = sqrt($a[0]*$a[0] + $a[1]*$a[1] + $a[2]*$a[2]) - $MR;
    print "$key $val --- $dist\n";
    #if ($dist <= 130){
    #print "$key $dist\n";
    #}
    
  }

}
