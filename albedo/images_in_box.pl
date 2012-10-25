#!/usr/bin/perl
use strict;	   # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use List::Util qw(min max);
MAIN:{
  
  my $makeCache = 0;

  if ( !$makeCache && scalar(@ARGV) < 5 ){
    print "Usage: $0 cacheFile west east south north\n";
    exit(1);
  }elsif ($makeCache && scalar(@ARGV) < 1){
    print "Usage: $0 DIM_DIR\n";
    exit(1);
  }

  my ($cacheFile, $west_in, $east_in, $south_in, $north_in);
  if (!$makeCache){
    $cacheFile = shift @ARGV;
    foreach my $v (@ARGV){ $v =~ s/,//g; } # get rid of commas
    ($west_in, $east_in, $south_in, $north_in) = splice @ARGV, 0, 4;
  }

  my $count = 0;
  my @lines;
  if ($makeCache){
    my $dimDir = $ARGV[0];
    @lines = <$dimDir/*tif>;
  }else{
    open(FILE, $cacheFile);
    @lines = <FILE>;
    close(FILE);
  }

  foreach my $line (@lines){

    $count++;
    $line =~ s/\n//g;
    #print "$line\n";
    #next;
    #print "Line is $line\n";

    if ($makeCache){
      my $data = qx(gdalinfo $line);
      if ($data !~ /Upper Left\s*\(\s*(.*?)\s*,\s*(.*?)\s*\).*?Lower Right\s*\(\s*(.*?)\s*,\s*(.*?)\s*\)/s){
        print "No match in $data\n";
        exit(1);
      }
      my ($west, $north, $east, $south) = ($1, $2, $3, $4);
      print "1 $line $west, $east, $south, $north\n";
      next;
    }

    $line =~ s/,//g;
    my @v = split(/\s+/, $line);
    my ($file, $west, $east, $south, $north) = ($v[1], $v[2], $v[3], $v[4], $v[5]);
    if ( max($west_in, $west) < min($east_in, $east) &&
         max($south_in, $south) < min($north_in, $north)
       ){
      print "$file\n";
    }else{
      #print "no match $file\n";
    }
  }
  
}

