module load bcftools/1.14; module unload bedtools; module load BEDTools/2.29.0

#Filters are EXCLUSIVE! bear in mind when assigning < >

ref=$1
samplelist=$2
indir='/scratch/devel/jorkin/STREPS/2021/VCF/MERGED'
outdir="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref"
MIN_HET_AD='3';

mkdir -p $outdir
mkdir -p $outdir/LOG
mkdir -p $outdir/MERGED_WINDOWS
mkdir -p $outdir/TMP

while read gvcflist; do 
	region=$(echo $gvcflist | perl -lne '$r=$_; $r =~ s/^\w+_(\d+)\.txt/$1/; print $r');
#	echo $region

# Merge gVCFs across individuals within 30 mb windows keeping only SNPs
#	echo -n "bcftools merge -l /scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref/gVCFlists/$gvcflist -Ou -o -| bcftools filter -e \"TYPE!='snp'\" -Oz -o $outdir/TMP/${ref}_${region}.gvcfMerge.popSnpPos.unfiltered.vcf.gz; "

	# split individuals from 30 mb Filter 
	while read line; do
		sample=$(echo $line |awk '{print $1}')
		MIN_COV=$(echo $line |awk '{print $2}') 
		MAX_COV=$(echo $line |awk '{print $3}') 
 
		echo -n "bcftools view --threads 4 -s $sample -Oz -o ${outdir}/TMP/${ref}_${region}_${sample}.gvcfMerge.popSnpPos.unfiltered.vcf.gz $outdir/TMP/${ref}_${region}.gvcfMerge.popSnpPos.unfiltered.vcf.gz; bedtools intersect -header -a ${outdir}/TMP/${ref}_${region}_${sample}.gvcfMerge.popSnpPos.unfiltered.vcf.gz -b /scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE/$sample/${sample}.callable.ABfilter.bed.gz | bcftools filter --threads 4 -e \"TYPE!='snp' & ( (GT='het' & FMT/AD[*:*] < $MIN_HET_AD ) | AC > 2 | FMT/DP <= $MIN_COV | FMT/DP >= $MAX_COV | QD < 2 | FS >60 | MQ < 40 | SOR > 3 | ReadPosRankSum < -8.0 | MQRankSum < -12.5)\" -Oz -o $outdir/TMP/${ref}_${region}_${sample}.gvcfMerge.popSnpPos.filtered.callable.vcf.gz; tabix -f -p vcf $outdir/TMP/${ref}_${region}_${sample}.gvcfMerge.popSnpPos.filtered.callable.vcf.gz; " 

	done < $samplelist
	echo "^$outdir/LOG/${ref}_${region}.snp.indFilt.vcf.gz.log";

done < <(ls /scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref/gVCFlists) 

