# Calculate frequency of each depth from mosdepth perbase output
# metadata file just a list of sample names


indir='/scratch/devel/jorkin/STREPS/2021/DEPTH/PERBASE'
outdir='/scratch/devel/jorkin/STREPS/2021/DEPTH/PERBASE'

cat $1 | while read meta; do
	sample=$(echo $meta)
	mkdir -p  $outdir/$sample

	echo "perl /scratch/devel/jorkin/STREPS/2021/SCRIPTS/depth_mode.pl $indir/$sample/${sample}.per-base.bed.gz > $outdir/$sample/$sample.depthDistribution.txt^$outdir/$sample/${sample}.depthDistribution.log"
done
