
process fusioncatcher {

    tag { "fusioncatcher - ${sample_id}" } 
    publishDir "${outdir}/${sampleProject}/fusioncatcher", mode: 'copy'
    label 'process_fusioncatcher'

    input:
    tuple val(sample_id), file(reads)
	path genome_lib
     
    output:
    tuple val(sample_id), val(outdir)
    file("${sample_id}_fusioncatcher.txt")

    script:
    """
	fusioncatcher \\
        -d ${data_dir} \\
        --threads ${task.cpus} \\
        --i "${reads[0]},${reads[1]}" \\
        -o ${outdir} \\
        --skip-blat 
			
	mv final-list_candidate-fusion-genes.txt ${sample_id}_fusioncatcher.txt
    """
}

