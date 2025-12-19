#!/bin/bash

## AUTHOR : Emmanuel Douzery, May 2011 | February 2021.

## What does this script do? It cuts all the sequences of a FASTA file in order to keep only positions X (included) to Y (included). !

## WARNINGS $1

boldRed='\033[1;91m' ;
boldBlue='\033[1;94m' ;
noColor='\033[0m' ;

if [ -z $1 ] ;
	then printf "$boldRed \n\t Please provide a FASTA file (uniline) ! \n\n $noColor" ; exit ;
	else if [ ! -f $1 ] ;
		then printf "$boldRed \n\t This FASTA file does not exist in the current directory ! \n\n $noColor" ; exit ;
	fi ;
fi ;


## VARIABLES

prefix=${1%.*} ;										# First prefix of the FASTA file name.
suffix=${1##*.} ;										# Last suffix of the FASTA file name.
nchar=$(expr `head -2 $1 | tail -1 | wc -c` - 1) ;		# Number of sites
ntax=$(sed '/^$/d' $1 | grep -c '>') ;					# Number of sequences
nseqlin=$(sed '/^$/d' $1 | grep -c -v '>') ;			# Number of lines of sequences


## CHECK FASTA UNILINE and LENGTH

if [ "$nseqlin" != "$ntax" ] ; then printf "$boldRed \n\t Sorry ... Your FASTA file is not UNILINE ! \n\n $noColor" ; exit ; fi ;

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;	# Pre-cleaning
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;		# Pre-cleaning

sed '/^$/d' $1 | grep -v '>' > ${1}.seq.tmp ;			# Writing sequence lines
sed '/^$/d' $1 | grep '>' | tr -d '>' > ${1}.ID.tmp ;	# Writing IDentifiers

for (( l = 1 ; l < $nseqlin ; l++ )) ;					# l => Numbering of each line
	do m=$(expr $l + 1) ;								# m => Numbering of next line
	if [ "$(sed -n "${l}p" ${1}.seq.tmp | wc -m)" != "$(sed -n "${m}p" ${1}.seq.tmp | wc -m)" ] ;
	then printf "$boldRed \n\t Problem with $(sed -n "${l}p" ${1}.ID.tmp) and $(sed -n "${m}p" ${1}.ID.tmp) ... Aligned sequences do not have the same LENGTH ! \n\n $noColor" ;
	rm ${1}.seq.tmp ${1}.ID.tmp ;						# Post-cleaning
	exit ; fi ;
done ;

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;	# Post-cleaning
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;		# Post-cleaning


## WARNINGS $2 and $3

if [ -z $2 ] ; then printf "$boldRed \n\t Please provide the LOWER (STARTING) position number [ for example: fasta_Cut.sh myfile.fas 57 483 ] ! \n\n $noColor" ; exit ; fi ;
if [ $2 -gt $nchar ] ; then printf "$boldRed \n\t The LOWER position number cannot exceed the alignment length (i.e., $nchar sites) ... \n\n $noColor" ; exit ; fi ;

if [ -z $3 ] ; then printf "$boldRed \n\t Please provide the UPPER (ENDING) position number [ for example: fasta_Cut.sh myfile.fas 57 483 ] \n\n $noColor" ; exit ; fi ;
if [ $3 -le $2 ] ; then printf "$boldRed \n\t The UPPER (ENDING) position number should be GREATER than the LOWER (STARTING) position number ... \n\n $noColor" ; exit ; fi ;
if [ $3 -gt $nchar ] ; then printf "$boldRed \n\t The UPPER position number cannot exceed the alignment length (i.e., $nchar sites) ... \n\n $noColor" ; exit ; fi ;


## SCRIPT

if [ -f ${prefix}.cut_${2}to${3}.${suffix} ] ; then rm ${prefix}.cut_${2}to${3}.${suffix} ; fi ;		# Pre-cleaning

while read L ;
	do	if echo $L | grep '>' > /dev/null ;
			then echo "$L" ;						# IDentifier line
			else echo $L | cut -c"$2"-"$3" ;		# Sequence line
		fi ;
done < $1 > ${prefix}.cut_${2}to${3}.${suffix} ;	# Output


## VERBOSE

printf "$boldBlue \n\t "'Sequences of the '"$1"' FASTA file have been cut in order to keep only positions '"$2"' to '"$3"' (included).'" \n\n $noColor" ;

