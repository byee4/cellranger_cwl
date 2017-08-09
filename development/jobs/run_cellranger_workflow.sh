#!/usr/bin/env bash

module load cellranger # load current cellranger installation
module load cwltool # load cwltool module
cwltool --cachedir /projects/ps-yeolab3/bay001/tmp/cellranger ../CommandLineTool/cellranger_workflow.cwl cellranger_workflow.yaml
