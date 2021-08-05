process factera {

	tag { "factera - ${sample_id}" } 
    publishDir "${outdir}/Factera", mode: 'copy'
    label 'process_factera'

    input:
	path bam
	path exons
	path bitRef
    	 
    output:
    file "*"

    script:
    """
	perl factera.pl -o ./ ${bam} ${exons} ${bitRef}
    """
}