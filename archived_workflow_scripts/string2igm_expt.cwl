#!/usr/bin/env cwl-runner

cwlVersion: v1.0

class: CommandLineTool


baseCommand: [python, /home/bay001/projects/codebase/cellranger_cwl/development/CommandLineTool/yaml2igm_expt.py]

inputs:
  yaml:
    type: File
    inputBinding:
      position: 1
      prefix: --yaml
  xlsx:
    type: File
    inputBinding:
      position: 2
      prefix: --xlsx
  output:
    type: string
    inputBinding:
      position: 3
      prefix: --output
outputs:
  filled_expt_xlsx:
    type: File
    outputBinding:
      glob: $(inputs.output)
