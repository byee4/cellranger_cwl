#!/usr/bin/env cwltool

cwlVersion: v1.0

class: Workflow

requirements:
  - class: InlineJavascriptRequirement
  - class: ScatterFeatureRequirement

inputs:
  investigator:
    type: string
  pi_name:
    type: string
  sequencing_center:
    type: string
  experiment_nickname:
    type: string
  experiment_start_date:
    type: string
  experiment_summary:
    type: string
  sequencing_date:
    type: string
  processing_date:
    type: string
  assay_protocol:
    type: string
  protocol_description:
    type: string
  organism:
    type: string
  aggr_expt_id:
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
          expt_id:
            type: string
          sample_id:
            type: string?
          fastq_dir:
            type: Directory
          transcriptome:
            type: Directory
          characteristics:
            type:
              type: array
              items:
                type: record
                name: characteristics
                fields:
                  name:
                    type: string
                  value:
                    type: string

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
      - expt_ids
      - sample_ids
      - fastq_dirs
      - transcriptome_dirs

  step_cellranger_count:
    run: cellranger_count.cwl
    scatter:
      - expt_id
      - sample_id
      - fastqs
      - transcriptome
    scatterMethod: dotproduct
    in:
      expt_id: step_parse_samples/expt_ids
      sample_id: step_parse_samples/sample_ids
      fastqs: step_parse_samples/fastq_dirs
      transcriptome: step_parse_samples/transcriptome_dirs
    out:
      - output

  step_cellranger_aggr:
    run: cellranger_aggr.cwl
    in:
      expt_id: aggr_expt_id
      normalize: aggr_norm_method
      h5_basedirs: step_cellranger_count/output
    out:
      - output_dir
      - aggregate_csv