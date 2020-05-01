#10/03/16 MLM
#last updated 2/18/2018
#main script for collecting genome evaulation metrics

import numpy as np
from Bio import SeqIO
import os, sys, getopt, subprocess, glob

class InputDict(dict):
    def __init__(self, default=None):
        self.default = default

    def __getitem__(self, key):
        if not self.has_key(key):
            self[key] = self.default()
        return dict.__getitem__(self, key)

#File and directory names start as empty strings
input_file = ''
output_file = ''
checked_fa = ''
out = ''
config_file = ''

#Metrics start as null
normN50 =  'null'
norm_contig_num = 'null'
gap_perc = 'null'
contig_num = 'null'

#Dictionaries for metrics and corresponding values
paras = InputDict( lambda: 'na')
read_stats = InputDict( lambda: 'na')
read_REAPR_stats = InputDict( lambda: 'na')

def readConfig():
  config = open(config_file, "rU")
  for line in config:
	if line.startswith('#') or not line.strip():
        	continue
	else:
		paraArray = line.split("=")
		paras[paraArray[0].strip()] = paraArray[1].strip()   
  config.close()	

def checkAssembly():
   print 'Checking Input Fasta File'
   os.chdir("../results/")
   os.popen(paras['location_of_reapr'] + ' facheck ' + input_file + ' ' + output_file + '.facheck')
   global checked_fa
   checked_fa = output_file + '.facheck.fa'
   checked_input = open(checked_fa, "rU")
   checked_input.close()


def runBaseStats(fasta):
   print '.....Running Basic Stats.....'
   minsizeRmLength = []
   contigsLength = []
   global totallen
   totallen = 0
   rmConLen = 0
   GC_count = 0

   # Create a list for all contigs and another for after contigs smaller than min size are removed
   # Calculate the length of these two lists
   for seq_record in SeqIO.parse(open(fasta), 'fasta'):
	contigsLength.append(len(seq_record.seq))
	totallen += len(seq_record.seq)

        #if len(seq_record.seq) > minsize: 
        #	rmConLen += len(seq_record.seq)
        #	minsizeRmLength.append(len(seq_record.seq))
   global contig_num
   contig_num = len(contigsLength)   

   global norm_contig_num
   norm_contig_num = float(len(contigsLength))/(float(totallen)/1000000)     

   #Calculate the GC content
   seqs = open(fasta, 'r')
   
   for seq_record in seqs.readlines():
   	for charact in list(seq_record):   
        	if seq_record.startswith('>'):
                	continue
           	else:
               		if charact in ('c', 'C'):
	           		GC_count += 1
               		if charact in ('g', 'G'): 
                   		GC_count += 1             
   global GC_cont
   GC_cont = float(GC_count)/float(totallen)*100
   seqs.close()

   #Count number of Ns
   N_count = 0
   seqs = open(fasta, 'r')
   for seq_record in seqs.readlines():
   	for charact in list(seq_record):
        	if seq_record.startswith('>'):
           		continue
        	else:
           		if charact in ('n','N'):
                   		N_count += 1
   global gap_perc
   gap_perc = float(N_count)/float(totallen)*100
   print 'gap percent is ' + str(gap_perc)
   
   #Sort the contigs longer than min size from large to small contigs
   contigsLength.sort()
   contigsLength.reverse()

   #Calculate the mean contig length
   meancon = int(totallen/len(contigsLength))
    
   #Calculate the median contig length
   median = []
   medcon = []

   for con in contigsLength:
   	medcon.append(con)
       	if len(medcon) > (len(contigsLength) * 0.5):
        	median.append(con)
        	break

   #50 and 90 percent of calc genome size and estimated genome size
   len50 = totallen * 0.5 
   len90 = totallen * 0.9

   #calculate N50 and number of contigs
   testSum = 0
   #global N50
   N50 = 0
   N50con = 0
   for con in contigsLength:
       testSum += con
       N50con += 1
       if len50 < testSum:
           N50 = con
           break
	
   global normN50
   normN50 = (float(N50)/float(totallen)) * 100	 
   
   #Calculate N90 and number of contigs
   testSum = 0
   N90 = 0
   N90con = 0
   for con in contigsLength:
       testSum += con
       N90con += 1
       if len90 < testSum:
           N90 = con
           break

   #out = open(outputfile, 'w')
   #print metrics to the output file
   out.write('Metrics for ' + str(fasta) + '\n')
   out.write('# of contigs: ' + str(contig_num) + '\n')
   out.write('total length (bp): ' + str(totallen) + '\n')
   out.write('GC content (%): ' + str(GC_cont) + '\n')
   out.write('min. contig (bp): ' + str(min(contigsLength)) + '\n')
   out.write('median contig (bp): ' + str(median[0]) + '\n')
   out.write('mean contig (bp): ' + str(meancon) + '\n')
   out.write('max. contig (bp): ' + str(max(contigsLength)) + '\n')
   out.write('N50 (bp): ' + str(N50) + '\n')
   out.write('Contig N50 number: ' + str(N50con) + '\n')
   out.write('N90 (bp): ' + str(N90) + '\n')
   out.write('Contig N90 number: ' + str(N90con) + '\n')
   #out.close()

