#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  my @files = <sub4_cubes_25deg/*cub>;

  foreach my $file (@files){
    #print "--- $file --- \n";

    if ($file !~ /^(.*?M-)(\d+)(.*?)$/){
      print "Problem with $file\n";
      exit(0);
    }
    my ($a, $b, $c) = ($1, $2, $3);

    my $d = $b + 1;

    if ($d =~ /^\d\d\d$/){
      $d = "0" . $d;
    }
    
    my $nfile = $a . $d . $c;
    if ( ! -e $nfile ){
      #print "Missing $nfile\n";
      next;
    }
    
    #print "Good: $file $nfile\n";
    my $dir = "run3_sub4_25deg_" . $b . "_" . $d;
    my $dem = "$dir/img-DEM.tif";
    if ( -e $dem ){
      #print "---Good thing: $dem\n";
    }else{
      #print "Missing: $dem\n";
      #print "output-$dir.txt\n";
      print "qview $file $nfile\n";
    }
    
  }
  
  
}
