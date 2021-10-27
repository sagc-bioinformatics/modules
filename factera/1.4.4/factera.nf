process factera {

	tag { "factera - ${sample_id}" } 
    publishDir "${outdir}/Factera", mode: 'copy'
    label 'process_factera'

    input:
    path factera
	path bam
	path exons
	path bitRef
    	 
    output:
    file "*"

    script:
    """
	perl ${factera} -o ./ ${bam} ${exons} ${bitRef}
    """
}