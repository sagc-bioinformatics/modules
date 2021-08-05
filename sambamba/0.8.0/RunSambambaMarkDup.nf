process markDupSambamba {
    tag { "Sambamba MarkDups - ${sample_id}" }
    publishDir "${params.outdir}/markDuplicates", mode: 'copy'
    label 'process_medium'

    input:
    tuple val(sample_id),
        file(bam),
        file(bai)

    output:
    path "${sample_id}.markdup.bam", emit: bam
    path "${sample_id}.markdup.bam.bai", emit: bai

    script:
    """
    sambamba markdup \
        --tmpdir=\${PWD} \
        -t ${task.cpus} \
        ${bam} ${sample_id}.markdup.bam
    """
}