#!/usr/bin/env bash

FASTQ_DIR=$1

echo '' > samples.txt

sed -i '1d' samples.txt

for FASTQ_FILE in ${FASTQ_DIR}/SI-GA-*_?/*.fastq.gz
do
  FASTQ_NODIR=${FASTQ_FILE/*\//}
  FASTQ_NOEXT=${FASTQ_NODIR/.*/}
  SAMPLEID=${FASTQ_NOEXT/_S??_L???_R?_???/}
  echo ${SAMPLEID} | awk -F "_" '{print $1}' >> samples.txt
done

sort -u samples.txt > samples.uniq.nl.txt

# see: https://discussions.apple.com/thread/2418090?start=0&tstart=0 to get rid of the last newline
echo -n "$(cat samples.uniq.nl.txt)" > samples.uniq.txt