#!/bin/bash

## AUTHOR : Emmanuel Douzery, February 2012. Improved in April 2015 | December 2017 | October 2018 | January 2020.

## PROGENY : fasta_KeepSeq.sh

## What does this script do? It deletes sequence(s) from an uniline FASTA file !

## CHECK FILE NAME.

boldRed='\033[1;91m' ;
boldBlue='\033[1;94m' ;
noColor='\033[0m' ;
# boldBlack='\033[1;90m' ;

if [ -z $1 ] ;
	then printf "$boldRed \n Please provide a FASTA file (uniline) ! \n\n$noColor" ; exit ;
	else if [ ! -f $1 ] ;
		then printf "$boldRed \n This $1 FASTA file does not exist in the current directory ! \n\n$noColor" ; exit ;
	fi ;
fi ;

if [ -z $2 ] ;
	then printf "$boldRed \n Please provide the list of sequence(s) to be deleted ! \n\n$noColor" ; exit ;
fi ;


## CHECK FASTA UNILINE.

nbSeqNames=$(grep -c '>' $1) ;		# Number of sequence names.
nbSeqLines=$(grep -c -v '>' $1) ;	# Number of lines of sequences.

if ! [ "$nbSeqLines" = "$nbSeqNames" ] ;
	then printf "$boldRed \n Sorry ... Your $1 FASTA file is not UNILINE. \n\n$noColor" ; exit ;
fi ;


## PREFIXAGE & SUFFIXAGE. ##

prefix=${1%.*} ;	# All prefixes of the input file.
suffix=${1##*.} ;	# Last suffix (last extension) of the input file.


## PRE-CLEANING.

if [ -f ${1}.cmd ] ; then rm ${1}.cmd ; fi ;
if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
if [ -f ${prefix}_del.${suffix} ] ; then rm ${prefix}_del.${suffix} ; fi ;


## VARIABLES.

seqToDelete=$(for (( i = 2 ; i <= $# ; i += 1 )) ; do echo -e "${!i}" ; done) ;

grepCmd=$(echo grep -v $(for (( i = 2 ; i <= $# ; i += 1 )) ; do echo -e "-e '>${!i}@'" ; done) ) ;	# $# = total number of arguments


## CHECK FOR TAXON NAMES TO BE DELETED.

for t in $(echo -e "$seqToDelete") ;
	do	if ! grep -q '>'"$t"'$' $1 ;
			then printf "$boldRed \n This sequence name does not exist in the $1 FASTA file: $t. \n\n$noColor" ;
			exit ;
		fi ;
done ;


## SCRIPT.

cp $1 ${1}.tmp ;

echo ":g/>/s/^/</" > ${1}.cmd ;
echo ":g/>/s/$/@/" >> ${1}.cmd ;
echo ":wq" >> ${1}.cmd ;

vi ${1}.tmp -s ${1}.cmd ;

tr -d '\n' < ${1}.tmp | tr '<' '\n' | sed '1d' | eval $grepCmd | tr '@' '\n' > ${prefix}_del.${suffix} ;


## VERBOSE.

printf "$boldBlue \n Sequence(s) deleted from the $1 FASTA file ||| $(echo $seqToDelete | tr '\n' ' ')||| \n\n$noColor" ;


## POST-CLEANING.

if [ -f ${1}.cmd ] ; then rm ${1}.cmd ; fi ;
if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
