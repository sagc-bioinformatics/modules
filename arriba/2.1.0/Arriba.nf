process arriba {

	tag { "Arriba - ${filename}" } 
    publishDir "${outdir}/${group}/${filename}/Arriba", mode: 'copy'
    label 'process_arriba'

    input:
	tuple val(filename), val(group), val(sample), val(path), file(reads)
	val assembly
	val gtf
	val blacklist
	val knownfus
	val proteindom
	val staridx
	val outdir
    	 
    output:
	file "${filename}.arriba.fusions.tsv"
	file "${filename}.arriba.fusions.discarded.tsv"

    script:
    """
	STAR \
		--genomeDir ${staridx} \
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
	    -o ${filename}.arriba.fusions.tsv \
	    -O ${filename}.arriba.fusions.discarded.tsv \
		-a ${assembly} \
		-g ${gtf} \
		-b ${blacklist} \
		-k ${knownfus} \
		-p ${proteindom}
    """
}

