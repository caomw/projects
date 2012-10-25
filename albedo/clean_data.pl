#!/usr/bin/perl

require 'conv_to_seconds.pl';

open(FILE, "<$ARGV[0]");
my @data = <FILE>;
close(FILE);

foreach my $line (@data){
  #print "--$line--\n";
  my ($num, $time);
  next unless ($line =~ /output(\d+)[_\.].*? ([\d:\.]+)elapsed/ ||
              $line =~ /output(\d+)[_\.].*?real\s+(\d+m.*?s)/);

  my $num   = $1;
  my $time  = $2;
  my $ntime = $time;
  $ntime =~ s/m/:/g;
  $ntime =~ s/s//g;
  my $stime = conv_to_seconds($ntime);
  my $ratio = $stime/$num;
  print "$num $time $stime per_image: $ratio\n";
}

