#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=pcaprep
#SBATCH --mem=1g
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail

module load plink-uoneasy/2.00a3.7-foss-2023a

# Assumption of PCA is that data is independent
# Not the case for genomic data
# First step is to prune variants that are in linkage
# This will make series of new files so best to make a new directory and run wi$

mkdir -p /gpfs01/home/mbxlm9/L4141_updscrp/plink
cd /gpfs01/home/mbxlm9/L4141_updscrp/plink

# Set vcf to use - start with the most filtered, smallest file

VCF=/gpfs01/home/mbxlm9/L4141_updscrp/vcf/stick.70b.vcf.gz

# Perform linkage pruning - i.e. identify prune sites
# Like many softwares plink was developed for use on human genomes, so we have $
# --double-id duplicates the ID of samples, plink typically expects pedigree da$
# --allow-extra-chr plink expects human chromosomes!
# --set-missing-var-ids - so plink does not look for annotated ID names for SNPs
# --indep-pairwise set a window of 50kb and 10 bp window, set r-squared thresho$

# Identify sites to prune 
plink --vcf "$VCF" --double-id --allow-extra-chr \
--set-missing-var-ids @:# \
--indep-pairwise 50 10 0.1 --out stick
# Prune and creat PCA
# --extract only use those positions for pca
plink --vcf "$VCF" --double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract stick.prune.in \
--make-bed --pca --out stick


