#read in metadata, and map to correspoding references

module unload samtools python
module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 PYTHON/3.6.3 BIOBAMBAM

indir="/scratch/devel/jorkin/STREPS/RAW_DATA/BAYLOR_ALL_BAM_LINKS"
outdir="/scratch/devel/jorkin/STREPS/2021/BAMS_MERGED"

STREPS="/scratch/devel/jorkin/STREPS"

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	refID=$(echo $meta | awk '{print $2}')

	mkdir -p ${outdir}/${ID}

	#run mappings and sorting jobs

echo "samtools sort -T \$TMPDIR -l0 -n -@8  ${indir}/${ID}.bam | bedtools bamtofastq -i - -fq /dev/stdout -fq2 /dev/stdout | cutadapt -j 8 --interleaved -m 30 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT - | bwa mem -pt 8 ${STREPS}/REFERENCES/*/${refID} - | samtools sort -@ 8 -m 3G -O bam -T \$TMPDIR | bammarkduplicates O=${outdir}/${ID}/${ID}.markdup.merged.bam markthreads=8 tmpfile=\$TMPDIR; samtools index ${outdir}/${ID}/${ID}.markdup.merged.bam; java -jar /apps/PICARD/2.8.2/picard.jar AddOrReplaceReadGroups I=${outdir}/${ID}/${ID}.markdup.merged.bam O=${outdir}/${ID}/${ID}.markdup.merged.addRG.bam RGID=$ID RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$ID; samtools index ${outdir}/${ID}/${ID}.markdup.merged.addRG.bam^${outdir}/${ID}/${ID}.merge_dedup_addRG.log"

done
