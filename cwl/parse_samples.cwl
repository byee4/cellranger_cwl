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
          library_nickname:
            type: string
          library_prep:
            type: string
          sample_id:
            type: string?
          expect_cells:
            type: int
          fastq_dir:
            type: Directory
          transcriptome:
            type: Directory
          read1_length:
            type: int
          read2_length:
            type: int
          instrument_model:
            type: string
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

  library_nicknames:
    type: string[]
  sample_ids:
    type: string[]
  fastq_dirs:
    type: Directory[]
  transcriptome_dirs:
    type: Directory[]
  expect_cells:
    type: int[]

expression: |
   ${
      var library_nicknames = [];
      var sample_ids = [];
      var fastq_dirs = [];
      var transcriptome_dirs = [];
      var expect_cells = [];

      for (var i=0; i<inputs.samples.length; i++) {
        library_nicknames.push(inputs.samples[i].library_nickname);
        sample_ids.push(inputs.samples[i].sample_id);
        fastq_dirs.push(inputs.samples[i].fastq_dir);
        transcriptome_dirs.push(inputs.samples[i].transcriptome);
        expect_cells.push(inputs.samples[i].expect_cells);
      }
      return {
        'library_nicknames':library_nicknames,
        'sample_ids':sample_ids,
        'fastq_dirs':fastq_dirs,
        'transcriptome_dirs':transcriptome_dirs,
        'expect_cells':expect_cells
      };
    }

doc: |
  This tool parses an array of records, with each record containing
    Usage: