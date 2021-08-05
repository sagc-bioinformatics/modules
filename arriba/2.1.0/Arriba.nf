process arriba {

	tag { "Arriba - ${sample_id}" } 
    publishDir "${outdir}/${sampleProject}/Arriba", mode: 'copy'
    label 'process_arriba'

    input:
	tuple val(sample_id), file(reads)
	path star_idx
	path blacklist
	path assembly
	path annotation
	path known
	path pdomains
	val outdir
	val opt_args
    	 
    output:
    tuple val(sample_id),
	file("${sample_id}.arriba.fusions.tsv"),
	file("${sample_id}.arriba.fusions.discarded.tsv")

    script:
    """
	STAR \
		--runThreadN 8 \
		--genomeDir ${star_idx} \
		--genomeLoad NoSharedMemory \
		--readFilesIn ${reads} \
		--runThreadN ${task.cpus} \
		--readFilesCommand zcat \
		--outStd BAM_Unsorted \
		--outSAMtype BAM Unsorted \
		--outSAMunmapped Within \
		--outBAMcompression 0 \
		--outFilterMultimapNmax 50 \
		--peOverlapNbasesMin 10 \
		--alignSplicedMateMapLminOverLmate 0.5 \
		--alignSJstitchMismatchNmax 5 -1 5 5 \
		--chimSegmentMin 10 \
		--chimOutType WithinBAM HardClip \
		--chimJunctionOverhangMin 10 \
		--chimScoreDropMax 30 \
		--chimScoreJunctionNonGTAG 0 \
		--chimScoreSeparation 1 \
		--chimSegmentReadGapMax 3 \
		--chimMultimapNmax 50 |
	arriba \
    	-x /dev/stdin \
	    -o ${sample_id}.arriba.fusions.tsv \
	    -O ${sample_id}.arriba.fusions.discarded.tsv \
		-a ${annotation}.gtf \
		-g ${annotation}.gtf \
		-b ${blacklist}.tsv.gz \
		-k ${known}.tsv.gz \
		-t ${known}.tsv.gz \
		-p ${pdomains}.gff3	
    """
}

