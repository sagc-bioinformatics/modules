process multiqc {

    tag { "MultiQC" } 
    publishDir "${outdir}/QC-results", mode: 'copy'
    label 'process_low'

    input:
    file fastqc_in
    file bcl_stats
    file bbduck_stats
    file kraken2_stats
    val outdir
    // val opt_args 

    output:
    path "multiqc_report.html", emit: multiqc_report
    path "multiqc_data.zip", emit: multiqc_data

    script:
    // def stats = opt_args ?: ''

    """
    if [[ ${bcl_stats} != 'false' ]]; then
        cp Stats/Stats.json .
    fi
    
    multiqc \
        --config ${projectDir}/conf/multiqc_config.yaml \
        .
    """
}