def runReapr():
   print '.....Runnning Reapr.....'
   read1 = paras['paired_end_reads_1']
   read2 = paras['paired_end_reads_2']	
   insert_size = paras['avg_insert_size']

   if paras['bam_file_provided']  in ('n', 'no'):
    os.chdir("../results/")
    os.system(paras['location_of_reapr'] + ' smaltmap -u ' + paras['sample_map_read_number'] + ' -n ' + paras['threads'] + ' ' + checked_fa + ' ' + read1 + ' ' + read2 + ' out_reapr_' + output_file + '.bam')
    os.system(paras['location_of_reapr'] + ' preprocess ' + checked_fa + ' out_reapr_' + output_file + '.bam ' + output_file + '.pipeline' )
    os.chdir("./" + output_file + ".pipeline")
    max_size = 0
    mean = 0
    pc99 = 0
    mean_found = 0
    insert_stats_file = "00.Sample/insert.stats.txt"
    insert_stats = open(insert_stats_file, "r")
    for line in insert_stats.readlines():
		if 'mean' in line:
			if mean_found == 0:	
				mean_found = 1	
				print line
				arry = line.split()
				mean = float(arry[1])
		if 'pc99' in line:
			print line
			arry = line.split()	
			pc99 = float(arry[1])

    print "pc99 = " + str(pc99)
    print "mean = " + str(mean)

    if pc99 > (2 * mean):
		max_size = 2 * mean
    else:
		max_size = pc99

    os.system(paras['location_of_reapr'] + ' stats -j ' + str(max_size) + ' ./ 01.stats') 
    os.system(paras['location_of_reapr'] + ' fcdrate ./ 01.stats 02.fcdrate')
	
    os.system('tail -n 1 02.fcdrate.info.txt | cut -f 1 > tmp')
    fcdcutoff = open('tmp', 'r').read()
    print "fcdcutoff = " + str(fcdcutoff)

    os.system(paras['location_of_reapr'] + ' score 00.assembly.fa.gaps.gz 00.in.bam 01.stats ' + str(fcdcutoff.strip()) + ' 03.score')
    print "past score step"
    os.system(paras['location_of_reapr'] + '  break 00.assembly.fa 03.score.errors.gff.gz 04.break')
    os.system(paras['location_of_reapr'] + '  summary 00.assembly.fa 03.score 04.break 05.summary')
    os.chdir("..")
    os.system(paras['location_of_samtools'] + ' stats out_reapr_' + output_file + '.bam > ' + output_file + '.samtools.stats')
    readReapr()
    readGFF()

   elif paras['bam_file_provided'] in ('y', 'yes'): 
    os.chdir("../results/")
    if(paras['location_of_bam']):
		os.system(paras['location_of_reapr'] + ' preprocess ' + checked_fa + ' ' + paras['location_of_bam'] + ' ' + output_file + '.pipeline' )
		os.chdir("./" + output_file + ".pipeline")
		insert_stats_file = "00.Sample/insert.stats.txt"
        	insert_stats = open(insert_stats_file, "r")
        	
		max_size = 0
        	mean = 0
        	pc99 = 0
		mean_found = 0
        	#insert_stats = open("./00.Sample/insert.stats.txt", "r")
        	for line in insert_stats.readlines():
                	if 'mean' in line:
                        	if mean_found == 0:
					mean_found = 1
					print line
                        		arry = line.split()
                        		mean = float(arry[1])
                	if 'pc99' in line:
                        	print line
                        	arry = line.split()
                        	pc99 = float(arry[1])

        	if pc99 > (2 * mean):
                	max_size = 2 * mean
        	else:
                	max_size = pc99

	        print "pc99 = " + str(pc99)		
		print "mean = " + str(mean)
		print "max_size = " + str(max_size)

		os.system(paras['location_of_reapr'] + ' stats -j ' + str(max_size) + ' ./ 01.stats')
        	os.system(paras['location_of_reapr'] + ' fcdrate ./ 01.stats 02.fcdrate')
        	os.system('tail -n 1 02.fcdrate.info.txt | cut -f 1 > tmp')
		
		fcdcutoff = open('tmp', 'r').read() 		
		print "fcdcutoff is " + str(fcdcutoff.strip())
 	     	
		os.system(paras['location_of_reapr'] + ' score 00.assembly.fa.gaps.gz 00.in.bam 01.stats ' + str(fcdcutoff.strip()) + ' 03.score')
        	os.system(paras['location_of_reapr'] + ' break 00.assembly.fa 03.score.errors.gff.gz 04.break')
        	os.system(paras['location_of_reapr'] + ' summary 00.assembly.fa 03.score 04.break 05.summary')
		os.chdir("..")

		os.system(paras['location_of_samtools'] + ' stats ' + paras['location_of_bam'] + '> ' + output_file + '.samtools.stats')
		readReapr()
		readGFF()
    else:
		print 'Parameter bam_file_provided is set to yes in the config, please add a value for the location_of_bam parameter'   
   else:
	print 'bam_file_provided parameter must be set to yes, y, no, or n'

