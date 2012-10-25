#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  # Estimate the error between two sets of 3D points
  if (scalar(@ARGV) < 2){
    print "Usage: $0 file1.txt file2.txt\n";
    exit(0);
  }

  my %vals0 = parse($ARGV[0]);
  my %vals1 = parse($ARGV[1]);
  my %error;
  foreach my $key (sort {$a cmp $b} keys %vals0){
      my @a = @{$vals0{$key}};

    if (! exists $vals1{$key} ){
      print "Error: missing value for $key\n";
      exit(1);
    }
    my @b = @{$vals1{$key}};
    #print "vals1 are $key " . join(" ", @a) . "\n";
    #print "vals2 are $key " . join(" ", @b) . "\n";
    
    my $err = sqrt(($a[0]-$b[0])**2 + ($a[1]-$b[1])**2 + ($a[2]-$b[2])**2);
    $error{$key} = $err;
    #print "Error is $err\n";
  }

  foreach my $key ( sort { $a cmp $b } keys %error ){
  #foreach my $key ( sort { $error{$a} <=> $error{$b} } keys %error ){
    my @a = @{$vals0{$key}};
    my @b = @{$vals1{$key}};
    print "Error is $key $error{$key}\n";# " . join(" ", @a) . " -- " . join(" ", @b)  . "\n";
  }
}

sub parse{
  
  my $file = shift;
  open(FILE, "<$file");

  my %hash;
  foreach my $line (<FILE>){
    $line =~ s/\n//g;
    next unless ($line =~ /(AS1\d-M-\d+).*?\s(.*?)$/);
    my ($key, $val) = ($1, $2);
    my @vals = split(/\s+/, $val);
    $hash{$key} = \@vals;
    #print "number of vals is " . scalar(@vals) . "\n";
    #print "--$1--$2--\n";
  }

  return %hash;
}
