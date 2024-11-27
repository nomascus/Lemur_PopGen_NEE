# Run GATK 4 to combine GVCF chunks for joint genotyping
# bash /scratch/devel/jorkin/STREPS/2021/SCRIPTS/combineGVCF.sh /scratch/devel/jorkin/STREPS/2021/METADATA/combineGVCF_Eulemur1.txt

# Metadata file should be tab separated reference genome, species, followed list of file names. Make sure there is no whitespace in the names 

module load java GATK/4.1.7.0

baseout="/scratch/devel/jorkin/STREPS/2021/COMBINE_GVCF"
basein="/scratch/devel/jorkin/STREPS/2021/VARIANTS_BPR"

cat $1 | while read meta;do
	refID=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}')
	samples=$(echo $meta | perl -lne '@a = split(/\s/, $_); shift @a; shift @a; print join ("\t", @a);')


	mkdir -p ${baseout}/${species}
	
	for chunk in /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID}*_windows/30_mb_chunks/*bed;do
		#chunkName=$(basename $chunk | sed s/\.bed/\.raw.snps.indels.g.vcf.gz/) 
		chunkName=$(basename $chunk | sed s/\.bed//) 
		varList=$(echo $samples | perl -sne '@a = split(/\s/, $_); foreach $sample (@a) {print " --variant $indir/$sample/$sample" . "_$chunk_name.raw.snps.indels.g.vcf.gz " }' -- -indir=$basein -chunk_name=$chunkName)

#echo $varList;

		echo "java -Xmx15g -Djava.io.tmpdir=\$TMPDIR -jar /apps/GATK/4.1.7.0/gatk-package-4.1.7.0-local.jar CombineGVCFs -R /scratch/devel/jorkin/STREPS/REFERENCES/*/${refID} $varList -O ${baseout}/${species}/${species}_${chunkName}.com.raw.snps.indels.g.vcf.gz^${baseout}/${species}/${species}_${chunkName}.com.raw.snps.indels.g.vcf.gz.log"
	
	done 
done
