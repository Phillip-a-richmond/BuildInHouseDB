SURVIVOR_LOCATION=/home/richmonp/scratch/TOOLS/SURVIVOR/Debug/
PATH=PATH:$SURVIVOR_LOCATION



SURVIVOR 5 sample_files_dels 1000 1 1 0 1 50 PlatinumCombinedSURVIVOR.vcf
SURVIVOR 8 PlatinumCombinedSURVIVOR.vcf 50 5000000 PlatinumCombinedSURVIVOR.bedpe
grep "DEL" PlatinumCombinedSURVIVOR.bedpe > PlatinumCombinedSURVIVOR_del.bedpe
cut -f1,2,6 PlatinumCombinedSURVIVOR_Del.bedpe > PlatinumCombinedSURVIVOR_Del.bed 

#With Full MetaSV
SURVIVOR 5 sample_files_metasv 1000 1 1 0 1 50 PlatinumCombinedMetaSVSURVIVOR.vcf
SURVIVOR 8 PlatinumCombinedSURVIVOR.vcf 50 5000000 PlatinumCombinedMetaSVSURVIVOR.bedpe
