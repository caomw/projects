#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use File::Basename;

# Given all the files in the current directory,
# print a left and corresponding right ntf file
# which will make a suitable stereo pair, without
# the .ntf extensions.
MAIN:{

  my $execDir = dirname(__FILE__);
  my @list;
  my $curr= "";
  my @files = (<*ntf>);
  foreach my $file (@files){
    my $pref = $file;
    $pref =~ s/-BROWSE//g;
    $pref =~ s/^.*-(.*?)\..*?$/$1/g;
    if ($curr ne $pref){
      my $ans = qx($execDir/dg_mosaic_hack.py *$pref*ntf  --output-prefix right --skip-rpc-gen);
    $ans =~ s/\s*//g;
      push(@list, $ans);
      $curr=$pref;
    }
  }
  my $count = 0;
  foreach my $f (@list){
    my $fp = $f;
    $fp =~ s/\.ntf//g;
    print "$fp ";
    $count++;
    last if ($count >=2);
  }
  
}
