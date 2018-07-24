# Make sure you load your environment
source /opt/tools/hpcenv.sh

# Set SURVIVOR Executable
#SURVIVOR=/opt/tools/SURVIVOR
SURVIVOR=/mnt/causes-data03/new/InhouseSV/VCF/SURVIVOR/Debug/SURVIVOR

# Set the input VCF directory
VCFDir=/mnt/causes-data03/new/InhouseSV/VCF/

# Get the date for tracking build purposes
DateOfCreation=`date +%Y%m%d`

# Get the list of VCFs into a simple file
cd $VCFDir
ls *metaSV.vcf > Sample_VCFs_list_${DateOfCreation}.txt



# Running for both max_dist between edges of 100, and 1000
for MaxDist in {50,100}
do

	# These commands to SURVIVOR invoke this:
	# mergevcf: Consensus Call from multiple SV vcf files
	# Sample_VCFs_list_${DateOfCreation}.txt - Tab file with names
	# max distance between breakpoints - The $MaxDist variable
	# Minimum number of supporting caller - 1
	# Take the type into account (1==yes, else no) - 1
	#  Take the strands of SVs into account (1==yes, else no) - 0
	# Estimate distance based on the size of SV (1==yes, else no). -1
	# Minimum size of SVs to be taken into account. - 50
	# Output prefix 
	
	# Run SURVIVOR
	$SURVIVOR merge \
		Sample_VCFs_list_${DateOfCreation}.txt \
		$MaxDist \
		1 \
		1 \
		0 \
	 	1 \
		50 \
		InHouseDB_SV_${MaxDist}_${DateOfCreation}.vcf
	
	# For Visualization purposes, sort and index the vcf file.
	igvtools sort InHouseDB_SV_${MaxDist}_${DateOfCreation}.vcf  InHouseDB_SV_${MaxDist}_${DateOfCreation}_sorted.vcf
	igvtools index InHouseDB_SV_${MaxDist}_${DateOfCreation}_sorted.vcf
	
	
	# These commands to SURVIVOR invoke this with option 8:
	# vcftobedpe: Convert vcf to bedpe
	# vcf file -InHouseDB_SV_${MaxDist}_${DateOfCreation}.vcf
	# min size
	# max size - 15000000, I set this to 15MB just to get rid of those stupid like half-chromosome artifacts or fully deleted centromere artifacts, Could easily increase this
	# output file - InHouseDB_SV_${MaxDist}_${DateOfCreation}.bedpe
	
	# Convert into BEDPE file 
	$SURVIVOR vcftobed \
		InHouseDB_SV_${MaxDist}_${DateOfCreation}.vcf \
		1 \
		5000000 \
		InHouseDB_SV_${MaxDist}_${DateOfCreation}.bedpe	
	
	
	# Use the BEDPE and the VCF in order to add the SUPP=# to the BEDPE
	python AddFreqToBedpe.py -V InHouseDB_SV_${MaxDist}_${DateOfCreation}.vcf -B InHouseDB_SV_${MaxDist}_${DateOfCreation}.bedpe -O InHouseDB_SV_${MaxDist}_${DateOfCreation}_counted.bedpe
	
	# Cut out columns and make a bed file
	cut -f1,2,6,7,11,12,13 InHouseDB_SV_${MaxDist}_${DateOfCreation}_counted.bedpe > InHouseDB_SV_${MaxDist}_${DateOfCreation}.bed
	
	grep "DEL" InHouseDB_SV_${MaxDist}_${DateOfCreation}.bed > InHouseDB_SV_${MaxDist}_${DateOfCreation}_DEL.bed
	grep "DUP" InHouseDB_SV_${MaxDist}_${DateOfCreation}.bed > InHouseDB_SV_${MaxDist}_${DateOfCreation}_DUP.bed
	grep "INS" InHouseDB_SV_${MaxDist}_${DateOfCreation}.bed > InHouseDB_SV_${MaxDist}_${DateOfCreation}_INS.bed
	grep "INV" InHouseDB_SV_${MaxDist}_${DateOfCreation}.bed > InHouseDB_SV_${MaxDist}_${DateOfCreation}_INV.bed

	python add_SV_name.py InHouseDB_SV_${MaxDist}_${DateOfCreation}_DEL.bed InHouseDB_SV_${MaxDist}_${DateOfCreation}_DEL_name.bed
	python add_SV_name.py InHouseDB_SV_${MaxDist}_${DateOfCreation}_DUP.bed InHouseDB_SV_${MaxDist}_${DateOfCreation}_DUP_name.bed
	python add_SV_name.py InHouseDB_SV_${MaxDist}_${DateOfCreation}_INV.bed InHouseDB_SV_${MaxDist}_${DateOfCreation}_INV_name.bed
	python add_SV_name.py InHouseDB_SV_${MaxDist}_${DateOfCreation}_INS.bed InHouseDB_SV_${MaxDist}_${DateOfCreation}_INS_name.bed
		
done	










