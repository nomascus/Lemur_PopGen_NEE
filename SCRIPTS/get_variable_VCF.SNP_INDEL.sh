cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	INDIR=$(echo $meta | awk '{print $2}')
	#ls ./VARIANTS_BPR/${ID}/${ID}*.snps.indels.genotyped.g.vcf.gz > ./VARIANTS_CLEAN/${ID}/${ID}_filtered_gvcfs

	#these are EXCLUSIVE filters! bear in mind when assigning < > 

	mkdir -p /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}
	ls $INDIR/$ID/${ID}*.raw.snps.indels.genotyped.g.vcf.gz > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/$ID/${ID}.gvcfList 

	echo "bcftools concat -n -f /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/$ID/${ID}.gvcfList -Ou | bcftools filter --threads 1 -e \"(GT='0/0' | GT='./.')\" -Ou | bcftools sort -T \$TMPDIR -O z -o /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.merged.sorted.g.vcf.gz^/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/${ID}/${ID}.variable.merged.sorted.g.vcf.gz.log" 

done
