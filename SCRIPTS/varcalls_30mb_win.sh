# Run GATK 4 haplotype caller on 30 mb chunks of the reference genome to deposit in VARIANTS_BPR directory
# bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/varcalls_30mb_win.sh /scratch/devel/jorkin/STREPS/2021/METADATA/HapCall_Eulemur1.txt


module load java GATK/4.1.7.0

baseout="/scratch/devel/jorkin/STREPS/2021/VARIANTS_BPR"
basein="/scratch/devel/jorkin/STREPS/2021/BAMS_MERGED"

cat $1 | while read meta;do
	inID=$(echo $meta | awk '{print $1}')
	ID=$(echo $meta | awk '{print $2}')  #This should have been print $2. intent was to fix typos in filenames of Eulemur rubriventer that should have been Eulemur rufus
	refID=$(echo $meta | awk '{print $3}')
	PCR=$(echo $meta | awk '{print $4}')

	#echo $ID $refSp $refID	
	#echo $pcr_mode $PCR
	if [[ $PCR == N ]]; then pcr_mode=NONE;fi
	if [[ $PCR == Y ]]; then pcr_mode=CONSERVATIVE;fi

	mkdir -p ${baseout}/${ID}
	#echo $refSp $refID	
	for chunk in /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID}*_windows/30_mb_chunks/*bed;do
		chunkName=$(basename $chunk)
		echo "java -Xmx15g -Djava.io.tmpdir=\$TMPDIR -jar /apps/GATK/4.1.7.0/gatk-package-4.1.7.0-local.jar HaplotypeCaller -R /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID} -I ${basein}/${inID}/${inID}*merged.addRG.bam -ERC BP_RESOLUTION -L $chunk --pcr-indel-model $pcr_mode -O ${baseout}/${ID}/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz^${baseout}/${ID}/${ID}_${chunkName%.bed}.raw.snps.indels.g.vcf.gz.log"
	
	done 
done
