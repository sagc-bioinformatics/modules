
// Marking duplicates: BAM
process UmiDedup {
    tag { sample_id + " - UmiToolsDedup" }

    publishDir "${params.outdir}/umi-dedup", mode: 'copy'
    // conda "$projectDir/conda.yml"

    input:
    tuple sample_id,
        file(bam),
        file(bai)

    output:
    tuple sample_id, 
        file("${sample_id}.umidup.bam"),
        file("${sample_id}.umidup.bam.bai")
    file "*.{log,err,tsv}"

    script:
    """
    umi_tools dedup \
    -I ${bam} \
    -L ${sample_id}.log \
    -E ${sample_id}.err \
    -S ${sample_id}.umidup.bam \
    --umi-separator=":" \
    --temp-dir=\${PWD} \
    --paired \
    --output-stats=${sample_id}

    samtools index ${sample_id}.umidup.bam
    """
}