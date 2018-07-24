import sys
import re


infile = open(sys.argv[1],'r')
outfile = open(sys.argv[2],'w')


for line in infile:
	cols=line.strip('\n').split('\t')
	chr=cols[0]
	start=cols[1]
	end=cols[2]
	AC=cols[5]
	SV= chr + ":" + start + ":" + end
	AC="AC:" + str(AC) + ":chr" + SV
	cols.append(SV)
	cols.append(AC)
	newline="\t".join(cols)
	outfile.write("%s\n"%newline)
