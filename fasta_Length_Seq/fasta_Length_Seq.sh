#!/bin/bash

## AUTHOR : Emmanuel Douzery, August 2014 | April 2016 | May 2017 | April 2023. ##

## What does this script do? It outputs the length of each sequence of the FASTA file, with associated statistics !

## SYNTAX : ./fasta_Length_Seq.sh Fasta_file (UniLine). ##

## FIRST WARNING. ##

boldBlack='\033[0;30m' ;
boldDarkGray='\033[1;30m' ;
boldBlue='\033[1;94m' ;
boldGreen='\033[1;32m' ;
boldRed='\033[1;91m' ;
noColor='\033[0m' ;

 if [ -z $1 ] ;
 	then printf "$boldRed \n Please provide a FASTA file (uniline) ! \n\n $noColor" ; exit ;
 	else if [ ! -f $1 ] ;
 		then printf "$boldRed \n This FASTA file does not exist in the current directory ! \n\n $noColor" ; exit ;
 	fi ;
 fi ;


## PRE-CLEANING. ##

if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
if [ -f ${prefix}_length.out ] ; then rm ${prefix}_length.out ; fi ;


## VARIABLES. ##

prefix=${1%.*} ;							# Prefix of the FASTA file name.
# numSeq=$(grep '>' $1 | wc -l | tr -d ' ') ;
numSeq=$(sed '/^$/d' $1 | grep -c '>') ;				# Number of sequences.
numSeqLines=$(sed '/^$/d' $1 | grep -c -v '>') ;			# Number of lines of sequences.
rankMedian=$(expr $(expr $numSeq + 1) / 2) ;				# '+1' avoids problems when "$numSeq" is odd.
rank95confIntervalInf=$(expr 5 \* $numSeq / 100) ;			# Calculated at 5%.
rank95confIntervalSup=$(expr $numSeq - $rank95confIntervalInf) ;	# Calculated at 5%.


## NEXT WARNINGS. ##

	### CHECK FASTA UNILINE. ###

if [ "$numSeqLines" != "$numSeq" ] ;
	then	printf "$boldRed \n Sorry ... Your FASTA file is not UNILINE ! \n\n$noColor" ;
			exit ;
fi ;


## SCRIPT. ##

cat $1 | while read L ; do if echo $L | grep -q '>' ; then echo $L | sed 's/ /_/g' >> ${1}.tmp ; else echo ${#L} >> ${1}.tmp ; fi ; done ;	# 'sed' avoids sorting trouble when blanks remain in identifiers.

paste -s -d"\t\n" ${1}.tmp | sort -k2 -g -r | tr -d '>' > ${prefix}_length.out ;

totaLength=$(expr $(cut -f2 ${prefix}_length.out | tr -d ' ' | tr '\n' ' ' | sed 's/ / + /g' | sed 's/ + $//')) ;	# Remove the last '+' at the end line.

maxLength=$(sed -n '1p' ${prefix}_length.out | cut -f2) ;
medianLength=$(sed -n "${rankMedian}p" ${prefix}_length.out | cut -f2) ;
minLength=$(sed -n "${numSeq}p" ${prefix}_length.out | cut -f2) ;

maxID=$(sed -n '1p' ${prefix}_length.out | cut -f1) ;
medianID=$(sed -n "${rankMedian}p" ${prefix}_length.out | cut -f1) ;
minID=$(sed -n "${numSeq}p" ${prefix}_length.out | cut -f1) ;

confIntervalInf=$(sed -n "$(expr $rank95confIntervalInf + 1)p" ${prefix}_length.out | cut -f2) ;
confIntervalSup=$(sed -n "$(expr $rank95confIntervalSup)p" ${prefix}_length.out | cut -f2) ;


## VERBOSE. ##

printf "$boldBlack \n\tList of the $numSeq identifiers:\n\n$(cut -f1 ${prefix}_length.out) \n $noColor" ;
printf "$boldBlack \n\tIndividual lengths: $(cut -f2 ${prefix}_length.out | tr -d ' ' | tr '\n' ' ' | sed 's/ / \| /g') \n $noColor" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\tTotal length:\t${totaLength}\tnt \n $noColor" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\tMean length:\t$(expr $totaLength / $numSeq)\tnt \n $noColor" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\tMedian length:\t${medianLength}\t"' nt | Identifier:'"\t$medianID \n" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\tMaximum length:\t${maxLength}\t"' nt | Identifier:'"\t$maxID \n" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\tMinimum length:\t${minLength}\t"' nt | Identifier:'"\t$minID \n" | tee -a ${prefix}_length.out ;
printf "$boldBlue \n\t95% confidence interval: $confIntervalSup - $confIntervalInf nt \n\n $noColor" | tee -a ${prefix}_length.out ;	# Invert inf and sup because ${prefix}_length.out is reverse sorted.


## POST-CLEANING. ##

if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
sed -i '' '/\[/s/.*//g' ${prefix}_length.out ;
