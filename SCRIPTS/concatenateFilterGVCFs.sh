# Run GATK 4 haplotype caller on 30 mb chunks of the reference genome to deposit in VARIANTS_BPR directory
# bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/concatenateFilterGVCFs.sh /scratch/devel/jorkin/STREPS/2021/METADATA/SampleList.txt

module unload java
module load java/latest
module load bcftools

outDIR='/home/devel/jorkin/scratch/STREPS/2021/gVCF'
inDIR='/home/devel/jorkin/scratch/STREPS/2021/gVCF'

cat $1 | while read meta;do
	PD=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}')
	ID=${species}_${PD}

	#echo $ID $refSp $refID
	
	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS

	#Make sure not to remake filelist a second time	
#	ls $inDIR/${ID}/*.gz| sort -V > $inDIR/${ID}/filelist.txt

		echo "bcftools concat -a -f $inDIR/${ID}/filelist.txt | bcftools filter -e 'AC>2 || QD<2 || FS>60.0 || SOR>3 || MQ<40 || ReadPosRankSum<-8.0 || MQRankSum <-12.5 || FORMAT/DP<10 || FORMAT/DP>100 || RGQ<20' --SnpGap 10 -O z -o $outDIR/${ID}/${ID}.snps.indels.filtered.vcf.gz; tabix -p vcf $outDIR/${ID}/${ID}.snps.indels.filtered.vcf.gz;" > $outDIR/${ID}/COMMANDS/${ID}.concatenate.filter.sh

	submit.py -o $outDIR/${ID}/ERROR/${ID}.concatenate.filter.out -e $outDIR/${ID}/ERROR/${ID}.concatenate.filter.err -p main -u 1 -w'18:00:00' -n F.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.concatenate.filter.sh"
	
#		submit.py -r highprio -o $outDIR/${ID}/ERROR/${ID}.concatenate.filter.out -e $outDIR/${ID}/ERROR/${ID}.concatenate.filter.err -p main -u 1 -w'1:00:00' -n F.${PD}_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}.concatenate.filter.sh"
	
done
