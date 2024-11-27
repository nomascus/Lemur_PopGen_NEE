#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

### Calculates the number and percent of heterozygous sites from each bed region in a bedfile after summing together the callable subregions. Streams to STDOUT, but not super fast likely oin account of the bash call

# Takes as in put a bedfile that is the output of bedtools intersect -a windowfile.bed -b callable.bed -wao 

# input bedfile format 
# 	Scaffold	Start	End	Scaffold	CallableStart	CallableEnd	CallableSites
#	Scaf1	0	100000	ctg1	15	20	5
#	Scaf1	0	100000	ctg1	21	1735	1714
#	Scaf1	0	100000	ctg1	1742	1743	1

# output format	
# Scaffold	Start	End	WindowSize	CallableSitesInWindow	%CallableSites
# ctg1	0	100000	100000	97531	0.97531
# ctg1	10000	110000	100000	97866	0.97866
# ctg1	20000	120000	100000	97886	0.97886

#print "\#Scaffold\tStart\tEnd\tWindowSize\tCallableSitesInWindow\t%CallableSites\n";

my $bedfile = shift @ARGV;

open (IN , '<', $bedfile) or die "$! bed file did not load\n";

my $scaffoldPrev = '';
my $startPrev = '';
my $endPrev = '';
my $sitesSum = -1;
my $firstline = '';

while (my $line = <IN>){
	chomp $line;
	my @splitline = split("\t", $line);
	my $scaffold = $splitline[0];
	my $start = $splitline[1];
	my $end = $splitline[2];
	my $sites = $splitline[6];

	if ($sitesSum == -1){
		$scaffoldPrev = $scaffold;
		$startPrev = $start;
		$endPrev = $end;
		$sitesSum = $sites;
	}
	else{
		if  ($scaffoldPrev eq $scaffold and $startPrev == $start and $endPrev == $end){
			$sitesSum += $sites;
		}
		else{
			my $windowSize = $endPrev-$startPrev;
			my $PercentCallable = sprintf("%.5f", $sitesSum/($endPrev-$startPrev));
			my $bedRegion = '"'.$scaffoldPrev.'":'.$startPrev.'-'.$endPrev;
			print "$scaffoldPrev\t$startPrev\t$endPrev\t$windowSize\t$sitesSum\t$PercentCallable\n";
			$scaffoldPrev = $scaffold;
			$startPrev = $start;
			$endPrev = $end;
			$sitesSum = $sites;
		}
	}

}

## operate over the last line
my $windowSize = $endPrev-$startPrev;
my $PercentCallable = sprintf("%.5f", $sitesSum/($endPrev-$startPrev));
my $bedRegion = '"'.$scaffoldPrev.'":'.$startPrev.'-'.$endPrev;
print "$scaffoldPrev\t$startPrev\t$endPrev\t$windowSize\t$sitesSum\t$PercentCallable\n";
