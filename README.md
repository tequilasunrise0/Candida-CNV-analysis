# Candida-CNV-analysis
1. Get the bed file by convert2bed (https://github.com/alexpreynolds/convert2bed)
```bash
convert2bed -i gff < C_parapsilosis_CDC317_current_features.gff >  C_parapsilosis_CDC317.bed
```
2. Get the depth file by samtools
```bash
samtools depth -b C_parapsilosis_CDC317.bed your_sample.bam
```
3. Run depth.R script to calculate the copy number. The input files should be: (1) the depth file generated in step1, (2) the gff file,  (3) csv file of Gene of interest.
