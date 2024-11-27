# Convert Raw Bayor Bam files into ~5G split fastqs

# Metadata file /home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_STREPS_FASTQ/METADATA/Metadata_bam2fq_Baylor_AyeAye.tsv :  example below  
# DLC_6451	Daubentonia_madagascariensis	Daubentonia_madagascariensis	/home/devel/jorkin/scratch/STREPS/REFERENCES	Daubentonia_madagascariensis.fasta	100934	BaylorAyeAye	/home/devel/jorkin/scratch/RawReads/STREPS/BAYLOR_NEW/20210329	.bam

indir="/scratch/devel/jorkin/STREPS/RAW_DATA/BAYLOR_ALL_BAM_LINKS"
outdir="/scratch/devel/jorkin/STREPS/FASTQ"

cat $1 | while read meta;do
        ID=$(echo $meta | awk '{print $1}')
    
        mkdir -p ${outdir}/${ID}

echo "bamtofastq < ${indir}/${ID}.bam outputperreadgroup=1 gz=1 outputperreadgroupprefix=${ID} outputdir=${outdir}/${ID}^${outdir}/${ID}.bamtofastq.log"  

#submit.py -o ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.out -e ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.err -u 1 -p main -w'15:00:00' -n ${ID}_bam2fq -c"bash ${out_dir}/${Species}_${ID}/COMMANDS/${Species}_${ID}_bam2fastq.sh ";

#submit.py -o ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.out -e ${out_dir}/${Species}_${ID}/ERROR/${Species}_${ID}_bam2fastq.err -u 1 -p main -w'00:15:00' -n ${ID}_bam2fq -r highprio -c"bash ${out_dir}/${Species}_${ID}/COMMANDS/${Species}_${ID}_bam2fastq.sh ";


done
