#!/bin/sh
#SBATCH --job-name=merge_chromosomes
#SBATCH --mem=150G
#SBATCH -o merge_log_output.out

module load R

Rscript merge_chromosomes.R
