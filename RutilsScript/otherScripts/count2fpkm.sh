## first just mapping reads to genome using RSEM
cd /home/yjxiang/rap-project/1-qc/BG32_clean/
/home/yjxiang/tools/RSEM-master/rsem-calculate-expression --paired-end -p 4 \
    --bowtie2 \
    --bowtie2-path ~/miniconda3/bin \
    --append-names \
    fastp_BG32-10R1.fastq.gz \
    fastp_BG32-10R2.fastq.gz \
    /home/yjxiang/rap-project/3-ref/rap_ref \
    /home/yjxiang/rap-project/4-rsem_out/fastp_BG32-10_rsem_out

## Just for pair-end library
# Note: If processing a small file, set the minimum percentage option (M) to 0.5, otherwise an error may occur.
cd /home/yjxiang/NGS-project/6-count2fpkm
java -jar /home/yjxiang/tools/picard.jar CollectInsertSizeMetrics \
      I=/home/yjxiang/rap-project/4-rsem_out/fastp_BG32-10_rsem_out.transcript.bam \
      O=insert_size_metrics.txt \
      H=insert_size_histogram.pdf 

