###############################################
## REMOVING DUPLICATE SEQUENCES FROM A FASTA FILE
## Author: Dennis Maletich Junqueira
## AI Disclosure: final refinements of the script were made using ChatGPT
## Date: 2026-04-21
##
## DESCRIPTION:
## This script identifies and removes duplicate sequences from a FASTA file.
##
## First, it generates an Excel table summarizing sequence redundancy and
## duplicate classification. Then, it removes duplicate sequences and saves
## a filtered FASTA file.
##
## The Excel output includes a second sheet with a legend explaining the
## meaning of each output column and duplicate class.
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

seq_name <- names(fastaFile)
sequence <- paste(fastaFile)

df <- data.frame(
  seq_name = seq_name,
  sequence = sequence,
  stringsAsFactors = FALSE
)

# Remove exact duplicate sequence names before analysis
df <- df[!duplicated(df$seq_name), ]

# Generate duplicate summary table without collapsing sequences yet
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

# Improving output table
dup_report_pretty <- dup_report %>%
  rename(
    Sequence_Name = seq_name,
    Sequence = sequence,
    Duplicate_Count = collapse_count,
    Collapse_Group_ID = collapse_id,
    Duplicate_Class = collapse_class,
    Representative_Sequence = collapse_pass
  )

# Creating legend table
legend_table <- data.frame(
  Field = c(
    "Sequence_Name",
    "Sequence",
    "Duplicate_Count",
    "Collapse_Group_ID",
    "Duplicate_Class",
    "Representative_Sequence"
  ),
  Meaning = c(
    "Original sequence header from the FASTA file.",
    "Nucleotide sequence associated with the header.",
    "Number of sequences grouped together in the same duplicate cluster.",
    "Identifier of the duplicate cluster created by collapseDuplicates(). Sequences sharing the same ID belong to the same redundancy group.",
    "Classification assigned by collapseDuplicates() describing the relationship among redundant sequences.",
    "TRUE = sequence kept as the representative of the group; FALSE = sequence excluded during duplicate collapsing."
  ),
  stringsAsFactors = FALSE
)

class_table <- data.frame(
  Duplicate_Class = c(
    "UNIQUE",
    "DUPLICATE",
    "AMBIGUOUS",
    "AMBIGUOUS_DUPLICATE"
  ),
  Meaning = c(
    "Sequence is unique and does not collapse with any other sequence.",
    "Sequence is duplicated and is not kept as the representative sequence.",
    "Sequence is equally compatible with more than one group, often because it is shorter or less informative.",
    "Sequence is ambiguous and also duplicated relative to another equally ambiguous sequence."
  ),
  stringsAsFactors = FALSE
)

# Saving duplicate report to excel
wb <- createWorkbook()
addWorksheet(wb, "Duplicate_Report")
writeData(wb, sheet = "Duplicate_Report", x = dup_report_pretty)
addWorksheet(wb, "Legend")
writeData(wb, sheet = "Legend", x = legend_table, startRow = 1)
writeData(wb, sheet = "Legend", x = class_table, startRow = nrow(legend_table) + 4)
saveWorkbook(wb, file = output_excel, overwrite = TRUE)


# IF YOU ONLY WANT TO IDENTIFY THE DUPLICATES THE SCRIPT FINISHES HERE
# IF YOU WANT TO EXCLUDE DUPLICATED SEQUENCES FROM A FASTA THE FILE THE SCRIPT CONTINUES BELOW




# Removing duplicate sequences
data_collapsed <- collapseDuplicates(
  df,
  id = "seq_name",
  seq = "sequence",
  verbose = TRUE,
  sep = "|",
  add_count = TRUE
)

# WRITING FASTA
writeFasta <- function(data, filename) {
  fastaLines <- c()
  
  for (rowNum in 1:nrow(data)) {
    fastaLines <- c(fastaLines, paste0(">", data[rowNum, "seq_name"]))
    fastaLines <- c(fastaLines, data[rowNum, "sequence"])
  }
  
  writeLines(fastaLines, con = filename)
}

writeFasta(data_collapsed, output_fasta)

cat("\n✅ Finished!\n")
cat("Excel report saved in:", output_excel, "\n")
cat("Filtered FASTA saved in:", output_fasta, "\n")
cat("Number of sequences after duplicate removal:", nrow(data_collapsed), "\n")
