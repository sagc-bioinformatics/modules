// Calling variants
process RunGatkHC {
    tag { sample_id + " - GATK" }

    publishDir "${params.outdir}/GATK", mode: 'copy'
    stageInMode 'copy' // Link read files + star index. Save on I/O


    input:
    file ref
    file idx
    file dict
    tuple sample_id,
        file(bam),
        file(bai)

    output:
    tuple sample_id,
        file("${sample_id}.raw.vcf.gz"),
        file("${sample_id}.raw.vcf.gz.tbi")

    script:
    """
    gatk HaplotypeCaller \
        -R ${ref} \
        -I ${bam} \
        -O ${sample_id}.raw.vcf.gz \
        --native-pair-hmm-threads ${task.cpus} \
        --dont-use-soft-clipped-bases true \
        -stand-call-conf 20 \
        --tmp-dir \${PWD}
    """
}