process bcl2fastq_single {

    tag { "Bcl2Fastq single end" }
    publishDir "${outdir}/fastq", mode: 'copy'
    // stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    // val underscore
    val sampleProject
    val outdir
    val path_bcl 

    output:
    path "*_R1.fastq.gz", emit: R1
    path "Stats", emit: bcl_stats
    path "Reports", emit: bcl_reports

    script:
    """
    cleanSamplesheet.py ${sampleSheet}

    bcl2fastq \
        --runfolder-dir ${path_bcl} \
        -p ${task.cpus} \
        --output-dir \$PWD \
        --use-bases-mask Y*,I8N* \
        --no-lane-splitting \
        --sample-sheet nf-SampleSheet.csv \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter

    rm Undetermined*.fastq.gz

    if [[ ${sampleProject} == 'true' ]]; then
        find . -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    for f in *R1_001.fastq.gz; do
        BN=\${f%_S*}
        mv \${f} \${BN}_R1.fastq.gz
    done
    """
}
