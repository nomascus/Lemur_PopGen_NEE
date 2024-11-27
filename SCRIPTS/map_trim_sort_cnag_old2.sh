#read in metadata, and map to correspoding references


module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 SEQTK/1.2 PYTHON/3.6.3 BIOBAMBAM/2.0.35

base_out=MAPPINGS_TRIM

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	refID=$(echo $meta | awk '{print $4}')
	batch=$(echo $meta | awk '{print $6}')
	
	mkdir -p ${base_out}/${ID}
	#get the readbases corresponding to each ID from the lookup table:
	grep ${ID} batch_metadata/${batch}/ID_READSET_LOOKUP | cut -f2 | while read rbn;do


	#read read basis
		rb=RAW_DATA/${batch}/${rbn}
		#run mappings and sorting jobs

echo "seqtk mergepe ${rb}_1.fastq.gz ${rb}_2.fastq.gz | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 REFERENCES_FROZEN/*/*/${refID} - | \
samtools sort -@ 8 -m 3G -O bam -T ${base_out}/${ID}/${rbn}_map_sort.TMP -o ${base_out}/${ID}/${rbn}.dedup.sorted.bam^${base_out}/${ID}/${rbn}.dedup.sorted.bam.log"
	done

done
