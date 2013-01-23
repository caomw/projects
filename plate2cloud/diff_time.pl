#!/usr/bin/perl
use strict;        # insist that all variables be declared
use diagnostics;   # expand the cryptic warnings
use Date::Parse;
use POSIX qw{strftime};
  MAIN:{

  # Usage: cat output.txt | grep -i Jan | diff_time.pl
  
  my @lines = <STDIN>;
  my @dates = ();
  foreach my $line (@lines){
    $line =~ s/^\d*://g; # Rm artifact coming from grep
    $line =~ s/\s*$//g;
    #print "$line\n";

    $line =~ s/^.*at\s*(.*?)$/$1/g;
    my $date = str2time($line);
    #print "Date is $date\n";
    push (@dates, $date);
  }

  my ($sum1, $sum2) = (0, 0);
  print "query_time processing_time\n";
  my $len = scalar(@dates);
  my $count = 0;
  while(1){
    my $a = 2*$count;
    my $b = $a+1;
    my $c = $a+2;
    my $d = $a+3;
    last if ($d >= $len);
    my $d1 = $dates[$d] - $dates[$c];
    my $d2 = $dates[$c] - $dates[$b];
    $sum1 += $d1;
    $sum2 += $d2;
    print "$d - $c $d1      $c - $b $d2\n";
    $count++;
  }

  print "Totals: $sum1 $sum2\n";
  #   if (scalar(@dates) == 6){
#     my $diff = $dates[5] - $dates[0]; # difference in times in seconds
#     print "Total time is " . int(100*$diff/3600 + 0.5)/100 . " hours\n";
#   }
}
