#!/usr/bin/env bash

PATH=../CommandLineTool:$PATH # append new cellranger1 script first
cwltool ../CommandLineTool/string2igm_sample.cwl string2igm_sample.yaml

