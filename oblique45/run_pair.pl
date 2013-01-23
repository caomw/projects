#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  # Must do source bashenv!
  
  if (scalar(@ARGV) < 5){
    print "Usage: $0 sub angle tag stereoFile index\n";
    exit(0);
  }

  print "$0 "; foreach my $arg (@ARGV){ print "$arg "; } print "\n";
  
  my $sub     = shift;
  my $angle   = shift;
  my $tag     = shift;
  my $sfile   = shift;
  my $index   = shift;
  my $machine = $ENV{"L2"};

  if ($index =~ /M-(\d+)/){
    # convert AS15-M-1473.lev1.cub into 1473
    $index = $1;
  }
  
  my $expr = "sub" . $sub . "_cubes" . "*" . $angle . "deg";

  my @files = <*$expr*/*cub>;

  my $pos = scalar(@files);
  my $count = -1;
  my $have_match = 0;
  foreach my $file (@files){
    $count++;
    if ($file =~ /AS\d+-M-(\d+)/){
      my $match = $1;
      if ($match == $index){
        print "Found match: $index $file\n";
        $pos = $count;
        $have_match = 1;
        last;
      }
    }
  }
  
  if (!$have_match){
    print "Could not find image with index: $index\n";
    exit(1);
  }

  if ( $pos + 1 >= scalar(@files)){
    print "Out of bounds. Skip index $index.\n";
    exit(1);
  }
  
  my $left  = $files[$pos];
  my $right = $files[$pos + 1];

  my ($lindex, $rindex);
  if ($left  =~ /AS\d+-M-(\d+)/){ $lindex = $1; }
  if ($right =~ /AS\d+-M-(\d+)/){ $rindex = $1; }

  if ($rindex != $lindex + 1){
    print "Non-consecutive indices: $lindex $rindex. Skipping.\n";
    exit(1);
  }

  my $cmd;
  my $dir   =  $tag . "_sub" . $sub . "_" . $angle . "deg_" . $lindex . "_" . $rindex;
  my $cache = "$dir/cache";
  my $pref  = "$dir/img";

#   my $DEM = "$pref-DEM.tif";
#   if ( -e  $DEM){
#     print "File: $DEM exists, skipping!\n";
#     exit(1);
#   }

  $cmd = "uname -n > output-$dir.txt 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

  $cmd = "ulimit -S -c 0; . isis_setup.sh; time_run.sh stereo  --corr-search -1000 -1000 1000 1000 --subpixel-mode 1 --alignment-method none -s $sfile $left $right $pref --cache-dir $cache >> output-$dir.txt 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

  my $point_cloud = "$pref-PC.tif";
  if ( ! -e  $point_cloud){
    print "Failed to get point cloud.\n";
    exit(1);
  }
  
  $cmd = "point2dem --nodata-value -32767 --threads 1 -r moon $pref-PC.tif >> output-$dir.txt 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

  $cmd = "show_dems.pl $pref-DEM.tif >> output-$dir.txt 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";
  
  #$cmd = "rm -fv *match $pref-[a-rt-zA-CE-OQ-Z]* $pref-D.tif >> output-$dir.txt 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";
  
  #$cmd = "remote_copy.pl $pref-DEM.tif $machine >> output-$dir.txt 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";

}
