#!/usr/bin/env cwltool

cwlVersion: v1.0

class: CommandLineTool

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - entryname: aggregate.csv
        entry: "${
            var exptString = \"library_id,molecule_h5\\n\";
            var baseDirs = inputs.h5_basedirs;
            for (var i=0; i < baseDirs.length; i++) {
              exptString += baseDirs[i].basename + ',' + baseDirs[i].path + '/outs/molecule_info.h5' + '\\n';
            }
            return exptString;
          }"

baseCommand: [cellranger, aggr]

arguments: [
  "--csv", "aggregate.csv"
]

inputs:
  aggr_nickname:
    type: string
    inputBinding:
      prefix: --id
  normalize:
    default: "mapped"
    type: string
    inputBinding:
      prefix: --normalize
  h5_basedirs:
    type: Directory[]

outputs:
  output_dir:
    type: Directory
    outputBinding:
      glob: "$(inputs.aggr_nickname)"
  aggregate_csv:
    type: File
    outputBinding:
      glob: aggregate.csv

doc: |
  The javascript entry creates the aggregate.csv manifest. The commandlinetool
  calls cellranger aggregate based on the aggregate.csv, which was created
  from the list of h5_basedirs specified.