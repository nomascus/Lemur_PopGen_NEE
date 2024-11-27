# Calculate basepair depth from merged bamfiles using mosdepth

# bash  /scratch/devel/jorkin/SCRIPTS/depth_beds.sh  /scratch/devel/jorkin/METADATA/SampleList.txt

bamDIR='/home/devel/jorkin/scratch/STREPS/2021/BAMS_MERGED'
outDIR='/home/devel/jorkin/scratch/STREPS/2021/DEPTH'

cat $1 | while read meta;do

	PD=$(echo $meta | awk '{print $1}')
	species=$(echo $meta | awk '{print $2}') 
	ID=${species}_${PD}

	mkdir -p $outDIR/${ID}
	mkdir -p $outDIR/${ID}/ERROR
	mkdir -p $outDIR/${ID}/COMMANDS

echo "mosdepth --fast-mode $ID $bamDIR/$ID/${ID}.markdup.merged.addRG.bam " > $outDIR/${ID}/COMMANDS/${ID}_depth.sh

submit.py -o $outDIR/${ID}/ERROR/${ID}_depth.out -e $outDIR/${ID}/ERROR/${ID}_depth.err -p main -u 1 -w'03:00:00' -n depth_${ID} -c"bash $outDIR/${ID}/COMMANDS/${ID}_depth.sh"

done
