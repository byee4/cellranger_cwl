#!/usr/bin/env cwltool


cwlVersion: v1.0
class: Workflow


requirements:
  - class: StepInputExpressionRequirement
  - class: SubworkflowFeatureRequirement
  - class: ScatterFeatureRequirement
  - class: InlineJavascriptRequirement
  - class: ShellCommandRequirement

inputs:

  # essential to run pipeline
  species:
    type: string
  cellranger_refdata:
    type: string
  fastq_path:
    type: string

  # template

  template_xlsx: File
  filled_expt_xlsx: string
  filled_sample_xlsx: string

  # IGM manifest metadata

  date: string
  institute: string
  pi_name: string
  pi_email: string
  member_of_mcc: string
  member_of_drc: string
  contact_name: string
  contact_email: string
  contact_phone_number: string
  index_number_or_po: string
  sequencing_platform: string
  type_of_run: string

  # other metadata

  study_title: string
  study_date: string
  study_publication: string
  cells_used: string
  neuron_induction_protocol: string
  plate_well_slide_format: string
  supplies_list: string
  assay_used: string
  assay_protocol_details: string
  software_packages_used: string

  sample_names: Any

outputs:

  final_igm_manifest:
    type: File
    outputSource: write_sample_data/filled_sample_xlsx

  sample_ids_list:
    type: string[]
    outputSource: collect_ids/sample_ids

  single_analysis_tar:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File[]
    ##############

    outputSource: scattered/single_analysis_tar

  single_summary:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File[]
    ##############

    outputSource: scattered/single_summary

  single_expressioncsv:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File[]
    ##############

    outputSource: scattered/single_expressioncsv

  single_metadata:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File[]
    ##############

    outputSource: scattered/single_metadata

  count_h5:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File[]
    ##############

    outputSource: scattered/single_h5

  aggregate_summary:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File
    ##############

    outputSource: aggregate/aggregate_summary

  aggregate_expressioncsv:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File
    ##############

    outputSource: aggregate/aggregate_expressioncsv

  aggregate_metadata:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File
    ##############

    outputSource: aggregate/aggregate_metadata

  aggregate_moleculeinfo:

    # gathering with a type which is array of type for output of scattered step
    ##############
    type: File
    ##############

    outputSource: aggregate/aggregate_moleculeinfo

steps:
  write_expt_data:
    run: string2igm_expt.cwl
    in:
      date: date
      institute: institute
      pi_name: pi_name
      pi_email: pi_email
      member_of_mcc: member_of_mcc
      member_of_drc: member_of_drc
      contact_name: contact_name
      contact_email: contact_email
      contact_phone_number: contact_phone_number
      index_number_or_po: index_number_or_po
      sequencing_platform: sequencing_platform
      type_of_run: type_of_run
      template_xlsx: template_xlsx
      filled_xlsx: filled_expt_xlsx
    out:
      - filled_expt_xlsx

  get_sample_data_string:
    run: string2igm_sample_string.cwl
    in:
      sample_names: sample_names
    out:
      - samples_string

  write_sample_data:
    run: string2igm_sample.cwl
    in:
      inputstring: get_sample_data_string/samples_string
      xlsx: write_expt_data/filled_expt_xlsx
      filled_xlsx: filled_sample_xlsx
    out:
      - filled_sample_xlsx

  collect_ids:
    run: collect_samples.cwl
    in:
      fastq_path: fastq_path
    out:
      - sample_ids

  scattered:

    run: cellranger_single.cwl
    in:
      species: species
      # job_name: job_name
      fastq_path: fastq_path
      cellranger_refdata: cellranger_refdata
      sample_name: collect_ids/sample_ids

    # scattering with an input of type which is array of type for input of scattered step
    #############
    scatter: sample_name
    #############

    out:
      - single_analysis_tar
      - single_summary
      - single_expressioncsv
      - single_metadata
      - single_h5

  aggregate:
    run: cellranger_aggregate.cwl
    in:
      species: species
      sample_name: scattered/single_h5
    out:
      - aggregate_summary
      - aggregate_expressioncsv
      - aggregate_metadata
      - aggregate_moleculeinfo
