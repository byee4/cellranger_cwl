#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool


baseCommand: [cellranger_single.sh]

inputs:
  sample_name:
    type: string
    inputBinding:
      position: 1
  species:
    type: string
    inputBinding:
      position: 2
  # job_name:
  #   type: string
  #   inputBinding:
  #     position: 3
  cellranger_refdata:
    type: string
    inputBinding:
      position: 3
  fastq_path:
    type: string
    inputBinding:
      position: 4
outputs:
  single_analysis_tar:
    type: File
    outputBinding:
      glob: $(inputs.sample_name)_analysis.tar
  single_summary:
    type: File
    outputBinding:
      glob: $(inputs.sample_name).cloupe
  single_expressioncsv:
    type: File
    outputBinding:
      glob: $(inputs.sample_name)_expression.csv
  single_metadata:
    type: File
    outputBinding:
      glob: $(inputs.sample_name)_metadata.csv
  single_h5:
    type: File
    outputBinding:
      glob: $(inputs.sample_name)_molecule_info.h5