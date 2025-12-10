#!/bin/bash

## AUTHOR : Emmanuel Douzery, May 2013 | Mar. 2015 | Mar., May 2023 | Dec. 2025. ##

## What does this script do? It outputs the longest sequence from a FASTA file ! ##

## SYNTAX : ./fasta_Keep_Longest.sh my_fasta_file (UniLine). ##

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
	then printf "$boldRed \n Please provide a FASTA file (uniline) ! \n\n $noColor" ; exit ;
	else if [ ! -f $1 ] ;
		then printf "$boldRed \n This FASTA file does not exist in the current directory ! \n\n $noColor" ; exit ;
	fi ;
fi ;


## VARIABLES. ##

prefix=${1%.*} ;									# Prefix of the FASTA file name.
numSeq=$(sed '/^$/d' $1 | grep -c '>') ;			# Number of sequences.
numSeqLines=$(sed '/^$/d' $1 | grep -c -v '>') ;	# Number of lines of sequences.


## NEXT WARNINGS. ##

	### CHECK FASTA UNILINE. ###

if [ "$numSeqLines" != "$numSeq" ] ;
	then	printf "$boldRed \n Sorry ... Your FASTA file is not UNILINE ! \n\n$noColor" ;
			exit ;
fi ;


## PRE-CLEANING. ##

if [ -f ${prefix}.tmp1 ] ; then rm ${prefix}.tmp1 ; fi ;
if [ -f ${prefix}_longest.fas ] ; then rm ${prefix}_longest.fas ; fi ;


## SCRIPT. ##

cat $1 | while read L ; do 
	if echo $L | grep '>' > /dev/null ; 
		then 
			echo "$L"  >> ${prefix}.tmp1 ; 
		else 
			echo "${#L}"£"$L" >> ${prefix}.tmp1 ; 
	fi ; 
done ;

fas=$(paste -s -d"\t\n" ${prefix}.tmp1 | sort -k2 -g -r | head -n 1 | tr -d '>') ;
longestName=$(echo -e "$fas" | cut -f1) ;
longestLength=$(echo -e "$fas" | cut -f2) ;
echo -e '>'"$longestName"'\n'"$(echo $longestLength | cut -d'£' -f2)" > ${prefix}_longest.fas ;


## VERBOSE. ##

printf "$boldBlue \n Longest sequence: \n $noColor" ;
printf "$boldBlue \tName = $longestName \n $noColor" ;
printf "$boldBlue \tLength = $(echo $longestLength | cut -d'£' -f1) \n $noColor" ;
printf "$boldBlue \tSequence = $(echo $longestLength | cut -d'£' -f2) \n\n $noColor" ;


## POST-CLEANING. ##

if [ -f ${prefix}.tmp1 ] ; then rm ${prefix}.tmp1 ; fi ;
