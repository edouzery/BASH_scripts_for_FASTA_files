# BASH_scripts_for_FASTA_files

## fasta_Parser.sh

This BASH script checks the format of a FASTA file.
- Is it uniline (= each sequence written on a single line)? 
- Are sequences aligned?

If correct, it retruns the **number of sequences** and the **number of sites** (= columns of the alignment).

## Example ##

  `fasta_Parser.sh brca1_macse2_NT_Genera.fasta`
 
```python
  Yes ! brca1_macse2_NT_Genera.fasta is a FASTA file, uniline, with all 9 sequences of length = 2913 sites.
```

## Problem detection ##

  `fasta_Parser.sh test.fasta`
 
```
   Aargh :-( test.fasta has a problem with Bradypus ... Previous sequences in the alignment do not have the same LENGTH !
```
