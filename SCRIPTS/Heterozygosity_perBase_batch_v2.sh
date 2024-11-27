# Calculates the heterzygosity from a list of individuals across all callable sites. Requires metadata file from standard input with format:
	# Seqsample\tGenus\tSpecies
	# e.g. PD_0145	Arctocebus_calabarensis 
	# e.g. SamplesamplesSpeciesTMP.txt

# Calculate the total number of callable sites in the genome
# Calculate the number of heterozygous positions in the VCF.
# Divide heterozygous by total positions 


# bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/Heterozygosity_perBase_batch.sh /scratch/devel/jorkin/STREPS/2021/METADATA/SampleList_short.txt 

module unload gcc
module load gcc/6.3.0
module load bcftools

OUTDIR="/home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE"
CALLABLE="/home/devel/jorkin/scratch/STREPS/2021/CALLABILITY_MASKS/SINGLE"
VCFpath="/home/devel/jorkin/scratch/STREPS/2021/VCF/SINGLE"

cat $1 | while read meta;do
	sample=$(echo $meta | awk '{print $1}')

mkdir -p ${OUTDIR}/${sample}/COMMANDS
mkdir -p ${OUTDIR}/${sample}/ERROR


echo "#!/bin/bash

#SBATCH -J hetP.$sample
#SBATCH -D $OUTDIR
#SBATCH -o $OUTDIR/$sample/ERROR/${sample}.HetPairwise.out
#SBATCH -e $OUTDIR/$sample/ERROR/${sample}.HetPairwise.err
#SBATCH -p main
#SBATCH -c 1
#SBATCH -n 1
#SBATCH -c 1
#SBATCH -t 00:30:00

zcat $CALLABLE/${sample}/${sample}.callable.ABfilter.bed.gz | awk -F'\t' 'BEGIN{SUM=0}{ SUM+=\$3-\$2 }END{print SUM}' > ${OUTDIR}/${sample}/${sample}.callable.ABfilter.bed.sum; \
bcftools query -i 'TYPE=\"SNP\" & GT=\"het\"' -f \"%CHROM\t%POS0\t%POS\t%REF\t%ALT\n\" $VCFpath/${sample}/${sample}.variable.filtered.HF.snps.ABfilter.vcf.gz | wc -l > ${OUTDIR}/${sample}/${sample}.variable.filtered.HF.snps.ABfilter.vcf.nhets.sum; \
nhets=\$(cat /home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE/${sample}/${sample}.variable.filtered.HF.snps.ABfilter.vcf.nhets.sum); ncall=\$(cat /home/devel/jorkin/scratch/STREPS/2021/HETEROZYGOSITY/PAIRWISE/${sample}/${sample}.callable.ABfilter.bed.sum); echo print \$nhets/\$ncall | perl | perl -lne '\$round = sprintf(\"%.6f\", \$_); print \$round' > ${OUTDIR}/${sample}/${sample}.variable.filtered.ABfilter.snps.vcf.HetPairwise" > $OUTDIR/${sample}/COMMANDS/${sample}.Het_perBase.sbatch

sbatch $OUTDIR/${sample}/COMMANDS/${sample}.Het_perBase.sbatch 

done

