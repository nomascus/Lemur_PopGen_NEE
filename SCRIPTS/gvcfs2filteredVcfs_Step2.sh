module load bcftools/1.14; module unload bedtools; module load BEDTools/2.29.0

#Filters are EXCLUSIVE! bear in mind when assigning < >

ref=$1
samplelist=$2
indir='/scratch/devel/jorkin/STREPS/2021/VCF/MERGED'
outdir="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref"

mkdir -p $outdir
mkdir -p $outdir/LOG
mkdir -p $outdir/MERGED_WINDOWS
mkdir -p $outdir/TMP

while read gvcflist; do 
	infiles=''
	region=$(echo $gvcflist | perl -lne '$r=$_; $r =~ s/^\w+_(\d+)\.txt/$1/; print $r');
#	echo $region

	# split individuals from 30 mb Filter 
	while read line; do
		sample=$(echo $line |awk '{print $1}')
		infiles=$(echo "$infiles $outdir/TMP/${ref}_${region}_${sample}.gvcfMerge.popSnpPos.filtered.callable.vcf.gz")
	done < $samplelist
	
	infiles=$(ls $outdir/TMP/${ref}_${region}_*gvcfMerge.popSnpPos.filtered.callable.vcf.gz | tr '\n' ' ')

# Merge filtered individual VCFs back together in 30 mb chunks while removing indel spanning SNPs (* ALT positions)

	echo "bcftools merge $infiles -Oz -o $outdir/MERGED_WINDOWS/${ref}_ref_${region}.snp.sampleFilt.callable.ab.vcf.gz; tabix -f -p vcf $outdir/MERGED_WINDOWS/${ref}_ref_${region}.snp.sampleFilt.callable.ab.vcf.gz^$outdir/LOG/${ref}_${region}.snp.indFilt.MERGE.vcf.gz.log"

done < <(ls /scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref/gVCFlists) 

