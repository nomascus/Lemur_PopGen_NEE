module load bcftools/1.14

line=$1
outdir="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$line"

mkdir -p $outdir
mkdir -p $outdir/LOG
mkdir -p $outdir/$ref/SORT

echo "bcftools sort -m 4G -T $outdir/SORT/ -Oz -o $outdir/${line}_snp.sampleFilt.callable.ab.poly.sort.vcf.gz $outdir/${line}_snp.sampleFilt.callable.ab.poly.vcf.gz; tabix -f -p vcf $outdir/${line}_snp.sampleFilt.callable.ab.poly.sort.vcf.gz^$outdir/LOG/${line}_snp.sampleFilt.callable.ab.poly.vcf.gz.log"

