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
<inputfile> is the fasta file containing the assembled sequence you want scored.
<outputfile> is the prefix that will be used to name the output metrics file
<configfile> is a config file of parameters (see config file section below)

Config file
----------
An example config file is shown below.


