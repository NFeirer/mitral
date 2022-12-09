#!/bin/sh
#SBATCH --job-name=doall
#SBATCH --mem=150G
#SBATCH -o doall_log_output.out
#SBATCH -c 22

module load R

cd mitral

Rscript doall.R
