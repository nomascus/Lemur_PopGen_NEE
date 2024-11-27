# Dependencies: bedtools, bcftools, tabix, MergeCallableWindows.pl, HetWindowCaller.pl
# metadatafile with tab separated INFILES and VARIABLES, where necessary
# To run: bash ROHmaker.sh metadatafile 


### NOTE: This codes is written to run in two parts. Be sure to commment out appropriately


#PATHS
ReferencePath="/home/devel/jorkin/scratch/STREPS/REFERENCES"
WindowPath="/home/devel/jorkin/scratch/STREPS/2021/WINDOWS"
CallablePath="/home/devel/jorkin/scratch/STREPS/2021/CALLABLE"
HetPath="/home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/WINDOWS"
bin="/home/devel/jorkin/scratch/STREPS/2021/SCRIPTS"
VCFpath="/home/devel/jorkin/scratch/STREPS/2021/VCF"

module unload gcc 
module load gcc/6.3.0
module unload bedtools 
module load bedtools/2.29.0
module load bcftools

cat $1 | while read metadata;do
	Reference=$(echo $metadata | awk '{print $1}')
	Individual=$(echo $metadata | awk '{print $2}')
	VCF=$(echo $metadata | awk '{print $3}')
	Callable=$(echo $metadata | awk '{print $4}')
	WinSize=$(echo $metadata | awk '{print $5}')
	Slide=$(echo $metadata | awk '{print $6}')
	Type=$(echo $metadata | awk '{print $7}')

#INFILES
#Reference="Lemur_catta-Thomas"
#Individual="PD_0620_Lemur_catta"
#VCF="PD_0620_Lemur_catta.variable.filtered.HF.snps.vcf.gz"
#Callable="PD_0620_Lemur_catta.variable.filtered.callable.bed"

#VARIABLES
#WinSize="100000"
#Slide="10000"
#Type="100kb-10kb"

########################################
#### PART 1: Make callable bedfiles ####
########################################

# 1) make 100kb 10kb sliding windows bed file from reference index unless it already exists

	echo -e "\n1) Make $Type sliding windows bed file from reference index unless it already exists\n"
	mkdir -p ${WindowPath}/$Reference

	if [ ! -s ${WindowPath}/$Reference/${Reference}.${Type}_windows.sort.bed ]; then
		echo -e "\t${WindowPath}/$Reference/${Reference}.${Type}_windows.sort.bed does not exist\n";
#		bedtools makewindows -g ${ReferencePath}/${Reference}.fasta.fai -w $WinSize -s $Slide |bedtools sort > ${WindowPath}/$Reference/${Reference}.${Type}_windows.sort.bed
	else echo -e "\t${WindowPath}/$Reference/${Reference}.${Type}_windows.sort.bed exists\n";
	fi

# 2) intersect reference window file with callable bed file and count number of overlapping sites

	echo -e "2) intersect reference window file with callable bed file and count number of overlapping sites\n"
	mkdir -p ${WindowPath}/${Reference}
	mkdir -p $HetPath
	mkdir -p $HetPath/$Type/$Individual/COMMANDS
	mkdir -p $HetPath/$Type/$Individual/STDERR

#	echo -e "bedtools intersect -a ${WindowPath}/${Reference}/${Reference}.${Type}_windows.sort.bed -b ${CallablePath}/${Individual}/${Callable} -wao -nonamecheck > $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.bed" > $HetPath/$Type/$Individual/COMMANDS/${Individual}.${Type}.windows.sh

#3) Sum window fragments to calculate callable sites and percent callable sites per window. Save as merged bedfile

#	echo -e "\tSum window fragments to calculate callable sites and percent callable sites per window. Save as merged bedfile\n"

#	echo -e "perl $bin/MergeCallableWindows.pl $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.bed > $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.bed" >>  $HetPath/$Type/$Individual/COMMANDS/${Individual}.${Type}.windows.sh
	# Output should be:
	# Scaffold		Start		Stop		Sites	CallableSites	%CallableSites
	# scaffold_9|arrow	93180000	93279816	99816	92535		0.92706 


# Might need to use 1-4 cores depending on the size of the files

#	submit.py -r highprio -i . -o $HetPath/$Type/$Individual/STDERR/${Individual}.${Type}.windows.out -e $HetPath/$Type/$Individual/STDERR/${Individual}.${Type}.windows.err -n "win-$Individual" -p main -u 4 -t 1 -w 01:00:00 -c"bash $HetPath/$Type/$Individual/COMMANDS/${Individual}.${Type}.windows.sh" 


######################333333333333333################################
#### PART 2: Het calling to run when callable bedfiles complete  ####
#####################################################################

#4) Split callable bedfile into sections (50k lines) for parallelization

	echo -e "4) Split callable bedfile into sections (50k lines) for parallelization\n"
	mkdir -p $HetPath/$Type/$Individual/SPLITWINDOWS/ 

	split -l 50000 $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.bed $HetPath/$Type/$Individual/SPLITWINDOWS/${Individual}.${Type}_windows.callable.merge.bed_ 

