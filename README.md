

![](/LaBEVirLogo.png)



# This is a repository for LaBEVir R scripts:





### 002R008_Sequence_ColetandoSequenciasArquivoFasta
This script extracts specific sequences from a FASTA file using one of two modes: based on csv file (1) or on a search-term (2).

### 002R013_Sequence_CountingNucleotidesGapsAmbiguities
This script identifies the number of the IUPAC nucleotide and ambiguities for each given sequence in a fasta file. Additionally, it counts the number of "-".

### 002R021_Sequence_ExcluindoSequenciasArquivoFasta
This script removes sequences from a FASTA file using two possible approaches: based on csv file (1) or by duplicated sequence headers.

### 002R037_Sequence_RenamingSequencesFasta
This script renames sequences in a FASTA file based on a provided mapping table in a CSV format.

### 002R068_Metadata_IdentifyingGeoRegions
This script adds a new column with geographic classification to a metadata table based on country names.

### 002R094_Metadata_ConvertingDates
This script converts dates from DD/MM/YYYY format into YYYY/MM/DD format (1) or continuous year format (e.g., 2009.345)

### 002R106_Metadata_GeoCodificacaoCoordenadas
This script geocodes locations from a metadata table and adds latitude and longitude coordinates based on location information.

### 002R108_Sequence_GeneIdentificationUsingReferenceGenome: 
This script aligns user-provided sequences to a reference genome of moderate length, 
identifies the corresponding gene for each sequence, and adds this information to a metadata file. It also generates specific sub-alignments 
for each gene found (output: *_alignments.fasta). Additionally, it can eliminate sequences shorter than a specified lenght.

### 002R109_Sequence_GenbankSequenceMetadataRetrieval:
This script programmatically searches the NCBI Nucleotide database for sequences based on a user-provided term. It retrieves full sequence 
data and key metadata (e.g., accession, organism, country, and host) and saves the results into a FASTA file and a CSV file.

### 002R110_Sequence_NCBIVirusSequenceMetadataRetrieval:
Fetch NCBI Virus sequences using flexible queries. Supports taxid, virus name, serotype, host, country, collection dates, molecule type, etc.

### 002R117_Sequence_DownloadingReferenceSequenceWithGenomeMap
This script search for a refseq in NCBI, downloads it's fasta and generates a .csv containing the sequence genome map
