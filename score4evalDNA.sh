#!/bin/bash -x
export LD_LIBRARY_PATH=/home/mmacd/bin/library/

#read -p 'Name of the FASTA file to simulate:' NAME

file=

while :; do
    case $1 in
        -h|-\?|--help)
            echo 'Usage: bash score4evalDNA.sh -f filename.fa -r refname.fa' # Display a usage synopsis.
            echo 
	    echo 'Example:  bash score4evalDNA.sh -f rn_chr8.fa -r rn_chr8_ref.fa'
	    exit
            ;;
        -f)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                NAME=$2
                shift
            else
                die 'ERROR: "-f" requires an argument.'
            fi
            ;;
        --file=?*)
            NAME=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --file=)         # Handle the case of an empty --file=
            die 'ERROR: "--file" requires an argument.'
            ;;
	-r)
	    if [ "$2" ]; then
	       REF_NAME=$2
	       shift
	    else
	       die 'ERROR: "-r" requires an argument.'
	    fi
	    ;;
	--ref=?*)
            REF_NAME=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --ref=)         # Handle the case of an empty --file=
            die 'ERROR: "--ref" requires an argument.'
            ;;
		
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARNING: Unknown option (ignored): %s\n' "$1"
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac
    shift    
done

PREFIX=${NAME%.*} 
REF=${REF_NAME%.*}

echo $PREFIX 
echo $REF

mkdir $PREFIX\_vs_$REF

cd  $PREFIX\_vs_$REF

#Align original sequence to simulated sequence
nucmer ../$REF_NAME ../$NAME --mum --coords -p $PREFIX\vs$REF -c 100

#Align the reference sequence to itself to identify unaligned bases (from short seqs)
nucmer ../$REF_NAME ../$REF_NAME --mum --coords -p $REF\vsSelf -c 100

#Filter to keep 1-to-1 alignments 
delta-filter -1 $PREFIX\vs$REF\.delta > $PREFIX\vs$REF\_c100.filtered.delta
delta-filter -1 $REF\vsSelf.delta > $REF\vsSelf_c100.filtered.delta

#Calculate differences in the alignmnent
dnadiff -d $PREFIX\vs$REF\_c100.filtered.delta -p  $PREFIX\vs$REF\.dnadiff
dnadiff -d $REF\vsSelf_c100.filtered.delta -p  $REF\vsSelf\.dnadiff

inv=0
seq=0
jmp=0
#Calculate the length of inversions and rearrangements in the alignment
grep 'INV' $PREFIX\vs$REF\.dnadiff.qdiff > inversions
grep 'JMP' $PREFIX\vs$REF\.dnadiff.qdiff > rearrangements_jmp
grep 'SEQ' $PREFIX\vs$REF\.dnadiff.qdiff > rearrangements_seq
sed s/'-'/''/g rearrangements_jmp > rearrangements_jmp_noneg
sed s/'-'/''/g inversions > inversions_noneg
sed s/'-'/''/g rearrangements_seq > rearrangements_seq_noneg
inv=`awk '{s+=$5}END{print s}' inversions_noneg`
seq=`awk '{s+=$5}END{print s}' rearrangements_seq_noneg`
jmp=`awk '{s+=$5}END{print s}' rearrangements_jmp_noneg`

echo $inv
echo $seq
echo $jmp

#get reference unaligned length from self vs self alignment
one_to_one_align_self=0
file="${REF}vsSelf.dnadiff.report"
while IFS= read -r line
do
        if [[ $line =~ .*UnalignedBases.* ]]
        then
		read -a myarray <<< "$line"
                IFS='(' read -ra bp_only <<< "${myarray[1]}"
		unalignbp_ref_w_self=${bp_only[0]}
		echo "unalign bases with self: ${unalignbp_ref_w_self}"
	fi

	if [[ $line =~ .*TotalLength.* ]]
        then

		if [[ $one_to_one_align_self -eq 0 ]]
        	then
           	one_to_one_align_self=1
           	read -a myarray <<< "$line"
           	alignbp_qry_self=${myarray[1]}
           	echo "align bp qry with self: ${alignbp_qry_self}"
        	fi
	fi

	if [[ $line  =~ .*InsertionSum.* ]]
        then
           read -a myarray <<< "$line"
           deletions_self=${myarray[1]}
           insertion_self=${myarray[2]}
           echo "deletions self: ${deletions_self}"
           echo "insertions self: ${insertion_self}"
        fi	

done < "$file"

one_to_one_length=0

file="${PREFIX}vs${REF}.dnadiff.report"

while IFS= read -r line
do
	if [[ $line =~ .*TotalLength.* ]]
        then
		if [[ $one_to_one_length -eq 0 ]]
	   	then
		   one_to_one_length=1
           	   read -a myarray <<< "$line"
           	   alignbp_ref=${myarray[1]}
           	   alignbp_qry=${myarray[2]}
           	   echo "align bp ref: ${alignbp_ref}"
           	   echo "align bp qry: ${alignbp_qry}"
        	fi
	fi	

	if [[ $line =~ .*UnalignedBases.* ]]
        then
                read -a myarray <<< "$line"
		IFS='(' read -ra bp_only <<< "${myarray[1]}"
		unalignbp_ref=${bp_only[0]}
                echo "unalign bases: ${unalignbp_ref}"
        fi

	if [[ $line  =~ .*TotalSNPs.* ]]
	then
	   read -a myarray <<< "$line"
	   snps_qry=${myarray[2]}
	   echo "qry snps: ${snps_qry}"
	fi

        if [[ $line  =~ .*TotalIndels.* ]]
        then
           read -a myarray <<< "$line"
           indel_qry=${myarray[2]}
           echo "qry indels: ${indel_qry}"
        fi

	if [[ $line  =~ .*InsertionSum.* ]]
        then
           read -a myarray <<< "$line"
           deletions=${myarray[1]}
           insertion=${myarray[2]}
           echo "deletions: ${deletions}"
           echo "insertions: ${insertion}"
        fi

	if [[ $line  =~ .*TandemInsSum.* ]]
        then
           read -a myarray <<< "$line"
           tandem_del=${myarray[1]}
           tandem_ins=${myarray[2]}
           echo "tandem deletions: ${tandem_del}"
           echo "tandem insertions: ${tandem_ins}"
        fi

done < "$file"

total_err=0
num=0
score=0

unalign_corrected=$((unalignbp_ref - unalignbp_ref_w_self))
echo "unalign corrected: ${unalign_corrected}"

total_err=$((snps_qry + indel_qry + tandem_del + tandem_ins + deletions + insertion + jmp + seq + inv + unalign_corrected))
num=$((alignbp_qry_self + insertion_self + deletions_self - total_err))

echo "total error: ${total_err}"

echo "numerator of score: ${num}"

echo "denom of score: ${alignbp_qry_self}"

prescore=$(echo "scale=6 ; $num / $alignbp_qry_self" | bc -l)

score=$(echo "scale=4 ; 100 * $prescore" | bc -l)

cd ..
cd ..
echo 'Complete'
echo "The assembly quality score is ${score}"

