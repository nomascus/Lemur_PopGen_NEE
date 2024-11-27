#module unload samtools python GCC
#module load gcc/4.9.3-gold SAMTOOLS/1.12 PYTHON/3.6.3 BIOBAMBAM/2.0.35

module unload gcc; module load gcc/4.9.3-gold BIOBAMBAM/2.0.35 # THIS IS THE KEY SETTING to avoid libmaus space error

indir="/scratch/devel/jorkin/STREPS/2021/TRIM_MAP_SORT"
outdir="/scratch/devel/jorkin/STREPS/2021/BAMS_MERGED"

cat $1 | while read meta;do
	id=$(echo $meta | awk '{print $1}')
	mkdir -p ${outdir}/$id

 	ls ${indir}/${id}/*sorted.bam >${outdir}/${id}/fofn; 

	echo "samtools merge -@8 -b ${outdir}/${id}/fofn - | bammarkduplicates O=${outdir}/${id}/${id}.markdup.merged.bam markthreads=8 tmpfile=\${TMPDIR}/${id} ; samtools index ${outdir}/${id}/${id}.markdup.merged.bam; java -jar /apps/PICARD/2.8.2/picard.jar AddOrReplaceReadGroups I=${outdir}/${id}/${id}.markdup.merged.bam O=${outdir}/${id}/${id}.markdup.merged.addRG.bam RGID=$id RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$id ; samtools index ${outdir}/${id}/${id}.markdup.merged.addRG.bam^${outdir}/${id}/${id}.merge_dedup_addRG.log"

done
