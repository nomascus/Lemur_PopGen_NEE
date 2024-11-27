#read in metadata, and map to correspoding references


module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 PYTHON/3.6.3 

outdir="/scratch/devel/jorkin/STREPS/2021/TRIM_MAP_SORT"

cat $1 | while read meta;do
	species=$(echo $meta | awk '{print $1}')
	ID=$(echo $meta | awk '{print $2}')
	refID=$(echo $meta | awk '{print $3}')
	
	mkdir -p ${outdir}/${species}_${ID}
	#get the readbases corresponding to each ID from the lookup table:
	grep ${ID} /scratch/devel/jorkin/STREPS/RAW_DATA/CNAG_FASTQ/ID_READSET_LOOKUP | while read line;do
		path=$(echo $line | awk '{print $7}')
		rbn=$(echo $line | awk '{print  $5}')
		
	#read read basis
		rb=${path}/${rbn}
		#run mappings and sorting jobs

echo "~/scratch/programs/bbmap/reformat.sh -Xmx2g in1=${rb}_1.fastq.gz in2=${rb}_2.fastq.gz out=stdout.fq | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID} - | \
samtools sort -@ 8 -m 3G -O bam -T \$TMPDIR/${rbn}_map_sort.TMP -o ${outdir}/${species}_${ID}/${rbn}.dedup.sorted.bam^${outdir}/${species}_${ID}/${rbn}.dedup.sorted.bam.log"
	done

done
