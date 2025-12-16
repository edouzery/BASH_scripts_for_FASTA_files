# BASH scripts for FASTA files

## fasta_DeleteSeq.sh

It deletes sequence(s) from an uniline FASTA file.

## Example ##

  `fasta_DeleteSeq.sh population_snp.fasta ;`
 
```js

fasta_DeleteSeq.sh snp55119.fasta Rb7358 Rdc311 Rb7509 Rb3934 Rb7396 ;

Sequence(s) deleted from the snp55119.fasta FASTA file ||| Rb7358 Rdc311 Rb7509 Rb3934 Rb7396 ||| 

```

## Problem detection ##

Each sequence should be written on a single line.

  `fasta_DeleteSeq.sh test.fas`
 
```
    Sorry ... Your FASTA file is not UNILINE !
```

## History ##

* Dec. 2025 — Initial git commit.
  
