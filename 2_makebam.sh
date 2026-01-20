#!/bin/bash
#SBATCH --partition=defq
#SBATCH --job-name=makebam
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --mem=8g
#SBATCH --time=4:00:00
#SBATCH --mail-user=mbxlm9@nottingham.ac.uk
#SBATCH --mail-type=begin
#SBATCH --mail-type=fail
#SBATCH --mail-type=end
#SBATCH --array=0-43   # Adjust based on number of lines in root_names.txt; first sample is "0"!
# Script to align sequences to stickleback genome, outputting a bam file
# Script removes duplicates
# Load software
module load samtools-uoneasy/1.18-GCC-12.3.0
module load bwa-uoneasy/0.7.17-GCCcore-12.3.0
module load picard-uoneasy/3.0.0-Java-17

# Need to index genome, once only
bwa index /gpfs01/home/mbxlm9/LIFE4141_files/genome/genome/stickleback_v5_assembly.fa

# Load sample names into an array
mapfile -t ROOTS < /gpfs01/share/BioinfMSc/life4141/names.txt

# Get the current sample name based on SLURM_ARRAY_TASK_ID
SAMPLE=${ROOTS[$SLURM_ARRAY_TASK_ID]}

# Set file paths
# Fastp trimmed reads
FILE=/gpfs01/home/mbxlm9/L4141_updscrp/L4141_CW/trimmed/${SAMPLE}
FILE1=/gpfs01/home/mbxlm9/L4141_updscrp/L4141_CW/trimmed/${SAMPLE}_R1.trimmed.fq.gz
FILE2=/gpfs01/home/mbxlm9/L4141_updscrp/L4141_CW/trimmed/${SAMPLE}_R2.trimmed.fq.gz


# Reference genome
# Needs to be indexed
REF=/gpfs01/home/mbxlm9/LIFE4141_files/genome/stickleback_v5_assembly.fa
# Outfile 
mkdir -p bam
OUTFILE=bam/${SAMPLE}.sort.bam
# Align reads using combination of bwa mem and samtools
# Use help options to understand syntax
        echo "Aligning ${SAMPLE} with bwa"
        bwa mem -M -t 8 $REF $FILE1 \
        $FILE2 | samtools view -b | \
        samtools sort -T ${SAMPLE} > $OUTFILE
# Use picard to remove "duplicates" - a duplicate read is a sequence that is exactly the same in both the forward and reverse directions
# A duplicate read in Illumina (or other short-read sequencing) refers to a read that is an exact copy of another read in the dataset, typically originating from the same original DNA fragment. 
# These duplicates are usually PCR duplicates, created during the amplification step in library preparation rather than representing independent molecules from the sample.
# Duplicates inflate read counts, making coverage appear higher than it truly is.
# Multiple identical reads from the same fragment can make a variant look more supported than it is.

java -Xmx1g -jar $EBROOTPICARD/picard.jar \
MarkDuplicates REMOVE_DUPLICATES=true \
ASSUME_SORTED=true VALIDATION_STRINGENCY=SILENT \
MAX_FILE_HANDLES_FOR_READ_ENDS_MAP=1000 \
INPUT="$OUTFILE" \
OUTPUT=bam/${SAMPLE}.rmd.bam \
METRICS_FILE=bam/${SAMPLE}.rmd.bam.metrics 
samtools index bam/${SAMPLE}.rmd.bam
rm $OUTFILE