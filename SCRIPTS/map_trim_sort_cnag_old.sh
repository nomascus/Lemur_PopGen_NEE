#read in metadata, and map to correspoding references


module unload python gcc samtools
module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.12 PYTHON/3.6.3

working_dir="/home/devel/jorkin/scratch/STREPS/2021"
out_dir="/home/devel/jorkin/scratch/STREPS/2021/TRIM_MAP_SORT"

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	Species=$(echo $meta | awk '{print $2}')
	refSp=$(echo $meta | awk '{print $3}')
	refPath=$(echo $meta | awk '{print $4}')
	refID=$(echo $meta | awk '{print $5}')
	UMI=$(echo $meta | awk '{print $6}')
	batch=$(echo $meta | awk '{print $7}')
	FQpath=$(echo $meta | awk '{print $8}')
	
	mkdir -p ${out_dir}/${ID}
	mkdir -p ${out_dir}/${ID}/COMMANDS
	mkdir -p ${out_dir}/${ID}/ERROR
		
	echo "MAPPING UMI $UMI $rb TO ${Species}_$ID"

		#run mappings and sorting jobs

echo "/home/devel/jorkin/scratch/programs/bbmap/reformat.sh in1=$FQpath/${UMI}_1.fastq.gz in2=$FQpath/${UMI}_2.fastq.gz out=stdout.fq | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 $refPath/${refSp}/${refID} - |  samtools sort -@ 8 -m 3G -O bam -T $out_dir/${ID}/${ID}_${UMI}_map_sort.TMP -o ${out_dir}/${ID}/${ID}_${UMI}.trim.sort.bam" > $out_dir/${ID}/COMMANDS/${ID}_${UMI}_map_sort.sh;


submit.py -o ${out_dir}/${ID}/ERROR/${ID}_${UMI}_map_sort.out -e ${out_dir}/${ID}/ERROR/${ID}_${UMI}_map_sort.err -u 8 -p main -w'18:00:00' -n ${ID}_TR_map -c"bash $out_dir/${ID}/COMMANDS/${ID}_${UMI}_map_sort.sh";
#submit.py -o ${out_dir}/${ID}/ERROR/${ID}_${UMI}_map_sort.out -e ${out_dir}/${ID}/ERROR/${ID}_${UMI}_map_sort.err -u 1 -p main -r highprio -w'01:00:00' -n ${ID}_TR_map -c"bash $out_dir/${ID}/COMMANDS/${ID}_${UMI}_map_sort.sh";

	done



