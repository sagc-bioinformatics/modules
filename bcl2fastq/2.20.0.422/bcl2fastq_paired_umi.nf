process bcl2fastq_paired_umi {

    tag { "Bcl2Fastq paired umi" }
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

    if [[ ${sampleProject} == 'true' ]]; then
        find . -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    if [[ ${underscore} == 'true' ]]; then
        for f in *R1_001.fastq.gz; do
            BN=\${f%_S*}
            BNCLEAN=\${BN//_/-}

            mv \${f} \${BNCLEAN}_R1.fastq.gz
            mv \${BN}*_R2_001.fastq.gz \${BNCLEAN}_R2.fastq.gz
            mv \${BN}*_R3_001.fastq.gz \${BNCLEAN}_R3.fastq.gz
        done
    else
        for f in *R1_001.fastq.gz; do
            BN=\${f%_S*}

            mv \${f} \${BNCLEAN}_R1.fastq.gz
            mv \${BN}*_R2_001.fastq.gz \${BN}_R2.fastq.gz
            mv \${BN}*_R3_001.fastq.gz \${BN}_R3.fastq.gz
        done
    fi
    """
}
