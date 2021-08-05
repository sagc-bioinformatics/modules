process starFusion {

    tag { "STAR_Fusion - ${sample_id}" } 
    publishDir "${outdir}/${sampleProject}/STAR_fusion", mode: 'copy'
    label 'process_starfusion'

    input:
    tuple val(sample_id), file(reads)
	path genome_lib
     
    output:
    tuple val(sample_id), val(outdir)
    file("${sample_id}_star-fusion.tsv"),
    file("${sample_id}_star-fusion.abridged.tsv")

    script:
    """
	STAR-Fusion \
	    --genome_lib_dir ${genome_lib} \
        --left_fq ${reads[0]} \
        --right_fq ${reads[1]} \
        --CPU ${task.cpus} \
    	--FusionInspector inspect \
    	--examine_coding_effect \
        --denovo_reconstruct \
        --output_dir ${outdir}
			
	mv star-fusion.fusion_predictions.tsv ${sample_id}_star-fusion.tsv
    mv star-fusion.fusion_predictions.abridged.tsv ${sample_id}_star-fusion.abridged.tsv
    """
}

