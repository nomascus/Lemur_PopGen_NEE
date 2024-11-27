# Convert Raw Bayor Bam files into ~5G split fastqs

# Metadata file /home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_STREPS_FASTQ/METADATA/Metadata_bam2fq_Baylor_AyeAye.tsv :  example below  
# DLC_6451	Daubentonia_madagascariensis	Daubentonia_madagascariensis	/home/devel/jorkin/scratch/STREPS/REFERENCES	Daubentonia_madagascariensis.fasta	100934	BaylorAyeAye	/home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_NEW/20210329	.bam

working_dir="/home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_AyeAye_BAM/20210329"
out_dir="/home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_STREPS_FASTQ"

cat $1 | while read meta;do
        ID=$(echo $meta | awk '{print $1}')
        Species=$(echo $meta | awk '{print $2}')
        refSp=$(echo $meta | awk '{print $3}')
        refPath=$(echo $meta | awk '{print $4}')
        refID=$(echo $meta | awk '{print $5}')
        BaylorID=$(echo $meta | awk '{print $6}')
        batch=$(echo $meta | awk '{print $7}')
        BamPath=$(echo $meta | awk '{print $8}')
    
        mkdir -p ${out_dir}/${Species}_${ID}
        mkdir -p ${out_dir}/${Species}_${ID}/COMMANDS
        mkdir -p ${out_dir}/${Species}_${ID}/ERROR

echo "bamtofastq < $BamPath/${BaylorID}.bam outputperreadgroup=1 gz=1 outputperreadgroupprefix=${Species}_${ID} outputdir=${out_dir}/${Species}_${ID}" > ${out_dir}/${Species}_${ID}/COMMANDS/${Species}_${ID}_bam2fastq.sh 

submit.py -o ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.out -e ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.err -u 1 -p main -w'15:00:00' -n ${ID}_bam2fq -c"bash ${out_dir}/${Species}_${ID}/COMMANDS/${Species}_${ID}_bam2fastq.sh ";

#submit.py -o ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.out -e ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.err -u 1 -p main -w'00:15:00' -n ${ID}_bam2fq -r highprio -c"bash ${out_dir}/${Species}_${ID}/COMMANDS/${Species}_${ID}_bam2fastq.sh ";


done
