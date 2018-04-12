#!/usr/bin/env bash

PATH=../CommandLineTool:$PATH # append new cellranger1 script first
cwltool ../CommandLineTool/string2igm_expt_string.cwl cellranger_workflow.yaml