def readReapr():
	global read_REAPR_stats
	REAPR_stats_file = open('./' + output_file + '.pipeline/05.summary.report.txt', "rU")
	for line in REAPR_stats_file:
		if not line.strip():
			continue
		else:
			if ":" in line:
				line_strip = line.strip()
				if not line_strip.endswith(":"):
					stat_REAPR_array = line_strip.split(":")
					#print stat_REAPR_array
					if len(stat_REAPR_array) > 1:
						read_metric = stat_REAPR_array[0].strip()
						read_metric1 = read_metric.replace(' ', '_')
						#print read_metric1
						metric_value = stat_REAPR_array[1].strip()
						metric_value_array = stat_REAPR_array[1].split()
						read_REAPR_stats[read_metric1.strip()] = metric_value_array[0].strip()

	for (key, val) in read_REAPR_stats.iteritems():
		print "read_REAPR_stats[%s] = %s" % (key, val)
	REAPR_stats_file.close()


def readGFF():
	os.system('gunzip ' + output_file + '.pipeline/03.score.errors.gff.gz')
        gff = open('./' + output_file + '.pipeline/03.score.errors.gff', "rU")
        #global_stats_file = open('./' + output_file + '.pipeline/01.stats.global_stats.txt')
        summary = open('./' + output_file + '.pipeline/05.summary.report.txt')

        #for line in summary:
        #	if 'Total gap length' in line:
                	#gap_array = line.split(':')
                        #gap_length = gap_array[1]
                        #break;

        print 'total chr length =' + str(totallen)
        #print 'gap length = ' + str(gap_length)
        #contig_length = int(totallen) - int(gap_length)
        #print 'contig length = ' + str(contig_length)
        
	total_link = 0
        total_low_read_cov = 0
	total_fcd = 0
        total_fcd_gap = 0
        total_repeat = 0
        total_frag_cov_gap = 0
        total_frag_cov = 0
        total_read_orient = 0
        total_clip = 0
	for line in gff:
                gffArray = line.split()
                if(gffArray[2] == 'Link'):
			total_link =abs(int(gffArray[4]) - int(gffArray[3])) + total_link
		elif(gffArray[2] == 'Frag_cov_gap'):
                        total_frag_cov_gap = abs(int(gffArray[4]) - int(gffArray[3])) + total_frag_cov_gap
                elif(gffArray[2] == 'Read_orientation'):
                        total_read_orient = abs(int(gffArray[4]) - int(gffArray[3])) + total_read_orient
                elif(gffArray[2] == 'Frag_cov'):
                        total_frag_cov = abs(int(gffArray[4]) - int(gffArray[3])) + total_frag_cov
                elif(gffArray[2] == 'FCD_gap'):
                        total_fcd_gap = abs(int(gffArray[4])-int(gffArray[3])) + total_fcd_gap
                elif(gffArray[2] == 'Repeat'):
			total_repeat = abs(int(gffArray[4]) - int(gffArray[3])) + total_repeat
		elif(gffArray[2] == 'FCD'):
			total_fcd = abs(int(gffArray[4]) - int(gffArray[3])) + total_fcd
                elif(gffArray[2] == 'Read_cov'):
                        total_low_read_cov = abs(int(gffArray[4])-int(gffArray[3])) + total_low_read_cov
                elif(gffArray[2] == 'Clip'):
                        total_clip = 1 + total_clip
        #print 'total fcd err contig = ' + str(total_fcd)
	
	global link_percent
	global repeat_percent
	global fcd_contig_percent
	global fcd_gap_percent
	global low_read_cov_percent
	global low_frag_cov_gap_percent
	global low_frag_cov_contig_percent
	global clip_percent

        link_percent = (float(total_link)/float(totallen)) * 100
        repeat_percent = (float(total_repeat)/float(totallen)) * 100
        fcd_contig_percent = (float(total_fcd)/float(totallen)) * 100
        fcd_gap_percent = (float(total_fcd_gap)/float(totallen)) * 100
        low_read_cov_percent = (float(total_low_read_cov)/float(totallen)) * 100
        low_frag_cov_gap_percent = (float(total_frag_cov_gap)/float(totallen)) * 100
        low_frag_cov_contig_percent = (float(total_frag_cov)/float(totallen)) * 100
        clip_percent = (float(total_clip)/float(totallen)) * 100

        print "fcd_contig = " + str(fcd_contig_percent)
	print "fcd_gap = " + str(fcd_gap_percent)
        print "low frag cov contig = " + str(low_frag_cov_contig_percent)
        print "low frag cov gap = " + str(low_frag_cov_gap_percent)
        print "links = " + str(link_percent)
        print "clips = " + str(clip_percent)
        print "repeats = " + str(repeat_percent)
        print "low read cov = " + str(low_read_cov_percent)



