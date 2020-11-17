
// Marking duplicates: BAM
process UMIADD {
    tag { sample_id + " - UMIAdd" }

    publishDir "${params.outdir}/umi-add", mode: 'copy'
    // conda "$projectDir/conda.yml"

    input:
    tuple sample_id, file(reads), file(I1)

    output:
    tuple sample_id, file("${sample_id}_U{1,2}.fastq.gz")

    script:
    """
    fastp -i ${reads[0]}  \
        -I ${I1}  \
        -o ${sample_id}_U1.fastq.gz \
        -O ${sample_id}_umi1.fastq.gz \
        --umi --umi_loc=read2 --umi_len=8 \
        -G -Q -A -L -w 1 -u 100 -n 8 -Y 100

    fastp -i ${reads[1]}  \
        -I ${I1}  \
        -o ${sample_id}_U2.fastq.gz \
        -O ${sample_id}_umi2.fastq.gz \
        --umi --umi_loc=read2 --umi_len=8 \
        -G -Q -A -L -w 1 -u 100 -n 8 -Y 100
    """
}