#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --job-name=fst.scan
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1G
#SBATCH --time=2:00:00
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail

module load vcftools-uoneasy/0.1.16-GCC-12.3.0

# Use this command to extract individual names (which will include path)
# module load bcftools-uoneasy/1.18-GCC-13.2.00
# bcftools query -l $YOURVCF
# Basic script to estimate Fst in windows across the genome
# Example code for vcftools Fst window scan in obse vs obsm contrast

vcftools --gzvcf /gpfs01/home/mbxlm9/L4141_updscrp/vcf/stick.70b.vcf.gz \
--max-missing 0.8 \
--maf 0.05 \
--weir-fst-pop /gpfs01/home/mbxlm9/L4141_updscrp/POPFILES/obse.txt \
--weir-fst-pop /gpfs01/home/mbxlm9/L4141_updscrp/POPFILES/obsm.txt \
--fst-window-size 5000 \
--fst-window-step 5000 \
--out /gpfs01/home/mbxlm9/L4141_updscrp/fst/obse_vs_obsm_5kb