def runCombine():
	print '.....Combining results in order to run  machine learning on your assembly.....'        
	#parse samtool stat output
	sam_stats_file = open(output_file + '.samtools.stats', "rU")
  	for line in sam_stats_file:
        	if line.startswith('SN'):
                	stat_array = line.split("\t")
			read_metric = stat_array[1].replace(' ', '_')
                	read_stats[(read_metric.replace(':', ' ')).strip()] = stat_array[2].strip()
     
  	for (key, val) in read_stats.iteritems():
        	print "read_stats[%s] = %s" % (key, val)

  	sam_stats_file.close()
	training_metrics = open('model_input_' + output_file + '.csv', "w")
	prop_pair_perc = (float(read_stats['reads_properly_paired'])/float(read_stats['reads_mapped'])) * 100
	#total_len_kb = float(read_REAPR_stats['Total_length'])/1000
	#print 'total len kb = ' + str(total_len_kb) 
	FCD_err_in_contig = fcd_contig_percent #(float(read_REAPR_stats['FCD_errors_within_a_contig'])/float(total_len_kb)) * 100
	#print 'fcd error in contig = ' + str(FCD_err_in_contig)
	FCD_err_over_gap = fcd_gap_percent # (float(read_REAPR_stats['FCD_errors_over_a_gap'])/float(total_len_kb)) * 100
	low_fc_in_contig = low_frag_cov_contig_percent #(float(read_REAPR_stats['Low_fragment_coverage_within_a_contig'])/float(total_len_kb)) * 100
	low_fc_over_gap = low_frag_cov_gap_percent #(float(read_REAPR_stats['Low_fragment_coverage_over_a_gap'])/float(total_len_kb)) * 100
	low_score_regions =  0 #  (float(read_REAPR_stats['Low_score_regions'])/float(totallen)) * 100
	clip = clip_percent #(float(read_REAPR_stats['Soft_clip'])/float(total_len_kb)) * 100
	coll_repeat = repeat_percent #(float(read_REAPR_stats['Collapsed_repeats'])/float(total_len_kb)) * 100
	low_read_cov = low_read_cov_percent #(float(read_REAPR_stats['Low_read_coverage'])/float(total_len_kb)) * 100
	low_uniq_cov= 0 #(float(read_REAPR_stats['Low_perfect_coverage'])/float(total_len_kb)) * 100
	error_free_bases = float(read_REAPR_stats['Error_free_bases'][:-1])
	print '.....Collecting feature metrics to be tested in ML tool.....'	
	predict_list = [normN50, gap_perc, prop_pair_perc, FCD_err_in_contig, FCD_err_over_gap, low_fc_in_contig, low_fc_over_gap, link_percent, clip, coll_repeat, low_read_cov, error_free_bases, norm_contig_num]
	training_metrics.write("normN50, gap_perc, prop_pair_perc, FCD_err_in_contig, FCD_err_over_gap, low_fc_in_contig, low_fc_over_gap, links, clip, coll_repeat, low_read_cov, error_free_bases, norm_contig_num")
	training_metrics.write("\n")
	training_metrics.write(str(predict_list).strip('[]'))
	training_metrics.close()
	return predict_list

