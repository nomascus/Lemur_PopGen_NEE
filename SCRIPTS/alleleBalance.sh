module load bcftools

INDIR='/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE'
OUTDIR='/scratch/devel/jorkin/STREPS/2021/VCF/SINGLE'

cat $1 | while read meta; do
	sample=$(echo $meta | awk '{print $1}')

# List of allele balance values from het sites
# Bed file of het sites that pass allele balance filter
# Bed file of all het sites;
# Bed file of het sites that fail allele balance filter

echo "bcftools query -i \"GT='het'\" -f '%CHROM\t%POS\t%POS\t%REF\t%ALT\n' $INDIR/$sample/${sample}.variable.filtered.HF.snps.vcf.gz > $OUTDIR/$sample/${sample}.variable.filtered.HF.snps.het.bed;bcftools query -i \"GT='het'\" -f '%CHROM\t%POS\t%POS\t[%AD]\n' $INDIR/$sample/${sample}.variable.filtered.HF.snps.vcf.gz | perl -lane ' (\$AD1,\$AD2) = split(\",\" , \$F[3]); print \"\$AD1\t\$AD2\"' > $OUTDIR/$sample/${sample}.variable.filtered.HF.snps.allele_balance.txt;bcftools query -i \"GT='het'\" -f '%CHROM\t%POS\t%POS\t[%AD]\n' $INDIR/$sample/${sample}.variable.filtered.HF.snps.vcf.gz | perl -lane ' (\$AD1,\$AD2) = split(\",\" , \$F[3]); \$AB=\$AD1/(\$AD1+\$AD2) ;  if (\$AB <0.75 & \$AB > 0.25) {print \"\$F[0]\t\$F[1]\t\$F[2]\"}'  > $OUTDIR/$sample/${sample}.variable.filtered.HF.snps.AB_pass.bed; bcftools query -i \"GT='het'\" -f '%CHROM\t%POS\t%POS\t[%AD]\n' $INDIR/$sample/${sample}.variable.filtered.HF.snps.vcf.gz | perl -lane ' (\$AD1,\$AD2) = split(\",\" , \$F[3]); \$AB=\$AD1/(\$AD1+\$AD2) ;  if (\$AB >0.75 | \$AB < 0.25) {print \"\$F[0]\t\$F[1]\t\$F[2]\"}'  > $OUTDIR/$sample/${sample}.variable.filtered.HF.snps.AB_fail.bed^$INDIR/$sample/${sample}.allele_balance.log";


done



# bed file of all het sites

#bcftools query -i "GT='het'" -f '%CHROM\t%POS\t%POS\t%REF\t%ALT\n'  /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.vcf.gz > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.het.bed

# List of allele balance values from het sites

#bcftools query -i "GT='het'" -f '%CHROM\t%POS\t%POS\t[%AD]\n' /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.vcf.gz | perl -lane ' ($AD1,$AD2) = split("," , $F[3]); print "$AD1\t$AD2"' > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.allele_balance.txt


# Bed file of het sites that pass allele balance filter

#bcftools query -i "GT='het'" -f '%CHROM\t%POS\t%POS\t[%AD]\n' /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.vcf.gz     | perl -lane ' ($AD1,$AD2) = split("," , $F[3]); $AB=$AD1/($AD1+$AD2) ;  if ($AB <0.75 & $AB > 0.25) {print "$F[0]\t$F[1]\t$F[2]"}' > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.AB_pass.bed

# Bed file of het sites that fail allele balance filter

#bcftools query -i "GT='het'" -f '%CHROM\t%POS\t%POS\t[%AD]\n' /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.vcf.gz     | perl -lane ' ($AD1,$AD2) = split("," , $F[3]); $AB=$AD1/($AD1+$AD2) ;  if ($AB >0.75 | $AB < 0.25) {print "$F[0]\t$F[1]\t$F[2]"}' > /scratch/devel/jorkin/STREPS/2021/VCF/SINGLE/Eulemur_albifrons_DLC_5547/Eulemur_albifrons_DLC_5547.variable.filtered.HF.snps.AB_fail.bed

