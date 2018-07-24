import sys,argparse

def GetOptions():
	parser = argparse.ArgumentParser()
	parser.add_argument("-V","--vcf",help="Input SURVIVOR merged SV VCF file")
	parser.add_argument("-B","--bedpe",help="Input SURVIVOR BEDPE file")
	parser.add_argument("-O","--outbedpe",help="Output SURVIVOR BEDPE with added annotations")
	args = parser.parse_args()

	invcf = open(args.vcf,'r')
	inbedpe = open(args.bedpe,'r')
	outbedpe = open(args.outbedpe,'w')

	return invcf,inbedpe,outbedpe

def BuildAnnotatedBEDPE(invcf,inbedpe,outbedpe):
# I'll parse through the VCF file and maintain a dictionary that has the count of each variant, e.g. the SUPP=## as the value, with the variant number as the key.
# Variant number is found in the third column (cols[2]) as such: 
# DEL00157806SUR
# DUP00110SUR
# DEL000SUR, etc. where this can be parsed as DEL00-VariantNumber-SUR
# And I want the VariantNumber. DELS and DUPS are a part of the same count

# Dictionary where the key is the variant ID# stored as a string, and the value is the ## in SUPP=##;
	VariantCounts = {}

	for line in invcf:
		if line[0]=='#':
			continue
		cols = line.strip('\n').split('\t')
		varID = cols[2]
		SuppVars = cols[7].split(';')[0].split('=')[1]
		SuppVarVector = cols[7].split(';')[1].split('=')[1]
		SuppVarCount = float(SuppVars)
		SuppVarAF = float(SuppVarCount/len(SuppVarVector))
		VariantCounts[varID]=[SuppVarCount,SuppVarAF]
		#print "%s\t%s\t%s\n"%(varID,SuppVarCount,SuppVarAF)
	
	# Now that we have our dict, we can create a new bedpe by reading through the original bedpe and just adding the right value of count + AF for that variant based on it's ID
	for line in inbedpe:
		line = line.strip('\n')
		cols = line.split('\t')
		var_num = cols[6]
		# There was an odd issue with #459 being skipped in the VCF, and just being present as a duplicate of 460 in the BEDPE file. Quite odd
		# For now I'll skip but need to mention to Fritz on the Github
		# This happens quite a bit actually in the transition to bedPE, it could be because the insertions are not represented in the bedpe?
		try:
			var_count = int(VariantCounts[var_num][0])
			var_af = VariantCounts[var_num][1]	
		except:
			print "Issue with this variant"
			print line
			continue
		outbedpe.write("%s\t%d\t%f\n"%(line,var_count,var_af))


def Main():
	Invcf,Inbedpe,Outbedpe = GetOptions()
	BuildAnnotatedBEDPE(Invcf,Inbedpe,Outbedpe)





if __name__=="__main__":
	Main()


