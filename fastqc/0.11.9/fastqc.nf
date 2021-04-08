process fastqc {

    tag { "FastQC - ${sample_id}" } 
    publishDir "${outdir}/QC-results/fastqc", mode: 'copy'
    label 'process_low'

    input:
    tuple val(sample_id), file(reads)
    val outdir
    val opt_args

    output:
    tuple val(sample_id), path("*.{zip,html}"), emit: fastqc_output

    script:
    def usr_args = opt_args ?: ''

    """
    fastqc ${usr_args} -t ${task.cpus} -q ${reads[0]}
    """
}
