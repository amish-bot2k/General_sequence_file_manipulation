import argparse
from Bio import SeqIO

def extract_sequences(fasta_file, headers):
    # Open the FASTA file
    with open(fasta_file, "r") as file:
        for record in SeqIO.parse(file, "fasta"):
            if record.id in headers:
                print(f">{record.id}")
                print(record.seq)

def read_headers_from_file(headers_file):
    with open(headers_file, "r") as file:
        # Read all lines and strip newline characters
        return [line.strip() for line in file.readlines()]

def main():
    # Set up argument parser
    parser = argparse.ArgumentParser(description="Extract sequences from a FASTA file based on headers.")
    parser.add_argument("fasta_file", help="The input FASTA file.")
    parser.add_argument("headers", help="The sequence header(s) to extract. Can be a single header or a file containing a list of headers.", nargs='*')
    parser.add_argument("--headers_file", help="File containing a list of headers to extract (optional).")

    args = parser.parse_args()

    # If headers_file is provided, read the headers from the file
    if args.headers_file:
        headers = read_headers_from_file(args.headers_file)
    else:
        # Otherwise, use the headers provided directly
        headers = args.headers

    # Extract and print sequences for the provided headers
    extract_sequences(args.fasta_file, headers)

if __name__ == "__main__":
    main()
