#!/usr/bin/env cwltool

### parses a record object ###

cwlVersion: v1.0
class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:

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

  run_ids:
    type: string[]
  sample_ids:
    type: string[]
  fastq_dirs:
    type: Directory[]
  transcriptome_dirs:
    type: Directory[]

expression: |
   ${
      var run_ids = [];
      var sample_ids = [];
      var fastq_dirs = [];
      var transcriptome_dirs = [];

      for (var i=0; i<inputs.samples.length; i++) {
        run_ids.push(inputs.samples[i].run_id);
        sample_ids.push(inputs.samples[i].sample_id);
        fastq_dirs.push(inputs.samples[i].fastq_dir);
        transcriptome_dirs.push(inputs.samples[i].transcriptome);
      }
      return {
        'run_ids':run_ids,
        'sample_ids':sample_ids,
        'fastq_dirs':fastq_dirs,
        'transcriptome_dirs':transcriptome_dirs,
      };
    }

doc: |
  This tool parses an array of records, with each record containing
    Usage: