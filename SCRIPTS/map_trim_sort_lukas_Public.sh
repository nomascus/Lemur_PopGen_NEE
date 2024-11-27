#read in metadata, and map to correspoding references

module unload samtools python
module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 PYTHON/3.6.3 biobambam

#indir="/scratch/devel/jorkin/STREPS/RAW_DATA/PUBLIC_FASTQ"
indir="/scratch/devel/jorkin/RawReads/STREPS/PUBLIC"
outdir="/scratch/devel/jorkin/STREPS/2021/TRIM_MAP_SORT"

STREPS="/scratch/devel/jorkin/STREPS"

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	library=$(echo $meta | awk '{print $2}')
	refID=$(echo $meta | awk '{print $3}')
	folder=$(echo $meta | awk '{print $4}')

	mkdir -p ${outdir}/${ID}

	#run mappings and sorting jobs
#../programs/bbmap/reformat.sh in=${STREPS}/RAW_DATA/BAYLOR_ALL_BAM_LINKS/${ID}.bam out=stdout.fq 

#echo "bamtofastq < ${STREPS}/RAW_DATA/BAYLOR_ALL_BAM_LINKS/${ID}.bam | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 REFERENCES/*/${refID} - | \


#echo "samtools sort -T ${outdir}/${ID}/${ID}_name_sort.TMP -l0 -n -@8 ${indir}/${ID}.bam | bedtools bamtofastq -i - -fq /dev/stdout -fq2 /dev/stdout | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 ${STREPS}/REFERENCES/*/${refID} - | \
#samtools sort -@ 8 -m 3G -O bam -T ${TMPDIR}/${ID}.map_sort.TMP -o ${outdir}/${ID}/${ID}.map.sorted.bam^${outdir}/${ID}/${ID}.map.sorted.bam.log"

echo "~/scratch/programs/bbmap/reformat.sh in1=${indir}/$folder/${ID}_${library}_1.fastq.gz in2=${indir}/$folder/${ID}_${library}_2.fastq.gz out=stdout.fq | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 ${STREPS}/REFERENCES/*/${refID} - | \
samtools sort -@ 8 -m 3G -O bam -T \$TMPDIR/${ID}_${library}.map_sort.TMP -o ${outdir}/${ID}/${ID}_${library}.map.sorted.bam^${outdir}/${ID}/${ID}_${library}.map.sorted.bam.log"

done
