#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  # - class: ShellCommandRequirement

baseCommand: [/home/bay001/processing_scripts/codebase/cellranger_cwl/development/CommandLineTool/collect_samples.sh]

inputs:
  fastq_path:
    type: string
    inputBinding:
      position: 1
outputs:
  sample_ids:
    type: string[]
    outputBinding:
      glob: samples.uniq.txt
      loadContents: true
      outputEval: $(self[0].contents.split('\n'))