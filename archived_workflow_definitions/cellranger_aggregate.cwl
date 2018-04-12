#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool


baseCommand: [/home/bay001/processing_scripts/codebase/cellranger_cwl/development/CommandLineTool/cellranger_aggregate.sh]

inputs:
  species:
    type: string
    inputBinding:
      position: 1
  sample_name:
    type: File[]
    inputBinding:
      position: 2
outputs:
  aggregate_summary:
    type: File
    outputBinding:
      glob: aggregate.cloupe
  aggregate_expressioncsv:
    type: File
    outputBinding:
      glob: aggregate_expression.csv
  aggregate_metadata:
    type: File
    outputBinding:
      glob: aggregate_metadata.csv
  aggregate_moleculeinfo:
    type: File
    outputBinding:
      glob: aggregate_filtered_molecules.h5