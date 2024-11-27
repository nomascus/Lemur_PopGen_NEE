#read in metadata, and map to correspoding references

# MAKE SURE TO LAUNCH FROM OUTDIR

module unload samtools python
module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 PYTHON/3.6.3

outdir="/scratch/devel/jorkin/STREPS/RAW_DATA/CNAG_PHASE1_FASTQ/TEST"

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	library=$(echo $meta | awk '{print $2}')
	refID=$(echo $meta | awk '{print $3}')
	cram=$(echo $meta | awk '{print $4}')

echo "samtools sort -T \$TMPDIR -l0 -n -@2 --reference $refID $cram | bedtools bamtofastq -i - -fq ${ID}_${library}_1.fq -fq2 ${ID}_${library}_2.fq ; gzip ${ID}_${library}_1.fq -fq2 ${ID}_${library}_2.fq^${ID}_${library}.cram2fastq.log"

done
