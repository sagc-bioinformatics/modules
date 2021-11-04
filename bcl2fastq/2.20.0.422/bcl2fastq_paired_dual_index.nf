process bcl2fastq_paired_dual_index {

    tag { "Bcl2Fastq paired dual index" }
    publishDir "${outdir}/${sampleProject}/fastq", mode: 'copy'
    // stageInMode 'copy'
    label 'process_medium'

    input:
    file sampleSheet
    val sampleProject
    val sampleProjectTF
    val outdir
    path path_bcl 

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
        --no-lane-splitting \
        --sample-sheet nf-SampleSheet.csv \
        --minimum-trimmed-read-length=8 \
        --ignore-missing-positions \
        --ignore-missing-controls \
        --ignore-missing-filter \
        --barcode-mismatches=1

    #rm -f Undetermined*.fastq.gz
    
    # Move FASTQ files from subdirectories into the top level
    if [[ ${sampleProjectTF} == 'true' ]]; then
        find . -mindepth 2 -type f -name '*.fastq.gz' -exec mv -t \$PWD {} +
    fi

    shopt -s nullglob

    # Rename FASTQ files
    for f in *R1_001.fastq.gz; do
        BN=\${f%_S*}

        mv \${f} \${BN}_R1.fastq.gz
        mv \${BN}*_R2_001.fastq.gz \${BN}_R2.fastq.gz
    done

    find . -maxdepth 1 -type f -name '*.fastq.gz' -exec md5sum {} + > fastq.md5
    """
}
