module load bcftools

INDIR='/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE'
OUTDIR='/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE'
MASKDIR='/scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE'


cat $1 | while read meta; do
	sample=$(echo $meta | awk '{print $1}')
	mkdir -p $OUTDIR/$sample/COMMANDS
	mkdir -p $OUTDIR/$sample/ERROR

# Bed file of het sites that fail allele balance filter


echo "#!/bin/bash

#SBATCH -J f.$sample 
#SBATCH -D $INDIR 
#SBATCH --priority highprio 
#SBATCH -o $OUTDIR/$sample/ERROR/${sample}.filterAB_vcf_mask-%j.out 
#SBATCH -e $OUTDIR/$sample/ERROR/${sample}.filterAB_vcf_mask-%j.err 
#SBATCH -p main 
#SBATCH -c 1 
#SBATCH -n 1 
#SBATCH -c 1 
#SBATCH -t 02:00:00 

bcftools view -T ^$INDIR/$sample/${sample}.variable.filtered.HF.snps.AB_fail_0b.bed $INDIR/$sample/${sample}.variable.filtered.HF.snps.vcf.gz -Oz -o $INDIR/$sample/${sample}.variable.filtered.HF.snps.ABfilter.vcf.gz; tabix -p vcf $INDIR/$sample/${sample}.variable.filtered.HF.snps.ABfilter.vcf.gz; bedtools subtract -a $MASKDIR/$sample/${sample}.callable.bed.gz -b $INDIR/$sample/${sample}.variable.filtered.HF.snps.AB_fail_0b.bed | bgzip > $MASKDIR/$sample/${sample}.callable.ABfilter.bed.gz; tabix -p bed $MASKDIR/$sample/${sample}.callable.ABfilter.bed.gz" > $OUTDIR/$sample/COMMANDS/filterVCF_allelebalance.sbatch

sbatch $OUTDIR/$sample/COMMANDS/filterVCF_allelebalance.sbatch

#submit.py -i . -r normal -o $OUTDIR/$sample/ERROR/${sample}.filterAB_vcf_mask.out -e $OUTDIR/$sample/ERROR/${sample}.filterAB_vcf_mask.err -p main -u 1 -w'01:00:00' -n f.$sample -c"bash $OUTDIR/$sample/COMMANDS/filterVCF_allelebalance.sh"


done

