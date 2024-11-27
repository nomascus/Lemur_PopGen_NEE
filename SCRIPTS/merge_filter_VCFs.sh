# Mareike's VCF merger script

# merging howler VCFs, followed by filtering VCF by sites callable in all samples
# index all VCFs with gnu parallel

#parallel --joblog logs/index_gnu.log bcftools index /gws/nopw/j04/rotcotm/VCFs/{}.variable.filtered.HF.AD.vcf.gz ::: { PD_0005 PD_0025 PD_0026 PD_0027 PD_0072 PD_0073 PD_0089 PD_0134 PD_0135 PD_0136 PD_0137 PD_0294 PD_0295 PD_0296 PD_0297 PD_0298 PD_0299 PD_0412 PD_0413 PD_0414 PD_0415 PD_0416 PD_0417 PD_0418 PD_0419 PD_0420 PD_0421 PD_0422 PD_0423 PD_0424 PD_0425 PD_0426 PD_0428 PD_0429 PD_0430 }

# merge VCFs
# vcfList is a file containing paths and names of all the VCF files
# -0 tells bcftools to use ref allele for sites not present in file

module load bcftools bedops

vcfList=$1 
bedList=$2
taxon=$3 # e.g. Lemur

beds=""

while read BED; do
	beds+="<(zcat $BED) " 	
	#beds+="$BED " 	

done < $bedList

#echo $beds

inDIR="/scratch/devel/jorkin/STREPS/2021"
outDIR="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$taxon"
comDIR="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/COMMANDS"

mkdir -p $outDIR

echo "echo 'merge vcfs initial' " > $comDIR/merge_filter_VCF.${taxon}.sh

	echo "bcftools merge -l $vcfList -o $outDIR/${taxon}.merged.variable.filtered.HF.snps.ABfilter.vcf.gz -O z -0 --threads 8 " >> $comDIR/merge_filter_VCF.${taxon}.sh

echo "echo 'intersect callable bedfiles to create bedfile that contains only regions callable in all samples' " >> $comDIR/merge_filter_VCF.${taxon}.sh

	echo " bedops --intersect $beds | bgzip > $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.callable.ABfilter.bed.gz" >> $comDIR/merge_filter_VCF.${taxon}.sh

echo " echo 'sort intersected bed file' " >> $comDIR/merge_filter_VCF.${taxon}.sh

# This is in theory useful for reducing the memory requirements of bedtools intersect in the last step. If both files are sorted, you can use the -sorted flag to decrease memory, but it requires that all "chromosomes" present in one file are present in the other and that wasn't the case here, because some of the very short scaffolds didn't have any variants called. I still used the sorted files, but didn't use the -sorted flag and just increased memory

# zcat $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.callable.ABfilter.bed.gz | sort -k1,1V -k2,2n | bgzip  >  $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.intersect.callable.ABfilter.bed.gz
	echo "bedtools sort -i $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.callable.ABfilter.bed.gz |bgzip >  $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.callable.ABfilter.sorted.bed.gz" >> $comDIR/merge_filter_VCF.${taxon}.sh

echo "echo 'sort intersected vcf'" >> $comDIR/merge_filter_VCF.${taxon}.sh

	echo "bcftools sort $outDIR/${taxon}.merged.variable.filtered.HF.snps.ABfilter.vcf.gz -T \$TMPDIR -m 4000M -Oz -o $outDIR/${taxon}.merged.variable.filtered.HF.snps.ABfilter.sorted.vcf.gz" >> $comDIR/merge_filter_VCF.${taxon}.sh

echo " echo 'intersect VCF and BED file to keep only calls that are present in BED file' " >> $comDIR/merge_filter_VCF.${taxon}.sh
# 30G memory enough for this case, might need more 

	echo "bedtools intersect -wa -header -a $outDIR/${taxon}.merged.variable.filtered.HF.snps.ABfilter.sorted.vcf.gz -b $inDIR/CALLABILITY_MASKS/MERGED/${taxon}.callable.ABfilter.bed.gz |bgzip > $outDIR/${taxon}.merged.callable.variable.filtered.HF.snps.ABfilter.vcf.gz; tabix -p vcf $outDIR/${taxon}.merged.callable.variable.filtered.HF.snps.ABfilter.vcf.gz" >> $comDIR/merge_filter_VCF.${taxon}.sh

# VCF is a merged VCF from all individuals in genus, BED file is intersected BED file of all callable regions from all individuals in genus. Result is a VCF file that only contains SNP calls that were callable for all individuals. 

# Remove intermediate files



