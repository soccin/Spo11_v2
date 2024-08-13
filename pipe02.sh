#!/bin/bash

BIN=pipe02.bin
GENOME=/ifs/data/bio/Genomes/S.cerevisiae/sacCer2/SGD/20080628/SGD_sacCer2.fasta

DATADIR=$1
DATADIR=${DATADIR%%/}
TAG=$(basename $DATADIR)
echo $TAG

RESDIR=_._results01

ls -1 $DATADIR/S*/*_R1_*gz | xargs -n 1 bsub -pe alloc 7 -N SPO11 $BIN/spo11_Pipeline01.sh
qSYNC SPO11

find $RESDIR -name "*.sam" | xargs -n 1 -I % bsub -N SAM2MAP $BIN/sam2MapCheckClip.py % $GENOME

qSYNC SAM2MAP

ls -d _._results01/SGD_sacCer2/$TAG/Sample_* | xargs -n 1 bsub $BIN/mergeMaps.sh
ls -d _._results01/SGD_sacCer2/$TAG/Sample_* | xargs -n 1 bsub $BIN/mergeMultiMaps.sh

