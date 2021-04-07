process bcl2fastq_paired_single_index {

    tag { "Bcl2Fastq paired single" }
    publishDir "${outdir}/fastq", mode: 'copy'
    stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val underscore
    val sampleProject
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
        --use-bases-mask Y*,I*,Y* \
        --no-lane-splitting \
        --sample-sheet ${sampleSheet} \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter

    rm Undetermined*.fastq.gz

    if [[ ${sampleProject} == 'true' ]]; then
        find . -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    if [[ ${underscore} == 'true' ]]; then
        for f in *R1_001.fastq.gz; do
            BN=\${f%_S*}
            BNCLEAN=\${BN//_/-}

            mv \${f} \${BNCLEAN}_R1.fastq.gz
            mv \${BN}*_R2_001.fastq.gz \${BNCLEAN}_R2.fastq.gz
        done
    else 
        for f in *R1_001.fastq.gz; do
            BN=\${f%_S*}

            mv \${f} \${BN}_R1.fastq.gz
            mv \${BN}*_R2_001.fastq.gz \${BN}_R2.fastq.gz
        done
    fi
    """
}
 