process kraken2 {

    tag { "Kraken2 - ${sample_id}" } 
    publishDir "${outdir}/QC-results/kraken2", mode: 'copy'
    label 'process_medium'

    input:
    tuple val(sample_id), file(reads)
    val outdir

    output:
    path "${sample_id}.kraken2", emit: stats

    script:
    """
    kraken2 \
        --db /data/bioinformatics/bcbio_genomes/others/kraken2_standard_20200919\
        --quick \
        --threads ${task.cpus} \
        --gzip-compressed \
        --memory-mapping \
        --report ${sample_id}.kraken2 \
        ${reads}
    """
}