cd ~/scratch/STREPS/HETEROZYGOSITY/WINDOWS/${Type}

HetPath="/home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/WINDOWS"

while read meta; do

	Reference=$(echo $meta | awk '{print $1}')
	Individual=$(echo $meta | awk '{print $2}')
	VCF=$(echo $meta | awk '{print $3}')
	Callable=$(echo $meta | awk '{print $4}')
	WinSize=$(echo $meta | awk '{print $5}')
	Slide=$(echo $meta | awk '{print $6}')
	Type=$(echo $meta | awk '{print $7}')
	halfsize=$(echo $((WinSize/2)))

	if  [  -e $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named ]; then
		rm $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named
	fi
	if  [  -e $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt ]; then
		rm $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt
	fi
	while read line; do
		newline=$(echo -e "${Individual}\t${Reference}\t$line") 
		Het=$(echo $line |awk '{print $8}')
		Callable=$(echo $line |awk '{print $5}')
		ROH=$( echo $Het 0.0001 | awk '{if ($1 < $2) print "Yes"; else print "No"}' ) 
		echo $newline >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.merge.het.sort.named
		if (($Callable > 499999)) ; then 
			echo -e "$newline\t$ROH" >> $HetPath/$Type/$Individual/${Individual}.${Type}_windows.callable.${halfsize}Min.ROH.txt
		fi 
	done < $HetPath/$Type/$Individual/SPLITWINDOWS/TMP/${Individual}.${Type}_windows.callable.merge.bed_aa.het
done < $HetPath/1Mb-200kb/Daubentonia_madagascariensis_ROH.metadata

