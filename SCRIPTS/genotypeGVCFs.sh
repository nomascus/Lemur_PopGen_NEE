# SCRIPTS/genotypeGVCFs.sh  /scratch/devel/jorkin/STREPS/2021/METADATA/

module unload java
module load java/latest

refDIR='/home/devel/jorkin/scratch/STREPS/REFERENCES'
inDIR='/home/devel/jorkin/scratch/STREPS/2021/VARIANTS_BPR'
outDIR='/home/devel/jorkin/scratch/STREPS/2021/gVCF'

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	refSp=$(echo $meta | awk '{print $2}')
	refID=$(echo $meta | awk '{print $3}')
	PCR=$(echo $meta | awk '{print $4}')

	sample=$(echo $ID | perl -lpe 's/\w+_\w+_([DLC|PD]\w+)/$1/')

        echo $ID $refSp $refID $sample

	if [[ $PCR == N ]]; then pcr_mode=NONE;fi
	if [[ $PCR == Y ]]; then pcr_mode=CONSERVATIVE;fi
       	#echo $pcr_mode $PCR
	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS

        #echo $refSp $refID     
        for chunk in $refDIR/$refSp/${refID}_windows/30_mb_chunks/*.bed; do
#	for chunk in $refDIR/$refSp/${refID}_windows/30_mb_chunks/1.bed; do
	chunkName=$(basename $chunk)

		echo " java -Xmx15g -Djava.io.tmpdir=$TMPDIR -jar /apps/GATK/4.2.2.0/gatk-package-4.2.2.0-local.jar GenotypeGVCFs -R $refDIR/$refSp/$refID -V $inDIR/${ID}/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz -O $outDIR/${ID}/${ID}_${chunkName%.bed}.raw.snps.indels.genotyped.g.vcf.gz --include-non-variant-sites true --allow-old-rms-mapping-quality-annotation-data" > $outDIR/${ID}/COMMANDS/${ID}_${chunkName}.genotypeGVCF.sh

		submit.py -o $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.genotype.g.vcf.gz.out -e $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.genotype.g.vcf.gz.err -p main -u 1 -w'03:00:00' -n g.${sample}_${chunkName} -c"bash $outDIR/${ID}/COMMANDS/${ID}_${chunkName}.genotypeGVCF.sh"


        done
done





