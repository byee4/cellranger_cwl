#!/usr/bin/env cwltool

cwlVersion: v1.0

class: ExpressionTool

requirements:
  - class: InlineJavascriptRequirement

inputs:
  sample_names: Any

outputs:
  samples_string:
    type: string

expression: "${var sampleString = \"sample_name\\tuid\\tsize\\tconcentration\\tvolume\\tquantification\\tlibrary_prep\\n\";
               var dictOfDict = inputs.sample_names;
               for (var sample in dictOfDict) {
                 var name = Object.keys(dictOfDict[sample]);
                 sampleString += name + '\\t' +
                 dictOfDict[sample][name]['uid'] + '\\t' +
                 dictOfDict[sample][name]['size'] + '\\t' +
                 dictOfDict[sample][name]['concentration'] + '\\t' +
                 dictOfDict[sample][name]['volume'] + '\\t' +
                 dictOfDict[sample][name]['quantification'] + '\\t' +
                 dictOfDict[sample][name]['library_prep'] + '\\n';
               }
               return {'samples_string':sampleString};
              }"