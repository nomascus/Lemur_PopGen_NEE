module load bcftools

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	INDIR=$(echo $meta | awk '{print $2}')
	MIN_COV=$(echo $meta | awk '{print $3}')
	MAX_COV=$(echo $meta | awk '{print $4}')
	MIN_HET_AD=3
	# this shoudl already exist from generting the variable part
#	# ls ./VARIANTS_BPR/${ID}/${ID}*.snps.indels.genotyped.g.vcf.gz > ./VARIANTS_CLEAN/${ID}/${ID}_filtered_gvcfs

	# these are EXCLUSIVE filters! bear in mind when assigning < > 

	mkdir -p /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}
	# ls -v $INDIR/$ID/*.gz > /scratch/devel/jorkin/STREPS/2021/VCF/$ID/fofn 

#	echo " bcftools filter --threads 1 -e \"TYPE!='snp' | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | AC > 2 | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | QD < 2 | FS >60 | MQ < 40 | SOR > 3 | ReadPosRankSum < -8.0 | MQRankSum < -12.5\" -Oz -o /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz  /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.merged.sorted.g.vcf.gz ; tabix -f -p vcf /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz.log"
	echo "bcftools filter --threads 1 -e \"TYPE!='indel' | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | QD < 2 | FS > 200 | MQ < 40 | SOR > 3 | ReadPosRankSum < -20.0 \"  -O z -o /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.merged.sorted.g.vcf.gz; tabix -f -p vcf /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz.log"


### NOT USED
	#echo "bcftools concat -f /scratch/devel/jorkin/STREPS/2021/VCF/$ID/fofn -n -Ou| bcftools filter --threads 1 -e \"TYPE!='snp' | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | AC > 2 | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | QD < 2 | FS >60 | MQ < 40 | SOR > 3 | ReadPosRankSum < -8.0 | MQRankSum < -12.5\" -Oz -o /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.snp.tmp.vcf.gz ;  bcftools sort -T \$TMPDIR -m 4G -Oz -o /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.snp.tmp.vcf.gz;  tabix -f -p vcf /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.snps.vcf.gz.log"
#	echo "bcftools concat -f /scratch/devel/jorkin/STREPS/2021/VCF/$ID/fofn -n | bcftools filter --threads 1 -e \"TYPE!='indel' | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | QD < 2 | FS > 200 | MQ < 40 | SOR > 3 | ReadPosRankSum < -20.0 \"  -O z -o /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.indels.tmp.vcf.gz ;  bcftools sort -T \$TMPDIR -m 4G -Oz -o /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.indels.tmp.vcf.gz ; tabix -f -p vcf /scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/${ID}/${ID}.variable.filtered.HF.indels.vcf.gz.log"
done

