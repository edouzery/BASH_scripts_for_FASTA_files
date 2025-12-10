#!/bin/bash

## AUTHOR : Emmanuel Douzery, Mar. 2017 | Mar. 2022 | Dec. 2025. ##

## What does this script do? It calculate the nucleotide frequences of each (aligned or not) sequence of a FASTA file ! ##

## SYNTAX : ./fasta_Composition_NT.sh Fasta_file ;

## WARNINGS. ##

# Evaluate if the output is a terminal or a file in order to (de)activate colors.
if [ -t 1 ]; 
	then	USE_COLOR=true ;	# For terminal only.
	else    USE_COLOR=false ;	# Avoiding uninterpreted color codes in the output file.
fi ;

# Defining the terminal color codes.
if [ "$USE_COLOR" = true ]; 
	then	boldBlack='\033[0;30m';
			boldDarkGray='\033[1;30m' ;
    		boldBlue='\033[1;94m';
    		boldGreen='\033[1;32m';
    		boldRed='\033[1;91m';
    		noColor='\033[0m';
	else
    		boldBlack='';
			boldDarkGray='' ;
		    boldBlue='';
		    boldGreen='';
		    boldRed='';
		    noColor='';
fi ;

if [ -z $1 ] ;
	then	printf "$boldBlue \n Please provide a FASTA file (uniline) ! \n\n$noColor" ;
			exit ;
fi ;

if [ ! -f $1 ] ;
	then	printf "$boldRed \n This file does not exist in the current directory ! \n\n$noColor" ;
			exit ;
fi ;


## Verbose output file. ##

# echo -e "Script called by $0 $@\n" > output ;
# echo -e "Script called by $0 $1 $2 $3 $4 $5 $6\n" > output ;
# echo 'Length / Site / Primer' >> output ;


## VARIABLES. ##

prefix=${1%.*} ;									# Prefix of the FASTA file name.
nbSeq=$(sed '/^$/d' $1 | grep -c '>') ;				# Number of sequences.
nbChar=$(expr $(sed -n '2p' $1 | wc -c) - 1) ;		# Number of sites.
nbStates=$(sed '/^$/d' $1 | grep -v '>' | tr -d '\n' | wc -c | tr -d ' ') ;	# Number of character states.
nbAliens=$(sed '/^$/d' $1 | grep -v '>' | tr -d '\nACGTNRYMWSKBDHV-?' | wc -c | tr -d ' ') ;	# Number of character states.
nbSeqLines=$(sed '/^$/d' $1 | grep -c -v '>') ;		# Number of lines of sequences.


## CHECK FASTA UNILINE. ##

if [ "$nbSeqLines" != "$nbSeq" ] ;
	then	printf "$boldRed \n Sorry ... Your FASTA file is not UNILINE ! \n\n$noColor" ;
			exit ;
fi ;


## PRE-CLEANING. ##

# if [ -f myfile.cmd ] ; then rm myfile.cmd ; fi ;


## SCRIPT. ##

# echo -e "\t${1}\t|\t$nbSeq sequences\t|\t$nbChar sites" ;
printf "$boldBlack \n \t${1}\t|\t$nbSeq sequences\t|\t$(echo -e $nbChar | rev | sed 's/\(...\)/\1 /g' | rev) sites\t| $noColor" ; printf "$boldBlack \t $(echo -e $nbStates | rev | sed 's/\(...\)/\1 /g' | rev) states. \n$noColor" ;

if [ "$nbAliens" = 0 ] ;
	then	printf "$boldBlack \n \t$nbAliens alien character. \n\n$noColor" ;
	else	printf "$boldRed \n \t$nbAliens alien character(s) --> $(sed '/^$/d' $1 | grep -v '>' | tr -d '\nACGTNRYMWSKBDHV-?' | sed 's/\(.\)/\1 /g' | rs -T | sort -r | uniq -c | tr '\n' '\t') \n\n$noColor" ;
fi ;

echo -e 'Tax_Seq A   C   G   T   N   R   Y   M   W   S   K   B   D   H   V   Dash   Missing' ;	# Defining header. Useful when importing in R.
while read L ;	do
	if	echo $L | grep -q '>' ;
			then	echo -e "$L" | tr -d '>' ;
			else	for nt in A C G T N R Y M W S K B D H V - ? ;	do
						echo -e "$nt=$(echo -e "$L" | grep -o "$nt" | wc -l)" | tr -d ' ' ;
					done ;
	fi | xargs ;
done < $1 | xargs -n 18 ;	# Merge 18 lines (one for the identifier, + 17 characters) into a single line.


## POST-CLEANING. ##

# Nothing to be cleaned.
