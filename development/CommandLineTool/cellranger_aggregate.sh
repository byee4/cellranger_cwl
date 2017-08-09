#!/usr/bin/env bash


set -x


# cellranger_aggregate.sh SPECIES

read -r -d '' USAGE<<'EOUSAGE'
This is cellranger aggregate - running cellranger aggr 2.0.0 on all samples
==================================================================
Usage :
  cellranger_aggregate.sh SPECIES SAMPLEID1 SAMPLEID2 [SAMPLEID3..]

Parameters:
  SPECIES: either hg19 or mm10
  
EOUSAGE



if [ $# -eq 0 ]
then
    echo
    echo "$USAGE"
    echo
else

H5FILES=( "$@" )

OUTPUTFOLDERID="aggregate"
SPECIES=$1

mkdir -p results/temp

echo "library_id,molecule_h5" > results/temp/aggregate.csv
for arg in "${H5FILES[@]:1}"; do
    BASE=$(basename "$arg" .h5)
    echo "$BASE,$arg" >> results/temp/aggregate.csv
done

# mkdir -p results/temp

cd results/temp

echo
echo ===============================
echo running cellranger aggr v 2.0.0
echo cellranger aggr \
  --id ${OUTPUTFOLDERID} \
  --csv=aggregate.csv \
  --normalize=mapped \
  --uiport=3600
echo ===============================
echo

cellranger aggr \
  --id ${OUTPUTFOLDERID} \
  --csv=aggregate.csv \
  --normalize=mapped \
  --uiport=3600

echo
echo ========================
echo "finished cellranger_aggregate.sh"
echo ========================
echo

cd ../..

#mkdir -p results/summary
#mkdir -p results/cloupe
#mkdir -p results/filteredcountscsv

# copy analysis folder
CELLRANGER_ANALYSIS="${OUTPUTFOLDERID}/outs/analysis"

# copy web summary page
SRC_SUMMARY="results/temp/${OUTPUTFOLDERID}/outs/web_summary.html"
TARGET_SUMMARY="${OUTPUTFOLDERID}.summary.html"
cp ${SRC_SUMMARY} ${TARGET_SUMMARY}

# copy loupe data file
SRC_CLOUPE="results/temp/${OUTPUTFOLDERID}/outs/cloupe.cloupe"
TARGET_CLOUPE="${OUTPUTFOLDERID}.cloupe"
cp ${SRC_CLOUPE} ${TARGET_CLOUPE}

# make granatum expression csv
CELLRANGER_FILTEREDFOLDER="results/temp/${OUTPUTFOLDERID}/outs/filtered_gene_bc_matrices_mex/"
CELLRANGER_EXPRESSIONCSV="${OUTPUTFOLDERID}_expression.csv"
cellranger mat2csv ${CELLRANGER_FILTEREDFOLDER} ${CELLRANGER_EXPRESSIONCSV} --genome ${SPECIES}

# make granatum metadata csv
CELLRANGER_BARCODESTSV="results/temp/${OUTPUTFOLDERID}/outs/cell_barcodes.csv"
CELLRANGER_METADATACSV="${OUTPUTFOLDERID}_metadata.csv"
# create first line of csv with these 2 column titles
echo "CELL_ID,SAMPLE_ID" > ${CELLRANGER_METADATACSV}
# add a comma separated value in second column of each row to show sampleid
# sed replaces the end of line with ",${FASTQSSAMPLENAME}"
sed "s/$/,${OUTPUTFOLDERID}/" "${CELLRANGER_BARCODESTSV}" >> ${CELLRANGER_METADATACSV}

SRC_H5="results/temp/${OUTPUTFOLDERID}/outs/filtered_molecules.h5"
TARGET_H5="${OUTPUTFOLDERID}_filtered_molecules.h5"
cp ${SRC_H5} ${TARGET_H5}

echo
echo =============================================
echo "finished cellranger_aggregate.sh for species" ${SPECIES}
echo =============================================
echo



fi


