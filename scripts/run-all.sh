#!/bin/bash

set -e

python /scripts/samplescsv.py \
       --samplenames "$SAMPLENAMES" \
       --ncells $NUMCELLS \
       --fastqpath /input \
       --csvpath /samples.csv

source activate dropSeqPipe

cp /config/config.yaml /results/config.yaml
cp /samples.csv /results/samples.csv

snakemake \
      --snakefile scripts/merge/merge_fastq.smk

snakemake \
    --use-conda \
    --jobs $JOBS \
    --snakefile /dropSeqPipe/Snakefile \
    --directory /results/ \
    $TARGETS \
    > >(tee -a /results/stdout.log) \
    2> >(tee -a /results/stderr.log >&2)

chmod -R a+w /results
chown -R nobody /results
