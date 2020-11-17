
process Fastqc {
    tag "${sample_id} - FastQC"
    publishDir "${params.outdir}/fastqc_${sample_id}", mode: 'copy'
    // conda "$projectDir/conda.yml"

    input:
    tuple sample_id, file(reads), file(I1)

    output:
    file "*.{zip,html}"

    script:
    """
    fastqc -k 9 -t ${task.cpus} -q ${reads}
    """
}
