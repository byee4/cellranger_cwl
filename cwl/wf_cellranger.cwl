#!/usr/bin/env cwltool

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement

inputs:
  investigator:
    type: string
  run_date:
    type: string
  assay_protocol:
    type: string
  aggr_run_id:
    type: string
  aggr_norm_method:
    type: string
    default: "mapped"
  samples:
    type:
      type: array
      items:
        type: record
        fields:
          run_id:
            type: string
          sample_id:
            type: string?
          fastq_dir:
            type: Directory
          transcriptome:
            type: Directory

outputs:
  output_dir:
    type: Directory
    outputSource: step_cellranger_aggr/output_dir

steps:

  step_parse_samples:
    run: parse_samples.cwl
    in:
      samples: samples
    out:
      - run_ids
      - sample_ids
      - fastq_dirs
      - transcriptome_dirs

  step_cellranger_count:
    run: cellranger_count.cwl
    scatter:
      - run_id
      # - sample_id
      - fastqs
      - transcriptome
    scatterMethod: dotproduct
    in:
      run_id: step_parse_samples/run_ids
      # sample: step_parse_samples/sample_ids
      fastqs: step_parse_samples/fastq_dirs
      transcriptome: step_parse_samples/transcriptome_dirs
    out:
      - output

  step_cellranger_aggr:
    run: cellranger_aggr.cwl
    in:
      run_id: aggr_run_id
      normalize: aggr_norm_method
      h5_basedirs: step_cellranger_count/output
    out:
      - output_dir
      - aggregate_csv