process bcl2fastq {

    tag { "Bcl2Fastq" }
    publishDir "${outdir}/fastq", mode: 'copy'
    stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val outdir
    val path_bcl 

    output:
    path "*_R1*.fastq.gz", emit: R1
    path "*_R3*.fastq.gz", emit: R2
    path "*_R2*.fastq.gz", emit: I1

    script:

    """
    bcl2fastq \
        --runfolder-dir ${path_bcl} \
        -p ${task.cpus} \
        --output-dir \$PWD \
        --use-bases-mask Y*,I8Y8,Y* \
        --mask-short-adapter-reads=8 \
        --create-fastq-for-index-reads \
        --no-lane-splitting \
        --sample-sheet ${sampleSheet} \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter

    rm Undetermined*.fastq.gz
    """
}
 