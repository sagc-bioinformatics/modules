process umiDedup {
    
    tag { "UmiToolsDedup - ${sample_id}" }
    publishDir "${params.outdir}/umi_dedup", mode: 'copy'
    label 'process_medium'

    input:
    tuple val(sample_id),
        file(bam),
        file(bai)
    val outdir
    val opt_args

    output:
    path "${sample_id}.umidup.bam", emit: bam
    path "${sample_id}.umidup.bam.bai", emit: bai
    file "*.{log,err,tsv}"

    script:
    def usr_args = opt_args ?: ''

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