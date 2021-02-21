process Arriba {
    tag {"Arriba ${sample_id}"}
	publishDir "${outdir}/Arriba", mode: 'copy'
	shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple val(sample_id), file(reads)
        path star_idx
    	path blacklist
    	path assembly
    	path annotation
    	val outdir
        val opt_args
    	 
    output:
    tuple val(sample_id),
        file("${sample_id}.arriba.fusions.tsv"),
        file("${sample_id}.arriba.fusions.discarded.tsv")

    script:
    """
	${opt_args}
        --genomeLoad NoSharedMemory \
    	--outStd BAM_SortedByCoordinate \
    	--outSAMunmapped Within \
    	--outBAMcompression 0 \
    	--outFilterMultimapNmax 50 \
    	--peOverlapNbasesMin 10 \
    	--alignSplicedMateMapLminOverLmate 0.5 \
    	--alignSJstitchMismatchNmax 5 -1 5 5 \
	    --chimJunctionOverhangMin 10 \
    	--chimScoreDropMax 30 \
    	--chimScoreJunctionNonGTAG 0 \
    	--chimScoreSeparation 1 \
    	--chimSegmentReadGapMax 3 \
	    --chimMultimapNmax 50 |
		

    arriba -b ${blacklist}.tsv.gz \
	    -x /dev/stdin \
	    -o ${sample_id}.arriba.fusions.tsv \
	    -O ${sample_id}.arriba.fusions.discarded.tsv \
	    -a ${assembly}.fa \
	    -g ${annotation}.gtf \		
    """
}

