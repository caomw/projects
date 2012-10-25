#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{
  
  if (scalar(@ARGV) < 1){
    print "Usage: $0 albedoDir\n";
    exit(1);
  }
  my $dir = $ARGV[0];

  open(FILE, "<$dir/imagesList.txt");
  foreach my $line (<FILE>){
    $line =~ s/\n//g;
    my @vals = split(/\s+/, $line);
    #print "$line\n";
    #print join("----", @vals) . "\n";
    
    next unless (scalar(@vals) >= 6);
    my $img = $vals[1];
    my $x   = ($vals[2] + $vals[3])/2.0;
    my $y   = ($vals[4] + $vals[5])/2.0;
    $img =~ s/^.*\///g;
    $img =~ s/\..*?$//g;

    open(FILE_EX, "<", "$dir/exposure/$img" . "_exposure.txt");
    my @ex = <FILE_EX>;
    close(FILE_EX);
    my $last = $ex[scalar(@ex) - 1];
    $last =~ s/\s*$//g;

    #print "$img $x $y $last\n";
    print "$x $y $last\n";
    
  }

}
