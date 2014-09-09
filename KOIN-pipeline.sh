# KOIN Pipeline (Linux commands)
#
# Created by Wolfgang Krebs, 02. September 2014
# LIMES Institute, University of Bonn, Germany
#
# Calculations were performed on a RedHat 64bit Linux environment.
# Options for corresponding programs might need to be adapted to fit to 
# other datasets (program directories, reference genome, genome size, p-
# values...)
#
# General steps:
# 1. Alignment
# 2. Peak Calling (KOIN)
# 3. Optional data analysis
#
# For all described general steps other aligners or peak calling programs 
# could be utilized, as long as the peak caller can use a KO dataset as 
# background during calculations.
#
# Before usage: Exchange all path descriptions in <> with corresponding 
# destinations.
# 
# Linux commands are depicted in green
# 




### 1. Alignment of ChIP-seq experiments with Bowtie
#
# In this first step, wildtype (WT) and knockout (KO) ChIP-seq experiments 
# (e.g. in fastq format) are aligned to the reference genome of choice (e.g. 
# hg18/hg19 for human datasets)and exported as sam files.
#

<bowtie_directory>/bowtie -t -q -e 70 -l 28 -n 2 --best --maxbts 125 -S <reference_genome> -q <WT-ChIP-seq-file.fastq> <Aligned-WT-ChIP-seq-file.sam>

<bowtie_directory>/bowtie -t -q -e 70 -l 28 -n 2 --best --maxbts 125 -S <reference_genome> -q <KO-ChIP-seq-file.fastq> <Aligned-KO-ChIP-seq-file.sam>



### 2. Peak Calling using MACS
#
# Knockout implemented normalization (KOIN) is performed during peak calling 
# with MACS utilizing the WT dataset as treatment and the KO dataset as 
# control resulting in false positive curated peak files in bed format.
#

<MACS_directory>/bin/macs -t <Aligned-WT-ChIP-seq-file.sam> -c <Aligned-KO-ChIP-seq-file.sam> -n KOIN-corrected-peak-file -f SAM -g 1.87e9 -s 51 --bw 150 -p 1e-4 --on-auto 



### 3. Optional example steps for downstream data analysis:
#
# a. Annotation of Peak sites with HOMER:
#
# Find nearest transcriptional start sites of known genes for called peaks 
#and detailed information about position on the used reference genome.
#

<HOMER_directory>/bin/annotatePeaks.pl <KOIN-corrected-peak-file.bed> <reference_genome> -size given > <Annotated-KOIN-corrected-peak-file.txt>


#
# b. De novo motif enrichment for KOIN corrected peak sites with HOMER 
# program:
#
# Perform a de novo motif enrichment analysis with HOMER at 200bp regions 
# around KOIN corrected peaks to detected enriched DNA binding motifs.
#

<HOMER_directory>/bin/findMotifsGenome.pl <KOIN-corrected-peak-file.bed> <reference_genome> <Motif_calculations_output_directory> -size 200

