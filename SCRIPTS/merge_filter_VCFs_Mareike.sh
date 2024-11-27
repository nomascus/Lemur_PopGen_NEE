# Mareike's VCF merger script

# merging howler VCFs, followed by filtering VCF by sites callable in all samples
# index all VCFs with gnu parallel

parallel --joblog logs/index_gnu.log bcftools index /gws/nopw/j04/rotcotm/VCFs/{}.variable.filtered.HF.AD.vcf.gz ::: { PD_0005 PD_0025 PD_0026 PD_0027 PD_0072 PD_0073 PD_0089 PD_0134 PD_0135 PD_0136 PD_0137 PD_0294 PD_0295 PD_0296 PD_0297 PD_0298 PD_0299 PD_0412 PD_0413 PD_0414 PD_0415 PD_0416 PD_0417 PD_0418 PD_0419 PD_0420 PD_0421 PD_0422 PD_0423 PD_0424 PD_0425 PD_0426 PD_0428 PD_0429 PD_0430 }

# merge VCFs
# Alouatta.txt is a file containing paths and names of all the VCF files
# -0 tells bcftools to use ref allele for sites not present in file

bcftools merge -l Alouatta.txt -o mergedVCFs/Alouatta.merged.snps.vcf.gz -O z -0 --threads 8

# intersect callable bedfiles to create bedfile that contains only regions callable in all samples
$HOME/software/bedops/bin/bedops --intersect \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0005.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0025.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0026.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0027.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0072.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0073.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0089.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0134.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0135.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0136.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0137.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0294.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0295.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0296.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0297.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0298.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0299.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0412.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0413.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0414.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0415.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0416.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0417.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0418.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0419.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0420.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0421.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0422.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0423.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0424.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0425.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0426.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0428.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0429.variable.filtered.HF.AD.vcf.callable.bed.gz) \
<(zcat /gws/nopw/j04/rotcotm/VCFs/PD_0430.variable.filtered.HF.AD.vcf.callable.bed.gz) > $HOME/projects/EEMS/intersectBEDs/Alouatta.intersect.callable.bed

# sort bed file and vcf file to have sorting be compatible
# This is in theory useful for reducing the memory requirements of bedtools intersect in the last step. If both files are sorted, you can use the -sorted flag to decrease memory, but it requires that all "chromosomes" present in one file are present in the other and that wasn't the case here, because some of the very short scaffolds didn't have any variants called. I still used the sorted files, but didn't use the -sorted flag and just increased memory
sort -k1,1V -k2,2n $HOME/projects/EEMS/intersectBEDs/Alouatta.intersect.callable.bed > $HOME/projects/EEMS/intersectBEDs/Alouatta.intersect.callable.sorted.bed

bcftools sort /gws/nopw/j04/rotcotm/mergedVCFs/Alouatta.merged.snps.vcf.gz -T /work/scratch-nopw/mjaniak -m 4000M -Oz -o /gws/nopw/j04/rotcotm/mergedVCFs/Alouatta.merged.snps.sorted.vcf.gz

# intersect VCF and BED file to keep only calls that are present in BED file
# 30G memory enough for this case, might need more 
$HOME/software/bedtools intersect -wa -header -a /gws/nopw/j04/rotcotm/mergedVCFs/Alouatta.merged.snps.sorted.vcf.gz -b $HOME/projects/EEMS/intersectBEDs/Alouatta.intersect.callable.sorted.bed > /gws/nopw/j04/rotcotm/filteredVCFs/Alouatta.merged.filtered.vcf

# VCF is a merged VCF from all individuals in genus, BED file is intersected BED file of all callable regions from all individuals in genus. Result is a VCF file that only contains SNP calls that were callable for all individuals. 

