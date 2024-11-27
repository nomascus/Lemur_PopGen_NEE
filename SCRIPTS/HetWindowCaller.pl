#!/usr/bin/perl
use strict;
use warnings;

### Calculates the number and percent of heterozygous sites from each bed region in a bedfile. Streams to STDOUT, but not super fast likely on account of the bash call

# Takes as input a bedfile that is the output of MergeCallableWindows.pl

# input bedfile format 
# Scaffold		Start	End	Scaffold	CallableSites	%CallableSites
#	Scaf1	0	100000	100000	97531	0.97531
#	Scaf1	10000	110000	100000	97866	0.97866
#	Scaf1	20000	120000	100000	97886	0.97886
#	Scaf1	30000	130000	100000	97883	0.97883

# output format		
# 		Scaffold	Start	End	WindowSize	CallableSitesInWindow	%CallableSites	NumHets	%CallableHets
#		Scaf1	0	100000	100000	97531	0.97531	41	0.00042
#		Scaf1	10000	110000	100000	97866	0.97866	44	0.00045
#		Scaf1	20000	120000	100000	97886	0.97886	45	0.00046
#		Scaf1	30000	130000	100000	97883	0.97883	45	0.00046

my $bedfile = shift @ARGV;
my $vcf = shift @ARGV;

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
	my $sites = $splitline[4];

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
			## make a bash system call to use tabix to take callable region from VCF and wc -l to count number of heterozygous sites
			my $numHets = `tabix -h $vcf $bedRegion | bcftools query -i 'TYPE="SNP" & GT="het"' -f "%CHROM\t%POS0\t%POS\t%REF\t%ALT\n" |wc -l`;
			chomp $numHets;
			my $percHet;
			if ($sitesSum == 0){
				$percHet = '0'
			}
			else {
				$percHet = sprintf("%.5f", $numHets/$sitesSum);
			}
			print "$scaffoldPrev\t$startPrev\t$endPrev\t$windowSize\t$sitesSum\t$PercentCallable\t$numHets\t$percHet\n";
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
## make a bash system call to use tabix to take callable region from VCF and wc -l to count number of heterozygous sites
my $bedRegion = '"'.$scaffoldPrev.'":'.$startPrev.'-'.$endPrev;
my $numHets = `tabix -h $vcf $bedRegion | bcftools query -i 'TYPE="SNP" & GT="het"' -f "%CHROM\t%POS0\t%POS\t%REF\t%ALT\n" |wc -l`;
chomp $numHets;
my $percHet;
if ($sitesSum == 0){
	$percHet = '0'
}
else {
	$percHet = sprintf("%.5f", $numHets/$sitesSum);
}
print "$scaffoldPrev\t$startPrev\t$endPrev\t$windowSize\t$sitesSum\t$PercentCallable\t$numHets\t$percHet\n";
