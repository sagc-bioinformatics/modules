process bcl2fastq_paired_single_index {

    tag { "Bcl2Fastq paired single index" }
    publishDir "${outdir}/${sampleProject}/fastq", mode: 'copy'
    // stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val sampleProject
    val sampleProjectTF
    val outdir
    val path_bcl 

    output:
    path "*_R1.fastq.gz", emit: R1
    path "*_R2.fastq.gz", emit: R2
    path "Stats", emit: bcl_stats
    path "Reports", emit: bcl_reports
    file "fastq.md5"

    script:
    """
    cleanSamplesheet.py ${sampleSheet}

    bcl2fastq \
        --runfolder-dir ${path_bcl} \
        -p ${task.cpus} \
        --output-dir \$PWD \
        --use-bases-mask Y*,I*,Y* \
        --no-lane-splitting \
        --sample-sheet nf-SampleSheet.csv \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter

    rm Undetermined*.fastq.gz

    if [[ ${sampleProjectTF} == 'true' ]]; then
        find . -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    for f in *R1_001.fastq.gz; do
        BN=\${f%_S*}

        mv \${f} \${BN}_R1.fastq.gz
        mv \${BN}*_R2_001.fastq.gz \${BN}_R2.fastq.gz
    done

    md5sum *fastq.gz > fastq.md5
    """
}
 