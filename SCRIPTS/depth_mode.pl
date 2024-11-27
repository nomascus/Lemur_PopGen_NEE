#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $infile =  shift @ARGV;

open (IN, "gunzip -c $infile |") or die "$! bedfile did not load"; 

my %hash;

while (my $line = <IN>){
	chomp $line;
	my @splitline = split("\t", $line);
	my $start = $splitline[1];	
	my $end = $splitline[2];	
	my $depth = $splitline[3];	
	my $nucs = $end - $start;
	$hash{$depth} += $nucs;	
}

#print Dumper \%hash;

foreach my $depth (sort {$hash{$b} <=> $hash{$a}} keys %hash){
	print "$depth\t$hash{$depth}\n"
}
