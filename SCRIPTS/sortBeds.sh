# sorts gziped bedfiles in batch from list of samples

cat $1 | while read meta;do
	ID=$(echo $meta | awk '{print $1}')
	DIR='/scratch/devel/jorkin/STREPS/2021/CALLABILITY_MASKS/SINGLE'

	echo "zcat $DIR/${ID}/${ID}.callable.ABfilter.bed.gz | sort -k1,1V -k2,2n | bgzip >$DIR/${ID}/${ID}.callable.ABfilter.sort.bed.gz; tabix -p bed $DIR/${ID}/${ID}.callable.ABfilter.sort.bed.gz^$DIR/${ID}/${ID}.callable.ABfilter.sort.bed.gz.log" 

done


