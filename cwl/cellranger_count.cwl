#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: ResourceRequirement
    coresMin: 8
    coresMax: 16
    ramMin: 32000
    # tmpdirMin: 4000
    # outdirMin: 4000

baseCommand: [cellranger, count]

inputs:
  expt_id:
    type: string
    inputBinding:
      prefix: --id
  sample_id:
    type: string?
    inputBinding:
      prefix: --sample
  fastqs:
    type: Directory
    inputBinding:
      prefix: --fastqs
  transcriptome:
    type: Directory
    inputBinding:
      prefix: --transcriptome
  nopreflight:
    type: boolean
    default: true
    inputBinding:
      prefix: --nopreflight
  uiport:
    type: int
    default: 3600
    inputBinding:
      prefix: --uiport

outputs:
  output:
    type: Directory
    outputBinding:
      glob: "$(inputs.expt_id)"