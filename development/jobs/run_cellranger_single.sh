#!/usr/bin/env bash

module load cellranger # load current cellranger installation
module load cwltool # load cwltool module
PATH=../CommandLineTool:$PATH # append new cellranger1 script first
cwltool ../CommandLineTool/cellranger1.cwl cellranger1.yaml