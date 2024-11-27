#!/usr/bin/perl
use strict;
use warnings;

my $infile = shift @ARGV; 

open(IN, "<", $infile) or die "bed file did not open $!";

my $counter=0;
my $file=0;

open (OUT, ">", "$file.bed");

while ( my $line = <IN>){
	chomp $line;
	my @splitline = split("\t", $line);
	my $start = $splitline[1];
	my $end = $splitline[2];
	$counter += ($end - $start);	
	#print "$counter\n";
	if ( ($counter) <= 30000000){
		print OUT "$line\n";
	}

	else {
		close(OUT);	
		$file+=1;
		$counter = 0 + ($end - $start);
#		print "$counter\n";
		open (OUT, ">", $file . ".bed");
		print OUT "$line\n";
	}
}

