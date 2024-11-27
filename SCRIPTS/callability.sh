
module load bedtools; bcftools

# not sure why bcftools view leaves the ref indel positions in the VCF, but I added the perl line to remove them

bcftools filter -e 'AC>2 || QD<2 || FS>60.0 || SOR>3 || MQ<40 || ReadPosRankSum<-8.0 || MQRankSum <-12.5 || FORMAT/DP<10 || FORMAT/DP>100 || RGQ<20' --SnpGap 10 ../gVCF/Arctocebus_calabarensis_PD_0438/Arctocebus_calabarensis_PD_0438_0.raw.snps.indels.genotyped.g.vcf.gz | bcftools view -U -V indels| perl -lane 'if(/^#/ or length("$F[3]")==1){print}' |bedtools merge

bcftools concat -f fileList.txt | bcftools filter -e 'AC>2 || QD<2 || FS>60.0 || SOR>3 || MQ<40 || ReadPosRankSum<-8.0 || MQRankSum <-12.5 || FORMAT/DP<10 || FORMAT/DP>100 || RGQ<20' --SnpGap 10 ../gVCF/Arctocebus_calabarensis_PD_0438/Arctocebus_calabarensis_PD_0438_0.raw.snps.indels.genotyped.g.vcf.gz | bcftools view -U -V indels| perl -lane 'if(/^#/ or length("$F[3]")==1){print}' |bgzip > test.vcf.gz

bcftools concat -f fileList.txt | bcftools filter -e 'AC>2 || QD<2 || FS>60.0 || SOR>3 || MQ<40 || ReadPosRankSum<-8.0 || MQRankSum <-12.5 || FORMAT/DP<10 || FORMAT/DP>100 || RGQ<20' --SnpGap 10  | bcftools view -U -v snps| bgzip > test.vcf.gz


