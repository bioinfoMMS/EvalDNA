# EvalDNA

EvalDNA (Evaluation of *De Novo* Assemblies) uses machine-learning methods to integrate genome assembly quality metrics into a single comprehensive quality score. 

Prequisites
----------
EvalDNA requires Python v2.7.13, Perl v5.24.3 or later, and R statistical software v3.5.1 or later. Prequisites are provided within the Docker instance and do not need to be installed separately.


Installation
----------
EvalDNA is provided as a Docker container and has been tested on a Unix/Linux environment. To get started, download or clone this repository. 


Building and Running Docker for EvalDNA
----------
After editing the Dockerfile to provide your input into EvalDNA (explained below), run the following commands:

	cd EvalDNA_v1.1 
	sudo docker build -t evaldna_test . #builds Docker container called 'evaldna_test'
	sudo docker run -t -u $(id -u):$(id -g) -v /location/of/EvalDNAv1.1/results:/usr/src/app/results -v /location/of/EvalDNA_v1.1/code:/usr/src/app/code -v /location/of/EvalDNA_v1.1/data:/usr/src/app/data --name edtest -t --cpus="16" evaldna_test #runs the 'evaldna_test' Docker instance with 16 cpus and the three directories (code, data, and results) mounted.
	sudo docker container rm --force edtest #Removes the docker container when finished


Usage
----------

The current version of EvalDNA is listed in the EvalDNA_v1.1 directory.  

Two subdirectories are provided named code and data. Use the 'mkdir' command to create a directory with EvalDNA_v1.1 called 'results'. These directories are mounted when running the Dockerfile so that any files in these folders can be accesssed by EvalDNA on a Docker instance.
 
The code directory contains the EvalDNA python script, the code for the R model, REAPR which is one of the tools EvalDNA executes, and the code to run the R model. 

The data directory contains sample data to get started with EvalDNA as well as the config file required to run EvalDNA. 

The results directory you created will be where the files produced by EvalDNA, including the final quality score output, will be saved as EvalDNA is running. If rerunning EvalDNA using the same prefix as a run before, make sure to remove existing files using that prefix from results including the 'prefix.pipeline' to avoid errors. 

The Dockerfile is provided in the EvalDNA_v1.1 directory. Running this, installs all required prequisites and runs the EvalDNA python command within the 'code' directory. This command is listed in the 'CMD' line in the Dockerfile, which is the only line of the Dockerfile you will need to edit. 

	python EvalDNA_v1.1.py -i ../data/inputfile.fa -o outputfile -c ../data/configfile.txt

All three arguments are mandatory where:  

inputfile.fa is the assembly FASTA file

outputfile is the prefix that will be used to name the output metrics file

configfile.txt is a config file of parameters (see config file section below) and where you provide the location of the sequencing reads


Input
----------

EvalDNA requires a FASTA file containing the assembled sequence you want scored, paired-end sequencing reads either unmapped in FASTQ format or mapped in BAM format. It also require a configuration file containing certain parameters such as the location of the sequencing read FASTQ files or the BAM file.

Note: EvalDNA will not work if a single FASTA sequence in the given fasta file is longer than 530 mbp due to the requirement of creating a TBI index for the file. We suggest splitting the fasta sequence to overcome this problem. Be aware this may cause a slight decrease in the quality score.


Config file
----------
An example config file is shown below.

	#run parameters
	threads = 16
	runReapr = yes
	bam_file_provided = no
	location_of_bam =
	location_of_reapr = /usr/src/app/code/Reapr_1.0.18_for_Evaldna/reapr
	location_of_samtools = samtools
	paired_end_reads_1 = ../data/forward_reads_1.fq
	paired_end_reads_2 = ../data/reverse_reads_2.fq
	sample_map_read_number = 50

The values for the 'paired_end_reads_1' and 'paired_end_reads_2' parameters are the paths to the location of the paired-end sequencing reads to be used to evaluate the assembly quality. We recommend using 10x or more coverage of high quality reads and the provided model requires paired-end reads that have an insert size of about 400-600 bp.