#reads in parameters and assembly file
def main(argv):
   global paras
   if len(argv) == 0:
      print 'Usage: python evalDNA.py -i <inputfile> -o <outputfile> -c <configfile>'
      sys.exit(2)

   try:
      opts, args = getopt.getopt(argv,"hi:o:c:",["--input","--output","--config"])
   except getopt.GetoptError:
      print 'Usage: python evalDNA.py -i <inputfile> -o <outputfile> -c <configfile>'
      sys.exit(2)

   for opt, arg in opts:
      if opt in ("-h", "--help"):
         print 'Usage:\npython evalDNA.py -i <inputfile> -o <outputfile> -c <configfile>\n\ninputfile - the fasta file containing your assembled sequence\noutputfile - prefix for the output metrics file\nconfigfile - config file of parameters'
         sys.exit()
      elif opt in ("-i", "--input"):
         global input_file
         input_file = arg
	 input = open(arg, "rU")
 	 
 	 for record in SeqIO.parse(input_file, "fasta"):
    		print(record.id)
	 input.close()
         
      elif opt in ("-o", "--output"):
         global output_file
	 output_file = arg
	 global out
	 out = open('/usr/src/app/results/' + arg + '.metrics', "w")
      elif opt in ("-c", "--config"):
	 global config_file
	 config_file = arg
	 #config = open(arg, "rU")

   print 'Input file is ', input_file
   print 'Output file is ', output_file
   print 'Config file is', config_file

if __name__ == "__main__":
   main(sys.argv[1:]) 

   readConfig()
   checkAssembly()
   runBaseStats(input_file)

   if(paras['runReapr'] in ('yes', 'y')):
	runReapr()
   	assembly_metrics = runCombine()
   	print 'calc metric = ' + str(assembly_metrics)








