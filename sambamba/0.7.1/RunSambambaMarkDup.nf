
// Mark Duplicates with sambamba
process RunSambambaMarkDup {
    tag { sample_id + " - MarkDuplicates" }

    publishDir "${params.outdir}/markDuplicates", mode: 'copy'
    stageInMode 'copy' // Link read files + star index. Save on I/O

    input:
    tuple sample_id,
        file(bam),
        file(bai)

    output:
    tuple sample_id,
        file(bam),
        file(bai)

    tuple sample_id,
        file("${sample_id}.markdup.bam"),
        file("${sample_id}.markdup.bam.bai")

    script:
    """
    sambamba markdup \
        --tmpdir=\${PWD} \
        -t ${task.cpus} \
        ${bam} ${sample_id}.markdup.bam
    """
}