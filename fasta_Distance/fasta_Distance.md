# BASH scripts for FASTA files

## fasta_Distance.sh

Compute **distance** descriptive statistics on pairs of DNA sequences from a FASTA file : **number of sites** (constant, variable, gapped), **transitions**, **transversions**, and differences between **each pair** of nucleotide.
If there is a reading frame, it can compute statistics according to the codon position.

## Example ##

  `fasta_Distance.sh 18s_rdna-deu.unix.fasta Salmo Squalus 123`
 
```python
 
 	 Sites selected = All  
	 Number of sites = 1594  
	 No-gapped sites = 1593  
 
	 Constant nt sites = 1530  
	 Variable nt sites = 63 (% = 3.9)  

 	 1-gap sites = 0  
 	 2-gap sites = 0  

->	A	C	G	T
A	371	1	4	2
C	4	368	0	16
G	9	5	440	3
T	6	12	1	351
 
	 Transitions = 41 
 	 Transversions = 22 

 	 Ti / Tv = 1.86  

```

## Problem detection ##

Each sequence should be written on a single line.

  `fasta_Keep_Longest.sh test.fas`
 
```
    Sorry ... Your FASTA file is not UNILINE !
```

