
// Gene expression data
process FeatureCountsAllBams {
    tag { sample_id + ' - FeatureCounts' }

    publishDir "${params.outdir}/featureCounts", mode: 'copy'
    // conda "$projectDir/conda.yml"

    input:
    file GTF
    tuple sample_id, 
        file(bam),
        file(bai)

    output:
    file "${sample_id}.*"

    script:
    """
    featureCounts \
        -T ${task.cpus} \
        -a ${GTF} \
        -o ${sample_id}.counts.txt \
        ${bam}
    """
}