module load bcftools/1.14; module unload bedtools; module load BEDTools/2.29.0

ref=$1
length_ref=$(echo $ref | perl -slane '$len = length($refname); print $len' -- -refname=$ref) 
indir="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref/MERGED_WINDOWS/" #note that there msut be a / here for the calculation to work
outdir="/scratch/devel/jorkin/STREPS/2021/VCF/MERGED/$ref"

length_indir=$(echo $ref | perl -slane '$len = length($ind); print $len' -- -ind=$indir)
length=$(expr $length_ref + $length_indir + 5 + 1) # There is also an extr _ref_ in the file names, thus the addtional 5, and the lenght is missing 1 for some reason

infiles=$(ls ${indir}*snp.sampleFilt.callable.ab.vcf.gz | sort -nk 1.${length} | tr '\n' ' ')

# Concatenate and remove any SNP that crosses indel (ALT=*), or has no variation
echo "bcftools concat -n $infiles | bcftools filter -e 'ALT=\"*\"| AC==0 || AC==AN' -Oz -o $outdir/${ref}_snp.sampleFilt.callable.ab.poly.vcf.gz^$outdir/${ref}_snp.sampleFilt.callable.ab.poly.vcf.gz.log"

