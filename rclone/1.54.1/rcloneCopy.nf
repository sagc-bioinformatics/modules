process rclone {

    tag { "rclone" } 
    publishDir "${outdir}", enabled: false
    label 'process_threads'

    input:
    file multiqc
    val outdir
    val sampleProject

    script:
    """
    rclone copy \
        --progress \
        --transfers ${task.cpus} \
        ${outdir}/${sampleProject} CloudStor:/Shared/SAGC/${sampleProject}
    """
}
