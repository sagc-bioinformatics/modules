process bbduk {

    tag { "BBDuk - ${sample_id}" } 
    publishDir "${outdir}/${sampleProject}/QC-results/bbduk", mode: 'copy'
    label 'process_low'

    input:
    tuple val(sample_id), file(reads)
    val library_type
    val outdir
    val sampleProject

    output:
    path "${sample_id}.stats", emit: stats

    script:
    if (library_type == 'paired') {
        """
        bbduk.sh \
            in1=${reads[0]} \
            in2=${reads[1]} \
	    	out1=${sample_id}_clean_1.gz \
            out2=${sample_id}_clean_2.gz \
	    	ref=/data/bioinformatics/bcbio_genomes/others/rRNA_contamination/rRNA-db-contam.fasta.gz k=31 mm=f \
	    	stats=${sample_id}.stats

        rm *clean*.gz
        """
    } else if (library_type == 'single') {
        """
        bbduk.sh \
            in1=${reads[0]} \
	    	out1=${sample_id}_clean.gz \
	    	ref=/data/bioinformatics/bcbio_genomes/others/rRNA_contamination/rRNA-db-contam.fasta.gz \
            k=31 \
            mm=f \
	    	stats=${sample_id}.stats
        
        rm *clean.gz
        """
    } 
}