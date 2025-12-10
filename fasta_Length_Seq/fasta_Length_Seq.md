# BASH scripts for FASTA files

## fasta_Length_Seq.sh

This BASH script computes the length of each (uniline) sequence of a FASTA file.
It also returns descriptive statistics: **mean**, **median**, **min**, **max**, **95% confidence interval** of all lengths.

## Example ##

  `fasta_Length_Seq.sh Mus_musculus_483LEX_reference_names.fas`
 
```python
 
	List of the 10 identifiers:

Mus_musculus_10194_ENSG00000179981_000_TSHZ1
Mus_musculus_10210_ENSG00000197579_000_TOPORS
Mus_musculus_10142_ENSG00000127914_000_AKAP9
Mus_musculus_10208_ENSG00000132952_001_USPL1
Mus_musculus_10395_ENSG00000164741_001_DLC1
Mus_musculus_10180_ENSG00000004534_000_RBM6
Mus_musculus_10140_ENSG00000141232_000_TOB1
Mus_musculus_10078_ENSG00000184281_000_TSSC4
Mus_musculus_10370_ENSG00000164442_000_CITED2
Mus_musculus_10427_ENSG00000138802_000_SEC24B 
  
	Individual lengths: 3180 | 2844 | 2268 | 1659 | 1425 | 1278 | 1035 | 852 | 798 | 600 |  
  
	Total length:	15939	nt 
  
	Mean length:	1593	nt 
  
	Median length:	1425	 nt | Identifier:	Mus_musculus_10395_ENSG00000164741_001_DLC1 
 
	Maximum length:	3180	 nt | Identifier:	Mus_musculus_10194_ENSG00000179981_000_TSHZ1 
 
	Minimum length:	600	 nt | Identifier:	Mus_musculus_10427_ENSG00000138802_000_SEC24B 
 
	95% confidence interval: 600 - 3180 nt 
```

## Problem detection ##

Each sequence should be written on a single line.

  `fasta_Length_Seq.sh test.fas`
 
```
    Sorry ... Your FASTA file is not UNILINE !
```

## History ##

* Dec. 2025 — Evaluate if the output is a terminal or a file in order to (de)activate colors. It avoids the output of uninterpreted characters.
  

