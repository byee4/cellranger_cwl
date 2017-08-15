#!/usr/bin/env cwltool

cwlVersion: v1.0

class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:
  metadata: Any

outputs:
  exptString:
    type: string

expression: "${var exptString = \"field\\tvalue\\n\";
               var dict = inputs.metadata;
               for (var field in dict) {
                 var key = Object.keys(dict[field]);
                 var value = dict[field][Object.keys(dict[field])];
                 exptString += key + '\\t' + value + '\\n';
               }
               return exptString;
              }"