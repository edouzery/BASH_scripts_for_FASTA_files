#!/bin/bash

## AUTHOR : Emmanuel Douzery, March 2023 | Nov. 2025.

## What does this script do? It calculates the distance between two sequences in terms of nucleotide exchangeabilities !

## FIRST WARNING. ##

boldBlack='\033[0;30m' ;
boldDarkGray='\033[1;30m' ;
boldBlue='\033[1;94m' ;
boldGreen='\033[1;32m' ;
boldRed='\033[1;91m' ;
noColor='\033[0m' ;

if [ -z "$1" ] ;
	then	printf "$boldBlue \n Please provide a fasta file ! \n\n$noColor" ;
			exit ;
	else	if [ ! -f "$1" ] ;
				then	printf "$boldRed \n This file does not exist in the current directory ! \n\n$noColor" ;
				exit ;
			fi ;
fi ;

## VARIABLES. ##

prefix=${1%.*} ;									# Prefix of the FASTA file name.
nbSeq=$(sed '/^$/d' $1 | grep -c '>') ;				# Number of sequences.
nbChar=$(expr $(sed -n '2p' $1 | wc -c) - 1) ;		# Number of sites.
nbSeqLines=$(sed '/^$/d' $1 | grep -c -v '>') ;		# Number of lines of sequences.


## NEXT WARNINGS. ##

	### CHECK FASTA UNILINE. ###

if [ "$nbSeqLines" != "$nbSeq" ] ;
	then	printf "$boldRed \n Sorry ... Your FASTA file is not UNILINE ! \n\n$noColor" ;
			exit ;
fi ;


	## CHECK FASTA SEQUENCE LENGTH = ARE SEQUENCES ALIGNED? ###

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;

sed '/^$/d' $1 | grep -v '>' > ${1}.seq.tmp ;			# Writing sequence lines
sed '/^$/d' $1 | grep '>' | tr -d '>' > ${1}.ID.tmp ;	# Writing IDentifiers

for (( l = 1 ; l < $nbSeqLines ; l++ )) ;				# l => Numbering of each line
        do      m=$(expr $l + 1) ;						# m => Numbering of next line
                if [ "$(sed -n "${l}p" ${1}.seq.tmp | wc -m)" != "$(sed -n "${m}p" ${1}.seq.tmp | wc -m)" ] ;
                        then    printf "$boldRed \n \t Aargh :-( $1 is not ALIGNED: it has a problem with $(sed -n "${m}p" ${1}.ID.tmp) ... Previous sequences in the alignment do not have the same LENGTH ! \n\n$noColor" ;
                                        exit ;
                fi ;
done ;

if [ -f ${1}.seq.tmp ] ; then rm ${1}.seq.tmp ; fi ;
if [ -f ${1}.ID.tmp ] ; then rm ${1}.ID.tmp ; fi ;


	### OTHER WARNINGS. ###

if [ -z "$2" ] ;
	then	printf "$boldBlue \n Please provide a 1st sequence name ! \n\n$noColor" ;
			grep '>' $1 | tr -d '>' | tr '\n' '\t' ;
			echo -e '\n' ;
			exit ;
	else	idOne=$(grep "$2" "$1" | tr -d '>') ;
			if ! [ "$idOne" = "$2" ] ;
				then	printf "$boldRed \n This 1st sequence name does not exist in file $1 ! \n\n$noColor" ;
				exit ;
			fi ;
fi ;

if [ -z "$3" ] ;
	then	printf "$boldBlue \n Please provide a 2nd sequence name ! \n\n$noColor" ;
			grep '>' $1 | tr -d '>' | tr '\n' '\t' ;
			echo -e '\n' ;
			exit ;
	else	idTwo=$(grep "$3" "$1" | tr -d '>') ;
			if ! [ "$idTwo" = "$3" ] ;
				then	printf "$boldRed \n This 2nd sequence name does not exist in file $1 ! \n\n$noColor" ;
				exit ;
			fi ;
fi ;

if [ "$2" = "$3" ] ;
	then	printf "$boldBlue \n No comparison of a sequence against itself ! \n\n$noColor" ;
			exit ;
fi ;

if [ -z "$4" ] ;
	then	printf "$boldBlue \n Which sites should be analyzed? Type 123 (all sites) or 1 (only 1st) or 2 (only 2nd) or 3 (only 3rd positions). \n\n$noColor" ;
			exit ;
fi ;

if ! [ "$4" = "123" -o "$4" = "1" -o "$4" = "2" -o "$4" = "3" ] ;
	then	printf "$boldBlue \n Type either  123 (all sites) or 1 (only 1st) or 2 (only 2nd) or 3 (only 3rd positions). \n\n$noColor" ;
			exit ;
