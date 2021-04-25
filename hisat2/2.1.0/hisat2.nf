
// Map using hisat2 producing a sorted bam
process HISAT2 {
    tag { sample_id + " - Hisat2 align" }

    memory '20 GB'

    publishDir "${params.outdir}/Hisat2", mode: 'copy'
    stageInMode 'copy' // Link read files + hisat2 index. Save on I/O
    // conda "$projectDir/conda.yml"

    input:
    path hisat2_idx_dir
    tuple sample_id, file(read1), file(read2)

    output:
    tuple sample_id,
        file("${sample_id}.hisat2.bam"),
        file("${sample_id}.hisat2.bam.bai")

    script:
    """
    INDEX=`find -L ${hisat2_idx_dir} -name "*.1.ht2" | sed 's/.1.ht2//'`

    # hisat2 alignment
    hisat2 -p ${task.cpus} \\
         --rg-id "\"@RG\\tID:${sample_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:LIB1\"" \\
         -x \${INDEX} -1 ${read1} -2 ${read2} | \\
            samtools sort --threads ${task.cpus} -m 2G - > ${sample_id}.hisat2.bam
    
    # index with sambamba
    samtools index -@ ${task.cpus} ${sample_id}.hisat2.bam
    """
}