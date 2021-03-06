# BuildInHouseDB
This set of scripts will build an in-house database once you deposit VCF files into a directory.

## Flow:
1) Installs
2) Copy data into directory called VCF
3) Edit paths in shell script
4) Run it
5) Annotate with VCFanno

### Installs
- bgzip and tabix
- bcftools
- vcfanno
- VT
- [SURVIVOR](https://github.com/fritzsedlazeck/SURVIVOR)

### Copy Your Data
- Make a directory for your VCF files (fine if they aren't bgzipped or tabix indexed yet, and fine if they aren't filtered)
- Make sure you have your genome fasta file that the data was mapped to (for normalization purposes)

### Edit the paths in your shell script
- Edit the file paths within BuildVCFDB.sh to be relevant to your data location
- This should include your input, output, and genome.fasta file locations

### Run it
sh BuildVCFDB.sh

### Expected output 
Merged VCF File, Normalized VCF File

### Annotate your candidate VCF Files
Using vcfanno, we can now annotate the candidate VCF files with this merged vcf file. **ADDING MORE OF THIS LATER**




----

# In-house database for SVs

Many SV calls are artifacts, that may appear consistently across samples. As such, it is important to be able to create a set of in-house SVs specific to a given pipeline, which can be useful for filtering out artifacts and polymorphisms in the search for rare genetic pathogenic abnormalities.


How it works:
## Flow:
1) Installs
2) Copy data into directory called VCF
3) Edit paths in shell script
4) Run it


### Installs
- [SURVIVOR](https://github.com/fritzsedlazeck/SURVIVOR)

### Copy Your Data
- Make a directory for your VCF files (fine if they aren't bgzipped or tabix indexed yet, and fine if they aren't filtered)
- Make sure you have your genome fasta file that the data was mapped to (for normalization purposes)

### Edit the paths in your shell script
- Edit the file paths within BuildVCFDB.sh to be relevant to your data location
- This should include your input, output, and genome.fasta file locations

### Run it
sh BuildVCFDB.sh

### Expected output 
Merged VCF File, Normalized VCF File








