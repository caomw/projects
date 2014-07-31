#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use File::Basename;
use File::Spec;

# Given all the files in the current directory,
# print a left and corresponding right ntf file
# which will make a suitable stereo pair, without
# the .ntf extensions.
MAIN:{

  my $execDir = File::Spec->rel2abs(dirname(__FILE__));
  
  my $ext = "ntf";
  if (scalar(@ARGV) > 0){
    $ext = $ARGV[0];
  }
  
  my @list;
  my $curr= "";
  my @files = (<*$ext>);
  if (scalar(@files) == 0){
    $ext = "tif";
    @files = (<*$ext>);
  }
  
  foreach my $file (@files){
    my $pref = $file;
    $pref =~ s/-BROWSE//g;
    $pref =~ s/_crop//g;
    $pref =~ s/^.*-(.*?)\..*?$/$1/g;
    if ($curr ne $pref){
      my $ans = qx($execDir/dg_mosaic_hack.py *$pref*$ext  --output-prefix right --skip-rpc-gen);
      $ans =~ s/\s*//g;
      $ans =~ s/_crop//g;
      push(@list, $ans);
      $curr=$pref;
    }
  }
  my $count = 0;
  foreach my $f (@list){
    my $fp = $f;
    $fp =~ s/\.$ext//g;
    print "$fp ";
    $count++;
    last if ($count >=2);
  }
  
}
