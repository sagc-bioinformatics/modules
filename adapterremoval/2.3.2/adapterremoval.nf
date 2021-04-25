// Trimming with adapterremoval
process ADAPTERREMOVAL {
    tag { sample_id + " - AdapterRemoval" }

    memory '4 GB'

    publishDir "${params.outdir}/adapterremoval", mode: 'copy'
    stageInMode 'copy' 
    // conda "$projectDir/conda.yml"

    input:
    tuple sample_id, file(reads)

    output:
    tuple sample_id,
        file("${sample_id}_T1.fastq.gz "),
        file("${sample_id}_T2.fastq.gz ")

    script:
    """
    AdapterRemoval  \\
            --file1 ${reads[0]} \\
            --file2 ${reads[0]} \\
            --basename $sample_id \\
            --threads $task.cpus \\
            --settings ${sample_id}.log \\
            --output1 ${sample_id}_T1.fastq.gz \\
            --output2 ${sample_id}_T2.fastq.gz \\
            --seed 42 \\
            --gzip
    """
}