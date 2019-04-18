# EvalDNA

EvalDNA (Evaluation of De Novo Assemblies) uses machine-learning methods to integrate genome assembly quality metrics into a single comprehensive quality score.

Prequisites
----------
EvalDNA requires Python v2.7.13 and R statistical software v3.5.1 or later. 

Installation
----------
EvalDNA can be used locally by cloning this repository. 

Usage
----------
	python evalDNA.py -i <inputfile> -o <outputfile> -c <configfile>

All three arguments are mandatory.  
inputfile is the fasta file containing the assembled sequence you want scored.
outputfile is the prefix that will be used to name the output metrics file
configfile is a config file of parameters (see config file section below)

Config file
----------
An example config file is shown below.

	#run parameters
	threads = 16
	runReapr = yes
	bam_file_provided = no
	location_of_bam =
	location_of_reapr = /home/mmacd/bin/Reapr_1.0.18/reapr
	location_of_samtools = /usr/local/samtools/samtools
	paired_end_reads_1 = /work/mmacd/CH_BGI_pe180_reads/CH_BGI_reads_insertsize_500_fwd_52perc_q26.fq
	paired_end_reads_2 = /work/mmacd/CH_BGI_pe180_reads/CH_BGI_reads_insertsize_500_rev_52perc_q26.fq
	sample_map_read_number = 50

