# module load BCFTOOLS/1.9 BEDOPS/2.4.20
# ERROR here in that I need to sort the beds

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	INDIR=$(echo $meta | awk '{print $2}')
	MIN_COV=$(echo $meta | awk '{print $3}')
	MAX_COV=$(echo $meta | awk '{print $4}')
	MIN_HET_AD=3

	#ls ./VARIANTS_BPR/${ID}/${ID}*.snps.indels.genotyped.g.vcf.gz > ./VARIANTS_CLEAN/${ID}/${ID}_filtered_gvcfs

	#these are EXCLUSIVE filters! bear in mind when assigning < > 

	mkdir -p /scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE/${ID}
	#ls $INDIR/$ID/${ID}*.raw.snps.indels.genotyped.g.vcf.gz > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/$ID/${ID}.gvcfList 

#	echo "bcftools concat -n -f /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/$ID/${ID}.gvcfList -Ou | bcftools filter -e \"(GT='./.') | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | FMT/GQ <= 30\" -Ou | bcftools sort -T \$TMPDIR -O z /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.callable.merged.sorted.g.vcf.gz; tabix -f -p vcf /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.callable.merged.sorted.g.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.callable.merged.sorted.g.vcf.gz.log" 

	echo "bcftools concat -n -f /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/$ID/${ID}.gvcfList -Ou | bcftools filter -e \"(GT='./.') | (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | FMT/GQ <= 30\" -Ov | grep -v \"#\"| perl -lne '@a = split (\"\t\",\$_); \$start=\$a[1]-1; print \"\$a[0]\t\$start\t\$a[1]\"' |sort -T \$TMPDIR -k 1,1 -k2,2n | bedtools merge |  bgzip > /scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE/${ID}/${ID}.callable.bed.gz; tabix -f -p bed /scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE/${ID}/${ID}.callable.bed.gz^/scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE/${ID}/${ID}.callable.bed.gz.log"

done


