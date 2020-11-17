
// Align reads

process StarAlign {
    tag { sample_id + " - STAR align" }

    memory '50 GB'

    publishDir "${params.outdir}/STAR", mode: 'copy'
    stageInMode 'copy' // Link read files + star index. Save on I/O
    // conda "$projectDir/conda.yml"

    input:
    path star_idx_dir
    tuple sample_id, file(reads)

    output:
    tuple sample_id,
        file("${sample_id}.Aligned.sortedByCoord.out.bam"),
        file("${sample_id}.Aligned.sortedByCoord.out.bam.bai")

    script:
    """
    STAR \
    --genomeDir ${star_idx_dir} \
    --readFilesIn ${reads} \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outSAMattributes NH HI NM MD AS \
    --outFileNamePrefix ${sample_id}"." \
    --outSAMattrRGline ID:${sample_id} LB:Lib1 PL:illumina PU:machine SM:${sample_id}_hg38 \
    --chimOutType WithinBAM \
    --chimSegmentMin 20 \
    --twopassMode Basic \
    --outReadsUnmapped Fastx

    samtools index -@ ${task.cpus} ${sample_id}.Aligned.sortedByCoord.out.bam
    """
}