process STAR_Fusion {
    tag {"STAR_Fusion_${sample_id}"}
	publishDir "${outdir}/STAR_Fusion", mode: 'copy'
	shell = ['/bin/bash', '-euo', 'pipefail']
	label 'process_medium'

    input:
        tuple val(sample_id), file(read1), file(read2)
		path genome_lib
     
    output:
    tuple val(sample_id), val(outdir)
        file("${sample_id}_star-fusion.tsv"),
        file("${sample_id}_star-fusion.abridged.tsv")

    script:
    """
	STAR-Fusion \
	    --genome_lib_dir ${genome_lib} \
        --left_fq ${read1} \
        --right_fq ${read2} \
    	--FusionInspector inspect \
    	--examine_coding_effect \
        --denovo_reconstruct \
        --output_dir ${outdir}
			
	mv star-fusion.fusion_predictions.tsv ${sample_id}_star-fusion.tsv
    mv star-fusion.fusion_predictions.abridged.tsv ${sample_id}_star-fusion.abridged.tsv
    """
}

