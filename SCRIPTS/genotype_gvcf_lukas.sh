
module load java

#indir='/scratch/devel/jorkin/STREPS/2021/COMBINE_GVCF'
#outdir='/scratch/devel/jorkin/STREPS/2021/gVCF/JOINT'

indir='/scratch/devel/jorkin/STREPS/2021/VARIANTS_BPR'
outdir='/scratch/devel/jorkin/STREPS/2021/gVCF/SINGLE'

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	refID=$(echo $meta | awk '{print $2}')

	mkdir -p $outdir/$ID

	for gvcf in ${indir}/${ID}/${ID}*raw.snps.indels.g.vcf.gz;do
	
	outname=$(echo $gvcf | perl -lpe 's/g\.vcf/genotyped\.g\.vcf/' |xargs basename)
		
	echo "java -Xmx15g -Djava.io.tmpdir=\$TMPDIR -jar /apps/GATK/4.1.7.0/gatk-package-4.1.7.0-local.jar GenotypeGVCFs --include-non-variant-sites -R /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID} --variant $gvcf -O $outdir/$ID/${outname}^$outdir/$ID/${outname}.log"
done 
done
