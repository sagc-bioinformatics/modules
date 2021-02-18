process R {
    tag {"R ${sample_id}"}
	publishDir "${outdir}/R", mode: 'copy'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple val(sample_id)
        file("${sample_id}.arriba.fusions.tsv")
    	val outdir
    	 
    output:
    tuple val(sample_id),
        file("${sample_id}.fusions.tsv"),
        file("${sample_id}.arriba.fusions.csv")

    script:
    """
    library(tidyverse)

    # variables
    file_path <- "${sample_id}.arriba.fusions.tsv"

    # read-in arriba file, calculate Junc + Span reads & select required cols
    arriba_data <- read.delim(file_path, header = TRUE, sep = "\t", 
                          colClasses = c("character","character","character","character",
                                         "character","character","character","character",
                                         "character","character","character","integer",
                                         "integer","integer","integer","integer",
                                         "character","character","character","character",
                                         "character","character","character","character")) %>% 
      # select required columns
      dplyr::select(X.gene1,gene2,strand1.gene.fusion.,strand2.gene.fusion.,
                    breakpoint1,breakpoint2,split_reads1,split_reads2,
                    discordant_mates,confidence,reading_frame) %>% 
      # generate columns for Junc_reads, Span_reads and TTL_reads
      mutate(Junc_reads = (split_reads1+split_reads2), 
             Span_reads = discordant_mates,
             TTL_reads = (Junc_reads+Span_reads)) %>% 
      # remove now unnecessary columns
      dplyr::select(-split_reads1,-split_reads2,-discordant_mates) %>% 
      # rename X.gene1
      dplyr::rename(gene1 = X.gene1)

    ## Edit gene names to ensure same gene name used consistently across callers
    arriba_data$gene1 <- gsub("MLLT4","AFDN", arriba_data$gene1)
    arriba_data$gene2 <- gsub("MLLT4","AFDN", arriba_data$gene2)
    arriba_data$gene1 <- gsub("CRLF2[(].+[)],CSF2RA[(].+[)]","CRLF2",arriba_data$gene1)
    arriba_data$gene2 <- gsub("CRLF2[(].+[)],CSF2RA[(].+[)]","CRLF2",arriba_data$gene2)

    arriba_data$gene1 <- gsub("IGHV.+","IGH@", arriba_data$gene1)
    arriba_data$gene1 <- gsub("IGHJ.+","IGH@", arriba_data$gene1)
    arriba_data$gene1 <- gsub("IGHD","IGH@", arriba_data$gene1)
    arriba_data$gene1 <- gsub("IGHM","IGH@", arriba_data$gene1)
    arriba_data$gene1 <- gsub("IGH@.+","IGH@", arriba_data$gene1)
    arriba_data$gene1 <- gsub(".+IGH@","IGH@",arriba_data$gene1)
    arriba_data$gene1 <- gsub("DUX4.+","DUX4",arriba_data$gene1)

    arriba_data$gene2 <- gsub("IGHV.+","IGH@", arriba_data$gene2)
    arriba_data$gene2 <- gsub("IGHJ.+","IGH@", arriba_data$gene2)
    arriba_data$gene2 <- gsub("IGHD","IGH@", arriba_data$gene2)
    arriba_data$gene2 <- gsub("IGHM","IGH@", arriba_data$gene2)
    arriba_data$gene2 <- gsub("IGH@.+","IGH@", arriba_data$gene2)
    arriba_data$gene2 <- gsub(".+IGH@","IGH@",arriba_data$gene2)
    arriba_data$gene2 <- gsub("DUX4.+","DUX4",arriba_data$gene2)

    # generate the break-point information and fusion.genes column
    arriba_data <- arriba_data %>% 
      # extract strand after fusion for gene1
      separate(strand1.gene.fusion., c(NA,"strand1"), sep = "[/]") %>% 
      # extract strand after fusion for gene2
      separate(strand2.gene.fusion., c(NA,"strand2"), sep = "[/]") %>% 
      # create the breakpoint sequence
      mutate(break.point = paste("chr",breakpoint1,":",strand1,":chr",breakpoint2,":",strand2, sep="")) %>% 
      mutate(fusion.genes = paste(gene1,gene2,sep=":")) %>% 
      # select columns in desired order (if want to include reading_frame first need to convert from factor to character)
      dplyr::select(fusion.genes,break.point,TTL_reads,Span_reads,Junc_reads,confidence)

    ##### May wish to output format at this point before filtering fusions for those involving key genes #####

    genes_of_interest <- c("BCR","ABL1","KMT2A","ETV6","RUNX1","IGH@","DUX4","MLLT10",
                       "PICALM","CRLF2","P2RY8","STIL","TAL1","PAX5","JAK2","TCF3",
                       "PBX1","IKZF1","NOTCH1","AUTS2","HLF","NUP214","JARID2","SET",
                       "ZNF384","COBL","HOOK3","FGFR1","BCL2","CTCF","NUTF2",
                       "TLX1","DDX3X","AFDN","CEBPB","APC","EBF1","PDGFRB",
                       "HOXA9","TRBC2","MLLT1","CSF1R","SSBP2","NDRG1","EP300","EPOR",
                       "ZNF521","SRCIN1","ARHGAP22","ATF7IP","TAF15","CBFA2T3",
                       "FLT3","PAN3","CEBPE","CEBPA","GSDMA","FGFR2","FGFR4","FGFR3",
                       "ID4","BCL6","NUTM1","MYC","SMARCA2","CREBBP","NTRK3",
                       "ABL2","KLF6","STRAP","MEF2D","BCL9","ARID1B","ARID5B","BCL2")


    ## Filter output to extract most likely break-point in cases where same fusion reported multiple times
    filt_arriba_data <- arriba_data %>% 
      split(f = .$fusion.genes) %>% 
          lapply(function(x){x[which.max(x$TTL_reads),]}) %>% 
          bind_rows() %>% 
      # to reduce the amount of output I am also going to filter for fusions of interest
      filter(grepl(paste(genes_of_interest,collapse="|"), fusion.genes))

    # write filtered output to csv file
    output_file <- gsub(".fusions.tsv",".arriba.fusions.csv", file_path)
    write.csv(filt_arriba_data, file = output_file, row.names = FALSE)
    """
}

