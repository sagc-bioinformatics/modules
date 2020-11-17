
// Map using BWA MEM producing a sorted bam
process BwaMapSortedBam {
    tag { sample_id + " - BWA align" }

    memory '4 GB'

    publishDir "${params.outdir}/BWA", mode: 'copy'
    stageInMode 'copy' // Link read files + star index. Save on I/O
    // conda "$projectDir/conda.yml"

    input:
    file bwa_idx
    tuple sample_id, file(reads)

    output:
    tuple sample_id,
        file("${sample_id}.bwamem.bam"),
        file("${sample_id}.bwamem.bam.bai")

    script:
    """
    # bwa alignment
    bwa mem -t ${task.cpus} \
        -R "\"@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:LIB1\"" \
        ${bwa_idx} ${reads} | \
            samtools sort --threads ${task.cpus} -m 2G - > ${sample_id}.bwamem.bam
    
    # index with sambamba
    sambamba index -t ${task.cpus} ${sample_id}.bwamem.bam
    """
}