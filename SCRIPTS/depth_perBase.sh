# Calculate perbase depth from bam file
# metadata file just a list of sample names

module load mosdepth

indir='/scratch/devel/jorkin/STREPS/2021/BAMS_MERGED'
outdir='/scratch/devel/jorkin/STREPS/2021/DEPTH/PERBASE'

cat $1 | while read meta; do
	sample=$(echo $meta)
	mkdir -p  $outdir/$sample

	echo "mosdepth $outdir/$sample/$sample $indir/$sample/${sample}.markdup.merged.addRG.bam^$outdir/$sample/${sample}.perBaseDepth.log"
done
