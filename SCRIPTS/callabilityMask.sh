# Convert gVCF to VCF
# bash /STREPS/2021/VCF$ bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/callabilityMask.sh /scratch/devel/jorkin/STREPS/2021/METADATA/SampleList.txt

# Need to add bedtools sort call, but needs more time?

module unload java
module load java/latest
module load bcftools
#module load bedtools

inDIR='/home/devel/jorkin/scratch/STREPS/2021/gVCF'
outDIR='/home/devel/jorkin/scratch/STREPS/2021/CALLABLE'

cat $1 | while read meta;do
	PD=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}')
	ID=${species}_${PD}

	#echo $ID $refSp $refID
	
	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS

echo "bcftools view -U $inDIR/$ID/${ID}.snps.indels.filtered.vcf.gz | bedtools merge  > $outDIR/${ID}/${ID}.snps.filtered.callable.bed" > $outDIR/${ID}/COMMANDS/${ID}.callabilityMask.sh

	submit.py -r highprio -o $outDIR/${ID}/ERROR/${ID}.callabilityMask.out -e $outDIR/${ID}/ERROR/${ID}.callabilityMask.err -p main -u 1 -w'10:00:00' -n cm.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.callabilityMask.sh"
	
#	submit.py  -o $outDIR/${ID}/ERROR/${ID}.callabilityMask.out -e $outDIR/${ID}/ERROR/${ID}.callabilityMask.err -p main -u 1 -w'08:00:00' -n cm.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.callabilityMask.sh"
	
done