#5) for each window in the split window file calculate heterozygosity 

	echo -e "5) for each window in the split window file calculate heterozygosity \n"
	mkdir -p $HetPath/$Type/$Individual/SPLITWINDOWS/TMP
	mkdir -p $HetPath/$Type/$Individual/SPLITWINDOWS/STDERR
	mkdir -p $HetPath/$Type/$Individual/SPLITWINDOWS/COMMANDS

	if [ ! -f ${VCFpath}/$Individual/${VCF}.tbi ]; then
		echo -e "tabix index does not exist for VCF, building...\n"
#		tabix -h -p vcf ${VCFpath}/$VCF
	fi

	for file in $HetPath/$Type/$Individual/SPLITWINDOWS/*_*; do
		filename=$(basename $file)
		echo "perl $bin/HetWindowCaller.pl $file $VCFpath/$Individual/$VCF > $HetPath/$Type/$Individual/SPLITWINDOWS/TMP/${filename}.het" > $HetPath/$Type/$Individual/SPLITWINDOWS/COMMANDS/${filename}.het.sh



#		submit.py -r highprio -i . -o $HetPath/$Type/$Individual/SPLITWINDOWS/STDERR/${filename}.out -e $HetPath/$Type/$Individual/SPLITWINDOWS/STDERR/${filename}.err -n "h-${Individual}" -p main -u 2 -w 03:00:00 -c "bash $HetPath/$Type/$Individual/SPLITWINDOWS/COMMANDS/${filename}.het.sh";
	done  


######################################################
#### PART 3: Run when callable bedfiles complete  ####
######################################################

#6) Merge split files into single bedfile

	echo -e "6) Merge split files into single bedfile\n"

#	cat $HetPath/$Type/$Individual/SPLITWINDOWS/TMP/*.het |bedtools sort > $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort

done

## Getting lazy here... need to clean up ##

	# Add species name and merge into one big file removing windows with < 50k callable sites
cd ~/scratch/STREPS/HETEROZYGOSITY/WINDOWS/${Type}

cat $1 | while read metadata; do
	
	Reference=$(echo $metadata | awk '{print $1}')
	Individual=$(echo $metadata | awk '{print $2}')
	VCF=$(echo $metadata | awk '{print $3}')
	Callable=$(echo $metadata | awk '{print $4}')
	WinSize=$(echo $metadata | awk '{print $5}')
	Slide=$(echo $metadata | awk '{print $6}')
	Type=$(echo $metadata | awk '{print $7}')
	halfsize=$(echo $((WinSize/2)))

	if  [  -e $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named ]; then
		rm $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named
	fi
	if  [  -e $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt ]; then
		rm $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt
	fi
	cmd="bash ~/scratch/STREPS/ROHfinisher.sh $metadata"
	
#	submit.py -i . -o $HetPath/$Type/$Individual/STDERR/${Individual}.ROHfinisher.out -e $HetPath/$Type/$Individual/STDERR/${Individual}.ROHfinisher.err -n "ROH-$Individual" -p main -u 1 -t 1 -w 00:15:00 -c "$cmd"

done


	#	while read line; do
#	while read line; do
#		newline=$(echo -e "${Individual}\t${Reference}\t$line") 
#		echo $newline >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named
#		Het=$(echo $line |awk '{print $8}')
#		Callable=$(echo $line |awk '{print $5}')
#		ROH=$( echo $Het 0.0001 | awk '{if ($1 < $2) print "Yes"; else print "No"}' ) 
#		echo $newline >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named
#		if (($Callable > 499999)) ; then 
#			echo -e "$newline\t$ROH" >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt
#		fi 
		# >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.txt
#	done < $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort	
	
#	while read line; do
#		Het=$(echo $line |awk '{print $10}')
#		ROH=$( echo $Het 0.00001 | awk '{if ($1 <$2) print "Yes"; else print "No"}' ) 
#		echo -e "$line\t$ROH"
#	done < $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.txt

	#	if ($ROH == 'Yes');then
	#		echo -e "$newline2\tYes" 
		#>> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.txt
	#	else echo -e "$newline2\tNo" 
		#>> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.txt;
	#	fi

#done

#for ID in *; do while read line; do echo -e "$ID\t$line"; done < $ID/${ID}.100kb-10kb_windows.callable.merge.het.sort > $ID/${ID}.100kb-10kb_windows.callable.merge.het.sort.named; done

#while read ID; do cat $ID/${ID}.100kb-10kb_windows.callable.merge.het.sort.named| awk '$6>49999' >> het.merged.100kb-10kb_windows.callable.50kbMin.txt ;done <../SampleIDspeciesLemurPropithecus.txt 

	# Add reference name and ROH categorization

#perl -lne 'if ($_ =~ /^Avahi/ or $_ =~ /^Propithecus/ ){print "$_\tPropithecus_coquereli"}else{print "$_\tLemur_catta"}' het.merged.100kb-10kb_windows.callable.50kbMin.txt >het.merged.100kb-10kb_windows.callable.50kbMin.ref.txt
#perl -lne '@sl = split("\t", $_); if($sl[8] <=0.0002 ){print "$_\tYes"}else{print "$_\tNo"}' het.merged.100kb-10kb_windows.callable.50kbMin.ref.txt >het.merged.100kb-10kb_windows.callable.50kbMin.ref.roh0002.txt

