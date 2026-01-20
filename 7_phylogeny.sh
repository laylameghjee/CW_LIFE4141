#!/bin/bash
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --job-name=phylogeny
#SBATCH --cpus-per-task=64
#SBATCH --mem=80G
#SBATCH --time=48:00:00
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
#SBATCH --mail-type=fail

#chnaged to cpus per task and increated this, also increased memory and time 

# Script to make quick phylogeny 
# First step is to convert vcf to phylip format using python script
REF=/gpfs01/home/mbxlm9/L4141_updscrp/vcf/stick.70b
module load python-uoneasy/3.12.3-GCCcore-13.3.0
python /gpfs01/home/mbxlm9/L4141_updscrp/vcf2phylip.py -i $REF.vcf.gz -o $REF.phy

# Use raxml to make bootstrapped phylogeny
module load raxml-ng-uoneasy/1.2.0-GCC-12.3.0
# This may take some time to run even with small datasets
# GTR is model of evolution assumed
#Changed threads to help code run faster
raxml-ng --all --msa ${REF}.min4.phy --threads 64 --force perf_threads --model GTR --prefix $REF --bs-trees 80
# many softwares available to visualise tree, output is Newick Standard Format  

