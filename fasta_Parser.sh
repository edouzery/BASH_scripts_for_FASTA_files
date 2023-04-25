#!/bin/bash

## AUTHOR : Emmanuel Douzery, May 2011 | July 2018. ##

## What does this script do? It checks the format of a FASTA file (= uniline + sequences aligned) ! ##


## PRE-CLEANING. ##

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;


## CHECK FILE NAME. ##

boldBlack='\033[1;90m' ;
boldBlue='\033[1;94m' ;
boldRed='\033[1;91m' ;
noColor='\033[0m' ;

if [ -z $1 ] ;
        # then  echo -e "\033[1m Please provide a FASTA file (uniline) ! \033[0m" ; exit ;
        then    printf "$boldRed \n Please provide a FASTA file (uniline) ! \n\n$noColor" ;
                        exit ;
        else    if [ ! -f $1 ] ;
                                # then  echo -e "\033[1m This FASTA file does not exist in the current directory ! \033[0m" ; exit ;
                                then    printf "$boldRed \n This FASTA file does not exist in the current directory ! \n\n$noColor" ;
                                exit ;
                fi ;
fi ;


## VARIABLES. ##

nbSeq=$(sed '/^$/d' $1 | grep -c '>') ;                         # Number of sequences
nbSeqLines=$(sed '/^$/d' $1 | grep -c -v '>') ;                 # Number of lines of sequences


## CHECK FASTA UNILINE. ##

if [ "$nbSeqLines" != "$nbSeq" ] ;
        then    printf "$boldRed \n Sorry ... Your FASTA file is not UNILINE ! \n\n$noColor" ;
                        exit ;
fi ;


## CHECK FASTA SEQUENCE LENGTH = ARE SEQUENCES ALIGNED? ##

sed '/^$/d' $1 | grep -v '>' > ${1}.seq.tmp ;           # Writing sequence lines
sed '/^$/d' $1 | grep '>' | tr -d '>' > ${1}.ID.tmp ;   # Writing IDentifiers

for (( l = 1 ; l < $nbSeqLines ; l++ )) ;               # l => Numbering of each line
        do      m=$(expr $l + 1) ;                      # m => Numbering of next line
                if [ "$(sed -n "${l}p" ${1}.seq.tmp | wc -m)" != "$(sed -n "${m}p" ${1}.seq.tmp | wc -m)" ] ;
                        # then  echo -e '\E[31;3m' "\033[1m Problem with $(sed -n "${l}p" ${1}.ID.tmp) and $(sed -n "${m}p" ${1}.ID.tmp) ... Aligned sequences do not have the same LENGTH ! \033[0m" ;
                        # then    printf "$boldRed \n Aargh :-( $1 has a problem with $(sed -n "${l}p" ${1}.ID.tmp) and $(sed -n "${m}p" ${1}.ID.tmp) ... Aligned sequences do not have the same LENGTH ! \n\n$noColor" ;
                        then    printf "$boldRed \n \t Aargh :-( $1 has a problem with $(sed -n "${m}p" ${1}.ID.tmp) ... Previous sequences in the alignment do not have the same LENGTH ! \n\n$noColor" ;
                                        if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;    # Post-cleaning
                                        if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;      # Post-cleaning
                                        exit ;
                fi ;
done ;


## POST-CLEANING. ##

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;


## VERBOSE. ##

# echo -e "\033[1m Yes ! $1 is a FASTA file, uniline, with all $nbSeq sequences of length = $(expr `sed -n '2p' $1 | wc -c` - 1) sites. \033[0m" ;
printf "$boldBlue \n Yes ! $1 is a FASTA file, uniline, with all $nbSeq sequences of length = $(expr $(sed -n '2p' $1 | wc -c) - 1) sites. \n\n$noColor" ;
