process sabre {

    tag { "Sabre" }
    publishDir "${outdir}/sabre", mode: 'copy'
    label 'process_low'

    input:
    tuple val(sample_id), file(reads)
    val barcodes
    val outdir
    val opt_args

    output:
    file "${sample_id}_R1.fastq.gz", emit: R1
    file "${sample_id}_R2.fastq.gz", emit: R2
    file "*unmatched-barcodes*"

    script:
    def usr_args = opt_args ?: ''

    """
    sabre pe \
        -f ${reads[0]} \
        -r ${reads[1]} \
        -b ${barcodes} \
        -u unmatched-barcodes_1.fastq \
        -w unmatched-barcodes_2.fastq

    gzip *.fastq
    """
}