fi ;

if ! [ -z "$5" ] ;
	then	printf "$boldRed \n Only 4 options are allowed: [File] [Sequence 1] [Sequence 2] [Sites]. Please remove the 5th option !\n\n$noColor" ;
			exit ;
fi ;


## SCRIPT. ##

	### PRE-CLEANING. ###

if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
if [ -f seqOne.tmp ] ; then rm seqOne.tmp ; fi ;
if [ -f seqTwo.tmp ] ; then rm seqTwo.tmp ; fi ;
if [ -f seqPair.tmp ] ; then rm seqPair.tmp ; fi ;


	### SITE SELECTION. ###

if [ "$4" = 123 ]
	then	printf "$boldBlack \n\t Sites selected = All $noColor" ;
			cp $1 ${1}.tmp ;
fi ;

if [ "$4" = 1 ]
	then	printf "$boldBlack \n\t Sites selected = 1st positions only $noColor" ;
	sed '/>/!s/\(.\)../\1/g' $1 > ${1}.tmp ;
fi ;

if [ "$4" = 2 ]
	then	printf "$boldBlack \n\t Sites selected = 2nd positions only $noColor" ;
	sed '/>/!s/.\(.\)./\1/g' $1 > ${1}.tmp ;
fi ;

if [ "$4" = 3 ]
	then	printf "$boldBlack \n\t Sites selected = 3rd positions only $noColor" ;
	sed '/>/!s/..\(.\)/\1/g' $1 > ${1}.tmp ;
fi ;


	### COMMANDS. ###

grep -A 1 "$2" "${1}.tmp" | grep -v '>' | sed 's/\(.\)/\1@/g' | tr '@' '\n' > seqOne.tmp ;
grep -A 1 "$3" "${1}.tmp" | grep -v '>' | sed 's/\(.\)/\1@/g' | tr '@' '\n' > seqTwo.tmp ;
lam seqOne.tmp seqTwo.tmp > seqPair.tmp ;

ti=$(grep -c -e 'AG' -e 'GA' -e 'CT' -e 'TC' seqPair.tmp) ;
tv=$(grep -c -e 'AC' -e 'CA' -e 'AT' -e 'TA' -e 'CG' -e 'GC' -e 'GT' -e 'TG' seqPair.tmp) ;
noGap=$(grep -c '[A-Za-z][A-Za-z]' seqPair.tmp) ;

# for pair in {A,C,G,T}{A,C,G,T} ; do echo -e "$pair $(grep -c "$pair" seqPair.tmp)" ; done ;
printf "$boldDarkGray \n\t Number of sites = $(grep -c '[A-Za-z-]' seqPair.tmp) $noColor" ;
printf "$boldDarkGray \n\t No-gapped sites = $noGap $noColor \n" ;
printf "$boldDarkGray \n\t Constant nt sites = $(grep -c -e 'AA' -e 'CC' -e 'GG' -e 'TT' seqPair.tmp) $noColor" ;
printf "$boldDarkGray \n\t Variable nt sites = $(expr $ti + $tv) (%% = $(echo "scale=1 ; 100 * ($ti + $tv) / $noGap" | bc)) $noColor \n\n" ;
printf "$boldDarkGray \t 1-gap sites = $(grep -c -e '\-[A-Za-z]' -e '[A-Za-z]\-' seqPair.tmp) $noColor \n" ;
printf "$boldDarkGray \t 2-gap sites = $(grep -c '\-\-' seqPair.tmp) $noColor \n\n" ;

echo -e "->\tA\tC\tG\tT" ;
for i in A C G T ; do 
	echo -e "${i}" ;
	for j in A C G T ; do 
		dist=$(grep -c "${i}${j}" seqPair.tmp) ; 
		echo -e "$dist" ;
	done ; 
done | paste -s -d'\t\t\t\t\n' - ;

printf "$boldGreen \n\t Transitions = $ti \n$noColor" ;
printf "$boldRed \t Transversions = $tv \n\n$noColor" ;
printf "$boldBlue \t Ti / Tv = $(echo "scale=2 ; $ti / $tv" | bc) $noColor \n\n" ;

	### POST-CLEANING. ###

if [ -f ${1}.tmp ] ; then rm ${1}.tmp ; fi ;
if [ -f seqOne.tmp ] ; then rm seqOne.tmp ; fi ;
if [ -f seqTwo.tmp ] ; then rm seqTwo.tmp ; fi ;
if [ -f seqPair.tmp ] ; then rm seqPair.tmp ; fi ;

