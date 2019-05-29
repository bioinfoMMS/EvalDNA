# EvalDNA

EvalDNA (Evaluation of De Novo Assemblies) uses machine-learning methods to integrate genome assembly quality metrics into a single comprehensive quality score.

Prequisites
----------
EvalDNA requires Python v2.7.13 and R statistical software v3.5.1 or later. 

Installation
----------
EvalDNA can be used locally by cloning this repository. 

The EvalDNA directory contains REAPR which is one of the tools EvalDNA executes. For REAPR to work, one must add the provided Perl libraries to the Perl path by using  the following command:
	export PERL5LIB=/path/to/evalDNA/Reapr_1.0.18/File-Copy-Link-0.140/lib/

R  statistical software is also required and needs to be accessible (i.e.  in  your  path)

Usage
----------
	python evalDNA.py -i <inputfile> -o <outputfile> -c <configfile>

All three arguments are mandatory.  

inputfile is the assembly fasta file

outputfile is the prefix that will be used to name the output metrics file

configfile is a config file of parameters (see config file section below) and where you provide the location of the sequencing reads



Input
----------

EvalDNA requires a fasta file containing the assembled sequence you want scored, paired-end sequencing reads either unmapped in fastaq format or mapped in BAM format. It also require a configuration file containing certain parameters including the location of the sequencing read fastq files or the BAM file.

Note: EvalDNA will not work if a single fasta sequence in the given fasta file is longer than 530 mbp due to the requirement of creating a TBI index for the file. We suggest splitting the fasta sequence to overcome this problem. Be aware this may cause a slight decrease in the quality score.



Config file
----------
An example config file is shown below.

	#run parameters
	threads = 16
	runReapr = yes
	bam_file_provided = no
	location_of_bam =
	location_of_reapr = /path/to/EvalDNA/bin/Reapr_1.0.18/reapr
	location_of_samtools = /path/to/samtools
	paired_end_reads_1 = /path/to/paired/reads/forward_reads_1.fq
	paired_end_reads_2 = /path/to/paired/reads/reverse_reads_2.fq
	sample_map_read_number = 50

The values for the 'paired_end_reads_1' and 'paired_end_reads_2' parameters are the paths to the location of the paired-end sequencing reads to be used to evaluate the assembly quality. We recommend using 10x or more coverage of high quality reads (about 400-600 bp insert size) if using the provided model.

If the reads have already be mapped to the assembly of interest, one can set 'bam_file_provided' to yes and provide the BAM file path with the 'location_of_bam' parameter.

If you want to use EvalDNA just to produce continuity metrics such as N50, total length etc., you cant set the 'runReapr' parameter to no. 

Note: To run the scoring model, running Reapr is required.

Output of EvalDNA.py
----------

prefix.metrics – list of basic metrics about the assembly

prefix.facheck.info – information about what was changed to get the checked fasta file

prefix.facheck.fa  - the checked fasta file

prefix... - comma-separated list of quality metrics to be submitted to the scoring model


Scoring the output
----------
Once EvalDNA has finished and produced the training_metrics_prefix.csv file, you can submit the CSV file to an R script (.R file) that will apply a model designed in R (.rds file). 

We provide a well-tested model that was trained on mammalian genome assembly data. 

The following command can be used to run the provided model:

	Rscript run_mammalian_model.R training_metrics_prefix.csv
	
More details on the model can be found in the EvalDNA manuscript once it is published.



Optional: Creating your own model
----------

If you would like to create you own model, say on training data from plants rather than mammals, the metric calculation portion of EvalDNA can be used to collect quality metrics of the instances in the training data. We provide a bash script to score training instances as well which requires the assembly/assembled sequence of interest and a reference sequence. Further processing of the scores may need be required such as the scaling described in the EvalDNA publication.

The following command can be used to score a training data instance:

	bash score4evalDNA.sh -f assembly.fa -r assembly_ref.fa


