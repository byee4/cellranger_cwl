#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool


baseCommand: [python, /home/bay001/projects/codebase/cellranger_cwl/development/CommandLineTool/string2igm_expt.py]

inputs:
  date:
    type: string
    default: NA
    inputBinding:
      position: 1
      prefix: --date
  institute:
    type: string
    default: NA
    inputBinding:
      position: 2
      prefix: --institute
  pi_name:
    type: string
    default: NA
    inputBinding:
      position: 3
      prefix: --pi_name
  pi_email:
    type: string
    default: NA
    inputBinding:
      position: 4
      prefix: --pi_email
  member_of_mcc:
    type: string
    default: NA
    inputBinding:
      position: 5
      prefix: --member_of_mcc
  member_of_drc:
    type: string
    default: NA
    inputBinding:
      position: 6
      prefix: --member_of_drc
  contact_name:
    type: string
    default: NA
    inputBinding:
      position: 7
      prefix: --contact_name
  contact_email:
    type: string
    default: NA
    inputBinding:
      position: 8
      prefix: --contact_email
  contact_phone_number:
    type: string
    default: NA
    inputBinding:
      position: 9
      prefix: --contact_phone_number
  index_number_or_po:
    type: string
    default: NA
    inputBinding:
      position: 10
      prefix: --index_number_or_po
  sequencing_platform:
    type: string
    default: NA
    inputBinding:
      position: 11
      prefix: --sequencing_platform
  type_of_run:
    type: string
    default: NA
    inputBinding:
      position: 12
      prefix: --type_of_run
  number_of_cycles:
    type: string
    default: NA
    inputBinding:
      position: 13
      prefix: --number_of_cycles
  run_bioanalyzer_tape_station:
    type: string
    default: NA
    inputBinding:
      position: 14
      prefix: --run_bioanalyzer_tape_station
  perform_qpcr:
    type: string
    default: NA
    inputBinding:
      position: 15
      prefix: --perform_qpcr
  phix_spike_in_requested:
    type: string
    default: NA
    inputBinding:
      position: 16
      prefix: --phix_spike_in_requested
  percentage_of_phix_if_applicable:
    type: string
    default: NA
    inputBinding:
      position: 17
      prefix: --percentage_of_phix_if_applicable
  indexing_system:
    type: string
    default: NA
    inputBinding:
      position: 18
      prefix: --indexing_system
  total_number_of_lanes:
    type: string
    default: NA
    inputBinding:
      position: 19
      prefix: --total_number_of_lanes
  total_number_of_samples:
    type: string
    default: NA
    inputBinding:
      position: 20
      prefix: --total_number_of_samples
  template_xlsx:
    type: File
    inputBinding:
      position: 21
      prefix: --xlsx
  filled_xlsx:
    type: string
    inputBinding:
      position: 22
      prefix: --output

outputs:
  filled_expt_xlsx:
    type: File
    outputBinding:
      glob: $(inputs.filled_xlsx)
