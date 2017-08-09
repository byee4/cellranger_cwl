#!/usr/bin/env bash

set -x

# cellranger_single.sh FASTQSSAMPLENAME FASTQSSAMPLENAME SPECIES JOBNAME


read -r -d '' USAGE<<'EOUSAGE'
This is cellranger_single - running cellranger count 2.0.0 on one sample
==================================================================
Usage :
  cellranger_single.sh FASTQSSAMPLENAME SPECIES JOBNAME REFDATA FASTQPATH

Parameters:
  FASTQSSAMPLENAME:  a name for one of the sample to process, must match with what was used to name the fastqs for that sample
  SPECIES: either hg19 or mm10
  JOBNAME: jobname to use for the logs in results/CELLRANGER1-JOB-COPY.${JOBNAME}.txt
  REFDATA: folder where the cellranger reference data is kept
  FASTQPATH: path to the 4 folders containing the fastqs of interest.

EOUSAGE



if [ $# -eq 0 ]
then
    echo
    echo "$USAGE"
    echo
else

FASTQSSAMPLENAME=$1
SPECIES=$2
JOBNAME=$3
CELLRANGER_REFDATA=$4
FASTQPATH=$5

mkdir -p results/temp
touch results/CELLRANGER1-JOB-COPY.${JOBNAME}.txt
touch results/CELLRANGER1-VERSION-2.0.0
touch results/CELLRANGER1-JOB-LOG.txt

# echo cd results/temp
cd results/temp

echo
echo ================================
echo running cellranger count v 2.0.0 what
echo cellranger count \
  --id=${FASTQSSAMPLENAME} \
  --sample=${FASTQSSAMPLENAME} \
  --fastqs=${FASTQPATH} \
  --transcriptome=${CELLRANGER_REFDATA}/refdata-cellranger-${SPECIES}-1.2.0 \
  --nopreflight \
  --uiport=3600
echo ===============================
echo

cellranger count \
  --id=${FASTQSSAMPLENAME} \
  --sample=${FASTQSSAMPLENAME} \
  --fastqs=${FASTQPATH} \
  --transcriptome=${CELLRANGER_REFDATA}/refdata-cellranger-${SPECIES}-1.2.0 \
  --nopreflight \
  --uiport=3600

cd -

echo
echo =====================================================
echo "finished cellranger_single.sh for sample" ${FASTQSSAMPLENAME}
echo "temp folder is: results/temp/${FASTQSSAMPLENAME} "
echo =====================================================
echo

mkdir -p results/analysis
mkdir -p results/summary
mkdir -p results/cloupe
mkdir -p results/filteredcountscsv


# copy analysis folder
CELLRANGER_ANALYSIS="${FASTQSSAMPLENAME}/outs/analysis"

# copy web summary page
SRC_SUMMARY="results/temp/${FASTQSSAMPLENAME}/outs/web_summary.html"
TARGET_SUMMARY="${FASTQSSAMPLENAME}.summary.html"
cp ${SRC_SUMMARY} ${TARGET_SUMMARY}

# copy loupe data file
SRC_CLOUPE="results/temp/${FASTQSSAMPLENAME}/outs/cloupe.cloupe"
TARGET_CLOUPE="${FASTQSSAMPLENAME}.cloupe"
cp ${SRC_CLOUPE} ${TARGET_CLOUPE}

# make granatum expression csv
CELLRANGER_FILTEREDFOLDER="results/temp/${FASTQSSAMPLENAME}/outs/filtered_gene_bc_matrices/"
CELLRANGER_EXPRESSIONCSV="${FASTQSSAMPLENAME}_expression.csv"
cellranger mat2csv ${CELLRANGER_FILTEREDFOLDER} ${CELLRANGER_EXPRESSIONCSV} --genome ${SPECIES}

# make granatum metadata csv
CELLRANGER_BARCODESTSV="results/temp/${FASTQSSAMPLENAME}/outs/filtered_gene_bc_matrices/${SPECIES}/barcodes.tsv"
CELLRANGER_METADATACSV="${FASTQSSAMPLENAME}_metadata.csv"
# create first line of csv with these 2 column titles
echo "CELL_ID,SAMPLE_ID" > ${CELLRANGER_METADATACSV}
# add a comma separated value in second column of each row to show sampleid
# sed replaces the end of line with ",${FASTQSSAMPLENAME}"
sed "s/$/,${FASTQSSAMPLENAME}/" "${CELLRANGER_BARCODESTSV}" >> ${CELLRANGER_METADATACSV}

SRC_H5="results/temp/${FASTQSSAMPLENAME}/outs/molecule_info.h5"
TARGET_H5="${FASTQSSAMPLENAME}_molecule_info.h5"
cp ${SRC_H5} ${TARGET_H5}

echo
echo =====================================================
echo "finished cellranger2 for sample" ${FASTQSSAMPLENAME}
echo =====================================================
echo

tar -cvf ${FASTQSSAMPLENAME}.tar results/temp/${FASTQSSAMPLENAME}/*
tar -cvf ${FASTQSSAMPLENAME}_analysis.tar results/temp/${CELLRANGER_ANALYSIS}/*

fi

exit 0
