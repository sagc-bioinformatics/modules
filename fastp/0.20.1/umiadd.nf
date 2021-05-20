process umiadd {

    tag { "Fastp UMI-ADD - ${sample_id}" }
    publishDir "${outdir}/${sampleProject}/umi_add", mode: 'copy'
    label 'process_low'

    input:
    tuple val(sample_id), file(reads), file(UMI)
    val outdir
    val sampleProject

    output:
    tuple val(sample_id), file("${sample_id}_U{1,2}.fastq.gz"), emit: reads
    file("${sample_id}.{html,json}")

    script:
    """
    fastp \
        ${usr_args} \
        -i ${reads[0]}  \
        -I ${UMI}  \
        -o ${sample_id}_U1.fastq.gz \
        -O ${sample_id}_umi1.fastq.gz \
        --json ${sample_id}_U1.json \
        --html ${sample_id}_U1.html \
        --umi --umi_loc=read2 --umi_len=8 \
        -G -Q -A -L -w 1 -u 100 -n 8 -Y 100

    fastp \
        ${usr_args} \
        -i ${reads[1]}  \
        -I ${UMI}  \
        -o ${sample_id}_U2.fastq.gz \
        -O ${sample_id}_umi2.fastq.gz \
        --json ${sample_id}_U2.json \
        --html ${sample_id}_U2.html \
        --umi --umi_loc=read2 --umi_len=8 \
        -G -Q -A -L -w 1 -u 100 -n 8 -Y 100
    """
}
