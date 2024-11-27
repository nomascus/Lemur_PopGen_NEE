# Run GATK 4 haplotype caller on 30 mb chunks of the reference genome to deposit in VARIANTS_BPR directory
# bash ~/scratch/STREPS/bin/var ~/scratch/STREPS/MAPPING/batch_metadata/CGL_26_20200130/LemurCattaRef_MappingInfo

module unload java
module load java/latest

refDIR='/home/devel/jorkin/scratch/STREPS/REFERENCES'
outDIR='/home/devel/jorkin/scratch/STREPS/2021/VARIANTS_BPR'
bamDIR='/home/devel/jorkin/scratch/STREPS/2021/BAMS_MERGED'

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	refSp=$(echo $meta | awk '{print $2}')
	refID=$(echo $meta | awk '{print $3}')
	PCR=$(echo $meta | awk '{print $4}')

	#echo $ID $refSp $refID
	
	if [[ $PCR == N ]]; then pcr_mode=NONE;fi 
	if [[ $PCR == Y ]]; then pcr_mode=CONSERVATIVE;fi
	#echo $pcr_mode $PCR
	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS

	#echo $refSp $refID	
	for chunk in $refDIR/$refSp/${refID}_windows/30_mb_chunks/*.bed; do
	#for chunk in $refDIR/$refSp/${refID}_windows/30_mb_chunks/1.bed; do
		chunkName=$(basename $chunk)
		
		echo "java -Xmx15g -Djava.io.tmpdir=\$TMPDIR -jar /apps/GATK/4.0.8.1/gatk-package-4.0.8.1-local.jar HaplotypeCaller -R $refDIR/$refSp/$refID -I $bamDIR/${ID}/${ID}.markdup.merged.addRG.bam -ERC BP_RESOLUTION -L $chunk --pcr-indel-model $pcr_mode -O $outDIR/${ID}/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz" > $outDIR/${ID}/COMMANDS/${ID}_${chunkName}.VariantCall.sh
	
		submit.py -o $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz.out -e $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz.err -p main -u 1 -w'24:00:00' -n ${chunkName}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}_${chunkName}.VariantCall.sh"
	
#		submit.py -o $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz.out -e $outDIR/${ID}/ERROR/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz.err -p main -u 1 -w'01:00:00' -n ${chunkName}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}_${chunkName}.VariantCall.sh"
	
	done 
done
