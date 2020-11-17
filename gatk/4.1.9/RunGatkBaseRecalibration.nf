// Recalibrate base scores
process RunGatkBaseRecalibration {
    tag { sample_id + " - BaseRecalibration" }

    publishDir "${params.outdir}/BaseRecal", mode: 'copy'
    stageInMode 'copy' // Link read files + star index. Save on I/O

    input:
    file ref
    file idx
    file dict
    file dbSNP
    file dbIdx
    tuple sample_id,
        file(bam),
        file(bai)

    output:
    tuple sample_id,
        file("${sample_id}.recal.bam"),
        file("${sample_id}.recal.bam.bai")

    script:
    """
    gatk BaseRecalibrator \
        -R ${ref} \
        -I ${bam} \
        -known-sites ${dbSNP} \
        -O ${sample_id}_recal.table

    gatk ApplyBQSR \
        -R ${ref} \
        -I ${bam} \
        -bqsr-recal-file ${sample_id}_recal.table \
        -O ${sample_id}.recal.bam
    """
}