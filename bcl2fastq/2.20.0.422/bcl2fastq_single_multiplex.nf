process bcl2fastq_single_multiplex {

    tag { "Bcl2Fastq - single - multiplex" }
    publishDir "${outdir}/fastq", mode: 'copy'
    stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val outdir
    val path_bcl 

    output:
    path "*_R1*.fastq.gz", emit: R1
    path "*_R2*.fastq.gz", emit: R2

    script:
    """
    bcl2fastq \
        --runfolder-dir ${path_bcl} \
        -p ${task.cpus} \
        --output-dir \$PWD \
        --use-bases-mask ... \
        --mask-short-adapter-reads=8 \
        --no-lane-splitting \
        --sample-sheet ${sampleSheet} \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter \
        --barcode-mismatches=1

    rm -f Undetermined*.fastq.gz
    """
}
