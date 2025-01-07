#!/bin/bash

# Check if correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <fasta_file> <number_of_splits>"
    exit 1
fi

# Get the FASTA file path and number of files to split into from command-line arguments
fasta_file=$1
n=$2

# Output directory for split files
split_dir="/home/meg_amk/Histone_analysis/split_files"
mkdir -p "$split_dir"

# Count the number of sequences in the FASTA file
sequence_count=$(grep -c "^>" "$fasta_file")

# Calculate the number of sequences per file
sequences_per_file=$(( (sequence_count + n - 1) / n ))

# Use awk to split the FASTA file
awk -v sequences_per_file="$sequences_per_file" -v output_dir="$split_dir" -v fasta_file="$fasta_file" '
    BEGIN {
        file_index = 1
        sequence_count = 0
        output_file = sprintf("%s/split_%d.fasta", output_dir, file_index)
    }
    /^>/ {
        if (sequence_count >= sequences_per_file) {
            # Move to the next file
            file_index++
            output_file = sprintf("%s/split_%d.fasta", output_dir, file_index)
            sequence_count = 0
        }
        sequence_count++
    }
    { print > output_file }
' "$fasta_file"

echo "FASTA file has been split into $n files in the directory '$split_dir'."
