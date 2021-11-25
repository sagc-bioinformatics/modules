process arriba {

	tag { "Arriba - ${filename}" } 
    publishDir "${outdir}/${group}/${filename}/Arriba", mode: 'copy'
    label 'process_arriba'
	conda "$projectDir/conf/arriba-2.1.0.yml"

    input:
	tuple val(filename), val(group), val(sample), val(path), file(reads)
	file assembly
	file gtf
	file blacklist
	file knownfus
	file proteindom
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
		-k ${knownfus}.tsv.gz \
		-p ${proteindom}.gff3
    """
}

