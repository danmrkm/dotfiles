#!/bin/bash

FILENAME_ORG="icon"
EXT=".png"
orgfile=$1

for i in `echo 512 256 128 64 32`
do
    doublesize=`expr ${i} \* 2`
    sips -Z ${doublesize} ${orgfile} -o ${FILENAME_ORG}"_"${i}"x"${i}"@2x"${EXT}
    sips -Z ${i} ${orgfile} -o ${FILENAME_ORG}"_"${i}"x"${i}${EXT}
done
