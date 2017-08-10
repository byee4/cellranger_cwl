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

  # other metadata

  investigator: string
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


outputs:
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
