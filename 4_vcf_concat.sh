#!/bin/bash
# Script for mpileup in bcftools to generate VCF / BCF file
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=20
#SBATCH --job-name=stickpileupMQ20
#SBATCH --mem=20g
#SBATCH --time=24:00:00
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail
module load bcftools-uoneasy/1.18-GCC-13.2.0

# Concatenate all vcf files into a single vcf file
bcftools concat --file-list /gpfs01/home/mbxlm9/L4141_updscrp/vcf/vcf.list.txt -Oz -o /gpfs01/home/mbxlm9/L4141_updscrp/vcf/stick.vcf.gz
bcftools index /gpfs01/home/mbxlm9/L4141_updscrp/vcf/stick.vcf.gz

