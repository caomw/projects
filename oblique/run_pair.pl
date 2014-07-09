#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings

MAIN:{

  if (scalar(@ARGV) < 1){
    print "Usage: $0 cub\n";
    exit(0);
  }

  print "$0 "; foreach my $arg (@ARGV){ print "$arg "; } print "\n";
  
  my $cub = $ARGV[0];
  
  my $sfile   = "stereo.default";

  my $index = 0;
  if ($cub =~ /^.*?AS\d+-M-(\d+)/){ $index = $1; }
  
  my $expr = $cub; $expr =~ s/\/.*?$//g;
  my @files = <$expr*/*cub>;

  my $rev = "";
  if ($cub =~ /(REV\d+)/){
    $rev = $1;
  }else{
   print "Could not match REV in $cub\n"; 
   exit(1);
 }
  
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

  my $diff = $rindex - $lindex;
  if ($diff <= 0 || $diff > 3){
    print "Indices are too different: $lindex $rindex. Skipping.\n";
    exit(1);
  }

  my $left_index2 = $left;
  if ($left =~ /^.*?(AS\d+-M-\d+)/){
    $left_index2 = $1;
  }else{
    print "Cannot match: $left\n";
    exit(1);
  }
  
  my $right_index2 = $right;
  if ($right =~ /^.*?(AS\d+-M-\d+)/){
    $right_index2 = $1;
  }else{
    print "Cannot match: $right\n";
    exit(1);
  }
  
  my $cmd;
  my $dir   =  $rev . "_" . $left_index2 . "_" . $right_index2;
  my $cache = "$dir/cache";
  my $pref  = "$dir/run";

#  my $DEM = "$pref-DEM.tif";
#   if ( -e  $DEM){
#     print "File: $DEM exists, skipping!\n";
#     exit(1);
#   }

  qx(mkdir -p $dir);

  my $ofile = "$dir/output.txt";
  
  $cmd = "uname -n > $ofile 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

  # Not thread safe!
  #$cmd = "ulimit -S -c 0; . isis_setup.sh; spiceinit from=$left pck tspk cksmithed=true spksmithed=true >> $ofile 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";
  #my $left_proj = $left;
  #$left_proj =~ s/^.*?\/(.*?)\.cub/$proj_dir\/$1.map.cub/g;
#   if (! -f $left_proj){
#     $cmd = "ulimit -S -c 0; . isis_setup.sh; time_run.sh cam2map from=$left to=$left_proj pixres=mpp resolution=$mpp >> $ofile 2>&1";
#     print "$cmd\n";
#     print qx($cmd) . "\n";
#   }
  
  #$cmd = "ulimit -S -c 0; . isis_setup.sh; spiceinit from=$right pck tspk cksmithed=true spksmithed=true >> $ofile 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";
  #my $right_proj = $right;
  #$right_proj =~ s/^.*?\/(.*?)\.cub/$proj_dir\/$1.map.cub/g;
#   if (! -f $right_proj){
#     $cmd = "ulimit -S -c 0; . isis_setup.sh; time_run.sh cam2map from=$right to=$right_proj pixres=mpp resolution=$mpp >> $ofile 2>&1";
#     print "$cmd\n";
#     print qx($cmd) . "\n";
#   }
  
  my $node_file;
  if ( exists $ENV{"PBS_NODEFILE"} ){
    $node_file = $ENV{"PBS_NODEFILE"};
  }else{
    $node_file = "$dir/local.txt";
    qx(echo localhost > $node_file);
  }

  my $num_proc = qx(cat /proc/cpuinfo | grep processor | wc);
  $num_proc =~ s/^\s*(\d+).*?\n.*?$/$1/g;
  my $opts = "-s $sfile $left $right $pref --cache-dir $cache --disable-fill-holes --alignment-method homography --subpixel-mode 2 --corr-timeout 200  --max-valid-triangulation-error 80 --universe-center Zero --near-universe-radius 1730400 --far-universe-radius 1745400"; # -7000 and +8000 variation from datum of 1737400
  # temporary!!!
  #if (-f $dem){
  #$cmd = "ulimit -S -c 0; . isis_setup.sh; time_run.sh parallel_stereo --job-size-h=1024 --job-size-w=1024 --processes $num_proc --threads-single $num_proc --threads-multi 1 --nodes-list $node_file $opts >> $ofile 2>&1";
  #}else{
  #$cmd = "ulimit -S -c 0; . isis_setup.sh; time_run.sh stereo_tri $opts >> $ofile 2>&1";
  #}

  # temporary!!!
  #print "$cmd\n";
  #print qx($cmd) . "\n";
  
  my $point_cloud = "$pref-PC.tif";
  if ( ! -e  $point_cloud){
    print "Failed to get point cloud $point_cloud.\n";
    exit(1);
  }

  my $ppd = "0.0019786731730117"; # 60mpp
  if ($rev =~/rev35/i){
    $ppd *= 4.0/3.0; # 80 mpp
  }
  
  $cmd = "point2dem --fsaa 3 --tr $ppd --nodata-value -32767 -r moon $pref-PC.tif >> $ofile 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

#   # temporary!!!
  $cmd = "grassfirealpha $pref-DEM.tif >> $ofile 2>&1";
  print "$cmd\n";
  print qx($cmd) . "\n";

  #$cmd = "~/bin/show_dems.pl $pref-DEM_v2 $pref-DEM.tif >> $ofile 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";

  #$cmd = "rm -fv *match $pref-[a-rt-zA-CE-OQ-Z]* $pref-D.tif >> $ofile 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";
  
  #$cmd = "remote_copy.pl $pref-DEM.tif $machine >> $ofile 2>&1";
  #print "$cmd\n";
  #print qx($cmd) . "\n";

}
