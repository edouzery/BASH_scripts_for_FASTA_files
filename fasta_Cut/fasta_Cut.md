# BASH scripts for FASTA files

## fasta_Cut.sh

It cuts all the sequences of a FASTA file in order to keep only positions X (included) to Y (included).

## Example ##

  `fasta_Cut.sh 747_ENSG00000134780_002_DAGLA_final_align_NT.fas 100 300 ;`
 
```js
  
Sequences of the 747_ENSG00000134780_002_DAGLA_final_align_NT.fas FASTA file have been cut in order to keep only positions 100 to 300 (included). 

```

## Problem detection ##

Each sequence should be written on a single line.

  `fasta_Composition_NT.sh test.fas`
 
```
    Sorry ... Your FASTA file is not UNILINE !
```

All sequences should have the same number of letters.

```
    Problem with Macruromys_major_AM14730 and Lorentzimys_timsowangi_FR2200_14_Finisterre ... Aligned sequences do not have the same LENGTH !
```

## History ##

* Dec. 2025 — Initial git commit.
  