If the reads have already be mapped to the assembly of interest, one can set 'bam_file_provided' to yes and provide the BAM file path with the 'location_of_bam' parameter. Note that the location of the BAM file will also need to contain the BAM index file (from samtool index command).

If you want to use EvalDNA just to produce continuity metrics such as N50, total length etc., you can set the 'runReapr' parameter to no. You will also need to remove the Rscript run model command from the Dockerfile 'CMD' line. 

Note: To run the scoring model, running Reapr is required.


Output of EvalDNA.py
----------
All output files are saved to the 'results' directory.

prefix.metrics – list of basic metrics about the assembly

prefix.facheck.info – information about what was changed to get the checked FASTA file (sometimes changes the format of the FASTA headers if they contain characters not accepted by REAPR)

prefix.facheck.fa - the checked FASTA file

model_input_prefix.csv - comma-separated list of quality metrics to be submitted to the scoring model


Scoring the output
----------
Once EvalDNA has finished and produced the training_metrics_prefix.csv file, you can submit the CSV file to an R script (.R file) that will apply a model designed in R (.rds file). 

We provide a well-tested model that was trained on mammalian genome assembly data. 

The following command is included in the Dockerfile to run the provided model:

	Rscript run_mammalian_model_v1.1.R ../results/training_metrics_prefix.csv
	
More details on the model can be found in the EvalDNA manuscript once it is published.


Sample Data
----------

Sample data (Chinese hamster chromosome 8, sequencing reads from the Chinese hamster, and a BAM file of the reads mapped to chromosome 8) are provided in the data directory along with a config.txt file. 

The Dockerfile provided with EvalDNA is set up to use this data and config file to estimate the quality score for chromosome 8 of the Chinese hamster reference genome.

Scoring chromosome 8 with 16 processors takes about 1 hour and 15 mins if reads needs to be mapped to the assembly being scored. 

If you provide the reads already mapped in the provided BAM file for chromosome 8, it takes 1 hours and 8 minutes. This time difference becomes more significant the more reads you have to map.

Once completed, there will a new file in the 'results' directory called 'chr8_CH_final_score.txt'. 

Note: The sample data is provided to make sure you can run EvalDNA. The amount of reads in the sample data is much less (1.55x) than the 10x coverage required to run EvalDNA to get an accurate quality score.  


Running Multiple Assemblies
----------
Multiple runs of EvalDNA and the scoring model can be listed as one 'CMD' in the Dockerfile. For example:

	CMD cd code && \
	python EvalDNA_v1.1.py -i ../data/genome_assembly_1.fa -o genome1 -c ../data/config_genome1.txt && \
	Rscript run_mammalian_model_v1.1.R ../results/model_input_genome1.csv && \
	python EvalDNA_v1.1.py -i ../data/genome_assembly_2.fa -o genome2 -c ../data/config_genome2.txt && \
	Rscript run_mammalian_model_v1.1.R ../results/model_input_genome2.csv


Optional: Creating your own model
----------

If you would like to create you own model, say on training data from plants rather than mammals, the metric calculation portion of EvalDNA can be used to collect quality metrics of the instances in the training data. We provide a bash script to score training instances as well which requires the assembly/assembled sequence of interest and a reference sequence. Further processing of the scores may need be required such as the scaling described in the EvalDNA publication. Once the training data is collected, models can be trained and tested within R. The user created model can be saved as '.rds' file and used in place of the provided model.

The following command can be used to score a training data instance:

	bash score4evalDNA.sh -f assembly.fa -r assembly_ref.fa

The score4evalDNA.sh script is provided in the code directory and can be run outside the Docker instance.

Once a R model is created, it should be added to the code directory. 

Within the Dockerfile, the 'Rscript run_mammalian_model_v1.1.R ../results/model_input_prefix.csv' command should be changed to 'Rscript your_model_name.R ../results/model_input_prefix.csv'. 

Troubleshooting
----------

List of errors you may see and what they mean.

'python: can't open file 'EvalDNA_v1.1.py': [Errno 2] No such file or directory' - check that there are no errors or typos in the path to the code directory being mounted in the Docker run command.

Please post other problems to the github's issue page for EvalDNA: https://github.com/bioinfoMMS/EvalDNA/issues
