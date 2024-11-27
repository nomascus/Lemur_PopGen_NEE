# Run from ~/scratch/STREPS/MAPPING directory
# bash ~/scratch/STREPS/bin/merge_mappings_rg.sh ~/scratch/STREPS/MAPPING/batch_metadata/CGL_19_20190515/LemurCattaRef_MappingInfo
# bash ~/scratch/STREPS/bin/merge_mappings_rg.sh ~/scratch/STREPS/MAPPING/batch_metadata/CGL_22_20190813/LemurCattaRef_MappingInfo
# bash ~/scratch/STREPS/bin/merge_mappings_rg.sh ~/scratch/STREPS/MAPPING/batch_metadata/CGL_23_20190920/LemurCattaRef_MappingInfo
# bash ~/scratch/STREPS/bin/merge_mappings_rg.sh ~/scratch/STREPS/MAPPING/batch_metadata/CGL_26_20200130/LemurCattaRef_MappingInfo


#module unload samtools python bwa; module load gcc/4.9.3-gold BWA/0.7.15 SAMTOOLS/1.9 SEQTK/1.2 PYTHON/3.6.3 BIOBAMBAM/2.0.35

module unload samtools python bwa; 
module load gcc/6.3.0 BWA/0.7.15 SAMTOOLS/1.9 PYTHON/3.6.3 BIOBAMBAM

TRIM_DIR="/home/devel/jorkin/scratch/STREPS/2021/TRIM_MAP_SORT"
MERGE_DIR="/home/devel/jorkin/scratch/STREPS/2021/BAMS_MERGED"


#cat $1 | while read meta;do
#	id=$(echo $meta | awk '{print $1}')
#	UMI=$(echo $meta | awk '{print $2}')
#	refSp=$(echo $meta | awk '{print $3}')
#	refID=$(echo $meta | awk '{print $4}')
#	PCR=$(echo $meta | awk '{print $5}')
#	batch=$(echo $meta | awk '{print $6}')

#	ls $TRIM_DIR/${id}/*sorted.bam > $MERGE_DIR/${id}/fofn; 

cat $1 | while read meta; do
	id=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}')

	mkdir -p $MERGE_DIR
	mkdir -p $MERGE_DIR/${species}_${id}
	mkdir -p $MERGE_DIR/${species}_${id}/COMMANDS
	mkdir -p $MERGE_DIR/${species}_${id}/ERROR

	ls $TRIM_DIR/${id}/*sort.bam > $TRIM_DIR/${id}/${id}_bamlist.txt

	#echo "samtools merge -@8 -b ${TRIM_DIR}/${id}/${id}_bamlist.txt - | bammarkduplicates O=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam markthreads=8 tmpfile=\$TMPDIR/${id}.markdup.tmp; samtools index ${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam; java -jar /apps/PICARD/2.8.2/picard.jar AddOrReplaceReadGroups I=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam O=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.addRG.bam RGID=$id RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$id ; samtools index ${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.addRG.bam" > ${MERGE_DIR}/${species}_${id}/COMMANDS/${species}_${id}.markdup.merged.addRG.sh;
	echo "samtools merge -@8 -b ${TRIM_DIR}/${id}/${id}_bamlist.txt - | bammarkduplicates O=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam markthreads=8 tmpfile=${MERGE_DIR}/${species}_${id}/${id}.markdup.tmp; samtools index ${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam; java -jar /apps/PICARD/2.8.2/picard.jar AddOrReplaceReadGroups I=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.bam O=${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.addRG.bam RGID=$id RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=$id ; samtools index ${MERGE_DIR}/${species}_${id}/${species}_${id}.markdup.merged.addRG.bam" > ${MERGE_DIR}/${species}_${id}/COMMANDS/${species}_${id}.markdup.merged.addRG.sh;


#submit.py -o ${MERGE_DIR}/${species}_${id}/ERROR/${species}_${id}.merged.out -e ${MERGE_DIR}/${species}_${id}/ERROR/${species}_${id}.merged.err -p main -r highprio -u 1 -w'01:00:00' -n ${id}_merge -c"bash ${MERGE_DIR}/${species}_${id}/COMMANDS/${species}_${id}.markdup.merged.addRG.sh";

submit.py -o ${MERGE_DIR}/${species}_${id}/ERROR/${species}_${id}.merged.out -e ${MERGE_DIR}/${species}_${id}/ERROR/${species}_${id}.merged.err -p main -u 8 -w'24:00:00' -n ${id}_merge -c"bash ${MERGE_DIR}/${species}_${id}/COMMANDS/${species}_${id}.markdup.merged.addRG.sh";


 done
