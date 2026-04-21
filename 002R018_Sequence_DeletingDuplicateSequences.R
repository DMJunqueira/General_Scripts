###############################################
## REMOVING DUPLICATE SEQUENCES FROM A FASTA FILE
## Author: Dennis Maletich Junqueira
## AI Disclosure: final refinements of the script were made using ChatGPT
## Date: 2026-04-21
##
## DESCRIPTION:
## This script identifies and removes duplicate sequences from a FASTA file.
##
## It generates an Excel report WITHOUT the full sequences, including:
## - sequence length
## - number of ambiguous bases (N)
## - number of gaps (-)
##
## Then it outputs a FASTA file with duplicates removed.
##
## USAGE: R
###############################################
# Setting working directory
setwd(dir = "")

# Loading libraries
suppressPackageStartupMessages({
  library(Biostrings)
  library(alakazam)
  library(openxlsx)
  library(dplyr)
})

###############################################
## SPECIFY THE FOLLOWING PARAMETERS ###########
###############################################
# Input FASTA file
input_fasta <- ""

# Excel output file with duplicate report
output_excel <- "Duplicates.xlsx"

# Output FASTA file after duplicate removal
output_fasta <- "DuplicatesRemoved.fasta"

###############################################
## RUNNING ####################################
###############################################
fastaFile <- readDNAStringSet(input_fasta)
df <- data.frame(
  seq_name = names(fastaFile),
  sequence = as.character(fastaFile),
  stringsAsFactors = FALSE
)

# Adding QC metrics
df <- df %>%
  mutate(
    Sequence_Length = nchar(sequence),
    N_Count = stringr::str_count(sequence, "N"),
    Gap_Count = stringr::str_count(sequence, "-")
  )

# Duplicate report
dup_report <- collapseDuplicates(
  df,
  id = "seq_name",
  seq = "sequence",
  text_fields = "seq_name",
  verbose = TRUE,
  sep = "|",
  add_count = TRUE,
  dry = TRUE
)

# Cleaning output table
dup_report_pretty <- dup_report %>%
  select(
    seq_name,
    Sequence_Length,
    N_Count,
    Gap_Count,
    collapse_count,
    collapse_id,
    collapse_class,
    collapse_pass
  ) %>%
  rename(
    Sequence_Name = seq_name,
    Duplicate_Count = collapse_count,
    Collapse_Group_ID = collapse_id,
    Duplicate_Class = collapse_class,
    Representative_Sequence = collapse_pass
  )

# Legend
legend_table <- data.frame(
  Field = c(
    "Sequence_Name",
    "Sequence_Length",
    "N_Count",
    "Gap_Count",
    "Duplicate_Count",
    "Collapse_Group_ID",
    "Duplicate_Class",
    "Representative_Sequence"
  ),
  Meaning = c(
    "Original sequence header.",
    "Length of the nucleotide sequence.",
    "Number of ambiguous bases (N).",
    "Number of gaps (-).",
    "Number of sequences in the duplicate group.",
    "Identifier of the duplicate cluster.",
    "Classification of the sequence.",
    "TRUE = kept; FALSE = removed."
  ),
  stringsAsFactors = FALSE
)

# Saving excel
wb <- createWorkbook()
addWorksheet(wb, "Duplicate_Report")
writeData(wb, "Duplicate_Report", dup_report_pretty)
addWorksheet(wb, "Legend")
writeData(wb, "Legend", legend_table)
saveWorkbook(wb, output_excel, overwrite = TRUE)

# Removing
data_collapsed <- collapseDuplicates(
  df,
  id = "seq_name",
  seq = "sequence",
  verbose = TRUE,
  sep = "|",
  add_count = TRUE
)

# Writing fasta
writeFasta <- function(data, filename){
  fastaLines = c()
 
  for (i in 1:nrow(data)){
    fastaLines = c(fastaLines, paste0(">", data$seq_name[i]))
    fastaLines = c(fastaLines, data$sequence[i])
  }
  
  writeLines(fastaLines, filename)
}

writeFasta(data_collapsed, output_fasta)

cat("\n✅ Finished!\n")
cat("Excel report:", output_excel, "\n")
cat("Filtered FASTA:", output_fasta, "\n")
cat("Final number of sequences:", nrow(data_collapsed), "\n")
