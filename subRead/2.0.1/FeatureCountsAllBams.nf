process featureCounts {

    tag { "FeatureCounts" }
    publishDir "${outdir}/featureCounts", mode: 'copy'
    label 'process_low'

    input:
    file gtf
    file bams
    file bais
    val outdir
    val opt_args

    output:
    file "*"

    script:
    def usr_args = opt_args ?: ''

    """
    featureCounts \
        ${usr_args} \
        -T ${task.cpus} \
        -a ${gtf} \
        -o counts.txt \
        ${bams}
    """
}