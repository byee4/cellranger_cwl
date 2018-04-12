#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

baseCommand: [create_aggregate_file.sh]

inputs:
  output:
    type: string
    inputBinding:
      position: 0
  h5_basedirs:
    type: Directory[]
    inputBinding:
      position: 1

outputs:
  output_file:
    type: File
    outputBinding:
      glob: $(inputs.output)
  output_h5_basedirs:
    type: Directory[]
    glob: $(inputs.h5_basedirs)

doc: |
  Creates the aggregate manifest file for combining multiple 10X cellranger
  outputs.