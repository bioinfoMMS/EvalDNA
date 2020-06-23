#!/bin/bash
#Date created: 6/22/20
#Date last updated: 6/23/20


outputdir=$1 #store user provided output directory name to $outputdir
cd $outputdir #change directory to provided output directory
files=$(ls *.txt) #store all text files (*.txt) in the output directory in the $files variable

for f in $files #loop through the $files array
do
 value=$(cat $f) #extract score for each file
 round_value=$(printf "%.2f\n" $value) #round score to two decimal points
 values+=("$round_value:$f") #add score to values array
done

sorted=($(printf "%s\n" "${values[@]}" | sort -n -r)) #do a numeric sort on scores (descending) 

highest=${sorted[0]}
filename=$(echo $highest | tr -d '\r' | cut -d ':' -f 2 ) #remove new line from variable, split on colon, and save second string after split (the file name)
echo "Highest scoring assembly is:" ${filename::-16} #chops off '_final_score.txt' from the file name
score=$(echo $highest | tr -d '\r' | cut -d ':' -f 1)  #removes new line from variable, split on colon, and save first string after split (the score)
echo "With a score of:" $score
echo

lowest=${sorted[-1]}
lowest_filename=$(echo $lowest | tr -d '\r' | cut -d ':' -f 2 ) #remove new line from variable, split on >
echo "Lowest scoring assembly is:" ${lowest_filename::-16} #chops off '_final_score.txt' from the file n>
lowest_score=$(echo $lowest | tr -d '\r' | cut -d ':' -f 1)  #removes new line from variable, split on co>
echo "With a score of:" $lowest_score


echo
echo 
echo "All scores (descending order):"
echo
echo "score:output_file_name"
printf "%s\n"  "${sorted[@]}" #print scores and filenames from sorted array
