
// Map using BWA MEM producing a sorted bam
process Hisat2MapSortedBam {
    tag { sample_id + " - Hisat2 align" }

    memory '4 GB'

    publishDir "${params.outdir}/Hisat2", mode: 'copy'
    stageInMode 'copy' // Link read files + hisat2 index. Save on I/O
    // conda "$projectDir/conda.yml"

    input:
    file hisat2_idx
    tuple sample_id, file(reads)

    output:
    tuple sample_id,
        file("${sample_id}.hisat2.bam"),
        file("${sample_id}.hisat2.bam.bai")

    script:
    """
    # bwa alignment
    hisat2 -p ${task.cpus} \
         --rg-id "\"@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:LIB1\"" \
         -x ${bwa_idx} -1 ${reads[0]} -2 ${reads[1]} | \
            samtools sort --threads ${task.cpus} -m 2G - > ${sample_id}.hisat2.bam
    
    # index with sambamba
    sambamba index -t ${task.cpus} ${sample_id}.hisat2.bam
    """
}