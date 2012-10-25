#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Compare the sizes of files in two directories
  
  if (scalar(@ARGV) < 2){
    print "Usage: $0 dir1 dir2\n";
    exit(0);
  }

  my $dir1 = $ARGV[0];
  my $dir2 = $ARGV[1];
  my $size1 = parse(split("\n", qx(ls -l $dir1/*tif)));
  my $size2 = parse(split("\n", qx(ls -l $dir2/*tif)));

  foreach my $key (keys %$size1){
    if ( ! exists $size2->{$key}){
      print "ERRROR: Could not find file starting with $key in $dir2\n";
      exit(1);
    }
    print $key . " " . $size1->{$key} . " " . $size2->{$key} . " " . $size1->{$key}/$size2->{$key} . "\n";
  }
}

sub parse{
  
  my (%hash);
  my $count = 0;
  foreach my $line (@_){
    $line =~ s/\n//g;
    next unless ($line =~ /(AS1\d-M-\d+)/);
    my $key = $1;
    $count++;
    my @vals = split(" ", $line);
    $hash {$key} = $vals[4]; # size
    #print "--$key--$hash{$key}--\n";
  }
  
  return \%hash;
}
