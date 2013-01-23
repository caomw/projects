#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  my @files = </data/docroot/albedo/albedo_10mpp_06_20_2012/error/*tif>;
  foreach my $file (@files){
    next unless ($file =~ /^.*tile_(\d+)([a-z]+)(\d+)([a-z]+).tif/i);
    my $nfile = sprintf("AMCAM_%03d%s%02d%s%s", $1, $2, $3, $4, "E.tif");
    my $cmd="mv -iv $file /data/docroot/albedo/AMCAM_0001/data/$nfile\n";
    print qx($cmd) . "\n";
  }
  
  
}
