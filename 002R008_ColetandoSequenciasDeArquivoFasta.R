###############################################
## COLLECTING LISTED SEQUENCES FROM A FASTA FILE
## Author: Dennis Maletich Junqueira
## AI Disclosure: final refinements of the script were made using ChatGPT
## Date: 2026-04-20
##
## DESCRIPTION:
## This script extracts specific sequences from a FASTA file using one of two modes:
## (1) "csv"  = selects sequences whose names are listed in a CSV file
## (2) "term" = selects sequences whose names contain a given search term
##
## The output is a new FASTA file containing only the selected sequences.
##
## USAGE: R
###############################################

# Setting working directory
setwd("")

# Loading libraries
suppressPackageStartupMessages({
  library(seqinr)
})

###############################################
## SPECIFY THE FOLLOWING PARAMENTERS ##########
###############################################
# Choose the input FASTA file
fasta_file <- "Teste.fasta"

# Choose the running mode:
# "csv"  = selects sequences based on a table (CSV format)
# "term" = selects sequences based on a term inside sequence names
run_mode <- "csv"

# Choose the CSV file containing the sequence names (used only in csv mode)
csv_file <- "pegar.csv"

# Choose the keyword to search in sequence names (used only in term mode)
search_term <- "H1huN1p"

# Choose the output FASTA file
output_file <- "resultado_final.fasta"

###############################################
## RUNNING ####################################
###############################################
fasta <- read.fasta(file = fasta_file)
fasta_names <- names(fasta)

cat("\nTotal sequences in FASTA:", length(fasta_names), "\n")

if (run_mode == "csv") {
  
  cat("\n>>> Running MODE 01 (CSV)\n")
  
  # Load CSV file
  list_names <- read.csv(file = csv_file,
                         sep = ",",
                         header = FALSE,
                         stringsAsFactors = FALSE)
  
  # Remove extra spaces
  list_names$V1 <- trimws(list_names$V1)
  
  # Match sequence names
  matching <- fasta_names %in% list_names$V1
  
  # Debugging: names present only in FASTA
  cat("\nNames in FASTA but not in CSV:\n")
  print(setdiff(fasta_names, list_names$V1))
  
  # Debugging: names present only in CSV
  cat("\nNames in CSV but not in FASTA:\n")
  print(setdiff(list_names$V1, fasta_names))
  
  # Filter selected sequences
  chosen <- fasta[matching]
  
  cat("\nSelected sequences:", length(chosen), "\n")
  
  # Save output
  write.fasta(sequences = chosen,
              names = names(chosen),
              file.out = output_file)
  
  cat("\n✅ Finished! Output saved in:", output_file, "\n")
  
} else if (run_mode == "term") {
  
  cat("\n>>> Running MODE 02 (KEYWORD)\n")
  
  # Search for the term in sequence names
  matching <- grep(search_term, fasta_names)
  
  # Show matching names
  cat("\nMatching names:\n")
  print(fasta_names[matching])
  
  # Filter selected sequences
  chosen <- fasta[matching]
  
  cat("\nSelected sequences:", length(chosen), "\n")
  
  # Save output
  write.fasta(sequences = chosen,
              names = names(chosen),
              file.out = output_file)
  
  cat("\n✅ Finished! Output saved in:", output_file, "\n")
  
} else {
  stop("Invalid run_mode. Use 'csv' or 'term'.")
}