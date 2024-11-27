# Convert gVCF to VCF
# bash /STREPS/2021/VCF$ bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/gvcf2vcf.sh /scratch/devel/jorkin/STREPS/2021/METADATA/SampleList.txt

module unload java
module load java/latest
module load bcftools

outDIR='/home/devel/jorkin/scratch/STREPS/2021/VCF'
inDIR='/home/devel/jorkin/scratch/STREPS/2021/gVCF'

cat $1 | while read meta;do
	PD=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}')
	ID=${species}_${PD}

	#echo $ID $refSp $refID
	
	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS


		echo "bcftools view -U -v snps $inDIR/$ID/${ID}.snps.indels.filtered.vcf.gz |bgzip > $outDIR/${ID}/${ID}.callable.filtered.vcf.gz ; tabix -f -p vcf $outDIR/${ID}/${ID}.callable.filtered.vcf.gz" > $outDIR/${ID}/COMMANDS/${ID}.gvcf2vcf.sh

#	submit.py -r highprio -o $outDIR/${ID}/ERROR/${ID}.gvcf2vcf.out -e $outDIR/${ID}/ERROR/${ID}.gvcf.vcf.err -p main -u 1 -w'02:00:00' -n g2v.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.gvcf2vcf.sh"

	submit.py -o $outDIR/${ID}/ERROR/${ID}.gvcf2vcf.out -e $outDIR/${ID}/ERROR/${ID}.gvcf.vcf.err -p main -u 1 -w'05:00:00' -n g2v.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.gvcf2vcf.sh"
	
	
done
