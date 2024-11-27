# Calculates the heterzygosity from a list of individuals across all callable sites. Requires metadata file from standard input with format:
	# SeqID\tGenus\tSpecies
	# e.g. PD_0145	Arctocebus_calabarensis 
	# e.g. SampleIDsSpeciesTMP.txt

# Calculate the total number of callable sites in the genome
# Calculate the number of heterozygous positions in the VCF.
# Divide heterozygous by total positions 


# bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/Heterozygosity_perBase_batch.sh /scratch/devel/jorkin/STREPS/2021/METADATA/SampleList_short.txt 

module unload gcc
module load gcc/6.3.0
module load bcftools

OUTDIR="/home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE"
CALLABLE="/home/devel/jorkin/scratch/STREPS/2021/CALLABLE"
VCFpath="/home/devel/jorkin/scratch/STREPS/2021/VCF"

cat $1 | while read meta;do
	PD=$(echo $meta | awk '{print $1}')
	Genus=$(echo $meta | perl -lne '@a=split(" ", $_); ($genus,$species)=split('_',$a[1]); print $genus')
	Species=$(echo $meta  | perl -lne '@a=split(" ", $_); ($genus,$species)=split('_',$a[1]); print $species')
	ID=${Genus}_${Species}_${PD}


mkdir -p ${OUTDIR}/${ID}/COMMANDS
mkdir -p ${OUTDIR}/${ID}/ERROR

echo "cat $CALLABLE/${ID}/${ID}.snps.filtered.callable.bed | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=\$3-\$2 }END{print SUM}' > ${OUTDIR}/${ID}/${ID}.variable.filtered.callable.bed.sum" > ${OUTDIR}/${ID}/COMMANDS/${ID}.Het_perBase.sh;

echo "bcftools query -i 'TYPE=\"SNP\" & GT=\"het\"' -f \"%CHROM\t%POS0\t%POS\t%REF\t%ALT\n\" $VCFpath/${ID}/${ID}.callable.filtered.vcf.gz | wc -l > ${OUTDIR}/${ID}/${ID}.callable.filtered.snps.vcf.nhets.sum" >> ${OUTDIR}/${ID}/COMMANDS/${ID}.Het_perBase.sh;

echo "nhets=\$(cat /home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE/${ID}/${ID}.callable.filtered.snps.vcf.nhets.sum); ncall=\$(cat /home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE/${ID}/${ID}.variable.filtered.callable.bed.sum); echo print \$nhets/\$ncall | perl | perl -lne '\$round = sprintf(\"%.6f\", \$_); print \$round' > ${OUTDIR}/${ID}/${ID}.callable.filtered.snps.vcf.HetPairwise" >> $OUTDIR/${ID}/COMMANDS/${ID}.Het_perBase.sh;

#echo "nhets=\$(cat ${OUTDIR}/${Genus}_${Species}_${ID}.variable.filtered.HF.snps.vcf.gz.nhets.sum); ncall=\$(cat ${OUTDIR}/${Genus}_${Species}_${ID}.variable.filtered.callable.bed.sum);" echo "print \$nhets/\$ncall | perl -pe 'sprintf("%.5f", \$_)' > ${OUTDIR}/${Genus}_${Species}_${ID}.variable.filtered.HF.snps.vcf.gz.HetPairwise" >> $OUTDIR/COMMANDS/${Genus}_${Species}_${ID}.Het_perBase.sh;

submit.py -r highprio -o $OUTDIR/$ID/ERROR/${ID}.Heterozygosity_perBase.out -e $OUTDIR/$ID/ERROR/${ID}.Heterozygosity_perBase.err -p main -u 1 -w'00:30:00' -n Het_${PD}_${Species}_${Genus} -c"bash $OUTDIR/${ID}/COMMANDS/${ID}.Het_perBase.sh"

done


