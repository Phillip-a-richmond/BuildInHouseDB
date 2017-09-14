# This shell script will build an in-house database from a directory of VCFs. 

# Briefly, the flow will go like this:

# 1) Prepare all VCFs for merging with bgzip and tabix (bgzip,tabix)
# 2) Merge all VCFs into a single VCF (vcf-merge)
# 3) Normalize and decompose the VCF (vt)
# 4) Tabix and bgzip the final VCF (tabix,bgzip)

DateOfCreation=`date +%Y%m%d`
VCFDIR=/mnt/causes-data01/data/Databases/InHouseDatabase/VCF/
MERGEDVCF=/mnt/causes-data01/data/Databases/InHouseDatabase/MergedVCF.${DateOfCreation}.vcf
MERGEDVCFNORMGZ=/mnt/causes-data01/data/Databases/InHouseDatabase/MergedVCF.${DateOfCreation}.norm.vcf.gz
DBSTATSFILE=/mnt/causes-data01/data/Databases/InHouseDatabase/DBStats.${DateOfCreation}.txt
GENOME_FASTA='/mnt/causes-data01/data/GENOMES/hg19/FASTA/hg19.fa'

rm $DBSTATSFILE
echo "This version of the database was created on (YMD):	$DateOfCreation" >> $DBSTATSFILE

# Step 1
cd $VCFDIR
for vcf in ${VCFDIR}*vcf
do
	ls $vcf
	if [ ! -f ${vcf}.gz ] 
	then
                echo "bgzipping and tabix indexing this file:	$vcf"
		bgzip -c $vcf > ${vcf}.gz
		tabix -p vcf ${vcf}.gz
	else 
		echo "This file already has been indexed:	$vcf"
		ls $vcf
		ls ${vcf}.gz
		ls ${vcf}.gz.tbi	
		
        fi
	echo "${vcf}.gz" >> $DBSTATSFILE
done

TotalSamples=`ls -l $VCFDIR/*gz | wc -l`
echo "There are $TotalSamples in this version of the database" >> $DBSTATSFILE

# Step 2
#bcftools merge --threads 16 -0 $VCFDIR/*vcf.gz > $MERGEDVCF
#bgzip -c $MERGEDVCF > ${MERGEDVCF}.gz


# Step 3
zless ${MERGEDVCF}.gz  \
	| /opt/tools/vt/vt decompose -s - \
	| /opt/tools/vt/vt normalize -r $GENOME_FASTA - \
	| bgzip -c > $MERGEDVCFNORMGZ
tabix -p vcf $MERGEDVCFNORMGZ	




