process starAlign {
    tag { "STAR align - ${sample_id}"  }
    publishDir "${outdir}/STAR", mode: 'copy'
    // stageInMode 'copy' // Link read files + star index. Save on I/O
    label 'process_high'

    input:
    tuple val(sample_id), file(reads)
    path star_idx
    val outdir
    val opt_args

    output:
    tuple val(sample_id),
        file("${sample_id}.Aligned.sortedByCoord.out.bam"),
        file("${sample_id}.Aligned.sortedByCoord.out.bam.bai")

    script:
    def usr_args = opt_args ?: ''

    """
    STAR \
    ${usr_args} \
    --genomeDir ${star_idx} \
    --readFilesIn ${reads} \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMattributes NH HI NM MD AS \
    --outFileNamePrefix ${sample_id}"." \
    --outSAMattrRGline ID:${sample_id} LB:Lib1 PL:illumina PU:machine SM:${sample_id}_SM \
    --chimOutType WithinBAM \
    --chimSegmentMin 20 \
    --twopassMode Basic \
    --outReadsUnmapped Fastx

    samtools index -@ ${task.cpus} ${sample_id}.Aligned.sortedByCoord.out.bam
    """
}