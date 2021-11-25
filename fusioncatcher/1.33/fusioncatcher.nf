process fusioncatcher_v133 {

    tag { "fusioncatcher_v133 - ${filename}" } 
    publishDir "${outdir}/${group}/${filename}/fusioncatcher_v133", mode: 'copy'
    label 'process_fusioncatcher_v133'

    input:
    tuple val(filename), val(group), val(sample), val(path), file(reads)
    val fusioncatcher_db
	val outdir
     
    output:
    file "${filename}_fusioncatcher_v133.txt"

    script:
    """
	fusioncatcher \
        -p ${task.cpus} \
        -d ${fusioncatcher_db} \
        -i ${reads[0]},${reads[1]} \
        -o \${PWD} \
        --skip-blat
			
	mv final-list_candidate-fusion-genes.txt ${filename}_fusioncatcher_v133.txt
    """
}