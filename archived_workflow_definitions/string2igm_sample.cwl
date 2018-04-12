#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool


baseCommand: [python, /home/bay001/projects/codebase/cellranger_cwl/development/CommandLineTool/string2igm_sample.py]

inputs:
  inputstring:
    type: string
    inputBinding:
      position: 1
      prefix: --inputstring
  xlsx:
    type: File
    inputBinding:
      position: 2
      prefix: --xlsx
  filled_xlsx:
    type: string
    inputBinding:
      position: 3
      prefix: --output
outputs:
  filled_sample_xlsx:
    type: File
    outputBinding:
      glob: $(inputs.filled_xlsx)
