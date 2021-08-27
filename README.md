# BuildInHouseDB
> This set of scripts will build an in-house database once you deposit VCF files into a directory.

## Overview
The script utilizes bcftools, htslib, SURVIVOR, and a couple of small "glue" python scripts in this repository. The main purpose of this approach is to create in-house databases for use with AnnotSV. To be honest it's mostly a repo for me to have less work for the next time I roll this out. 

## Flow:
1) Installs
2) Copy data into directory called VCF
3) Edit paths in shell script
4) Run it
5) (in dev) Annotate

## Installs
Git clone the repo and execute the Install script.
This will fetch a miniconda installation and place it inside the repo directory.

```
git clone https://github.com/Phillip-a-richmond/BuildInHouseDB/
sh Install.sh
```

## Running the annotation
Annotation is executed with one of two scripts (based on examples). You'll have to repurpose these scripts to match you data. 
Open one of the scripts and make changes at the top for relevant paths of installs. 

(Dev, make it more generalizable with command-line parameters)

The first script is for Mobile element insertions called with MELT. 
```
BuildDB_MEI_EPGEN.sh
```

The other is for SVs called with smoove.
```
BuildDB_SV_EPGEN.sh
```








