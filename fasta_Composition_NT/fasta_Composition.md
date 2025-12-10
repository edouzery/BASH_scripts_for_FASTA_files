# BASH scripts for FASTA files

## fasta_Composition_NT.sh

It calculates the **number of nucleotide**, and other IUPAC character, occurrences in each (aligned or not) sequence of a FASTA file.
It also detects potential **non-standard** (alien) characters.

## Example ##

  `fasta_Composition_NT.sh population_snp.fasta ;`
 
```js
  
 	populations.snp.fasta	|	10 sequences	|	55 119 sites	|  	 551 190 states. 
 
 	0 alien character. 

Tax_Seq A   C   G   T   N   R   Y   M   W   S   K   B   D   H   V   Dash   Missing
Rb7577 A=6550 C=18489 G=18428 T=6391 N=4549 R=285 Y=242 M=47 W=42 S=38 K=58 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7594 A=6962 C=19594 G=19575 T=6758 N=1567 R=233 Y=255 M=39 W=38 S=48 K=50 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7596 A=6773 C=19110 G=19082 T=6600 N=2915 R=232 Y=255 M=48 W=41 S=32 K=31 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7609 A=7001 C=19773 G=19634 T=6822 N=1247 R=234 Y=228 M=50 W=43 S=42 K=45 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7617 A=6997 C=19770 G=19749 T=6844 N=1206 R=205 Y=204 M=47 W=28 S=38 K=31 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7618 A=5763 C=16331 G=16247 T=5606 N=10506 R=258 Y=256 M=37 W=44 S=33 K=38 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7626 A=6858 C=19263 G=19172 T=6679 N=2461 R=257 Y=268 M=47 W=36 S=36 K=42 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7628 A=7004 C=19717 G=19643 T=6795 N=1435 R=203 Y=198 M=38 W=25 S=29 K=32 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7629 A=7037 C=19841 G=19753 T=6860 N=1115 R=190 Y=198 M=35 W=24 S=35 K=31 B=0 D=0 H=0 V=0 -=0 ?=0
Rb7630 A=7061 C=19824 G=19691 T=6860 N=1191 R=184 Y=177 M=37 W=25 S=30 K=39 B=0 D=0 H=0 V=0 -=0 ?=0


```

## Problem detection ##

Each sequence should be written on a single line.

  `fasta_Composition_NT.sh test.fas`
 
```
    Sorry ... Your FASTA file is not UNILINE !
```

## History ##

* Dec. 2025 — Initial git commit.
  
