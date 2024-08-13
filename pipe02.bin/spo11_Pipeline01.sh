#!/bin/bash

echo "###TS" `date`

ADAPTER=AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC
GENOME=/ifs/data/bio/Genomes/S.cerevisiae/sacCer2/SGD/20080628/SGD_sacCer2.fasta
GENOMETAG=SGD_sacCer2

#GMAPPER=/home/socci/bin/gmapper-ls --local --qv-offset 33
GMAPPER=/ifs/data/socci/Work/SeqAna/Mappers/SHRiMP/2_1_1/SHRiMP_2_1_1b/bin/gmapper-ls

FASTQ=$1
FOLDER=$(dirname $FASTQ | pyp "s[-2:]|s")
BASE=${FASTQ##*/}
BASE=${BASE%%.*}
OUTFOLDER=_._results01/$GENOMETAG/$FOLDER
BASE=$OUTFOLDER/$BASE
mkdir -p $OUTFOLDER

BIN=pipe02.bin

zcat $FASTQ | /ifs/data/socci/opt/bin/fastx_clipper -a $ADAPTER -l 15 -n -v -Q33 -i - \
    | $BIN/splitMixer.py > ${BASE}___CLIPPED.fastq

$GMAPPER -N 15 -U -g -1000 -q -1000 \
    -m 10 -i -20 -h 100 -r 50% \
    -n 1 -s 1111111111,11110111101111,1111011100100001111,1111000011001101111 \
	-o 1001 -Q -E --sam-unaligned --strata \
	${BASE}___CLIPPED.fastq $GENOME >${BASE}.sam

echo "###TS" `date`
