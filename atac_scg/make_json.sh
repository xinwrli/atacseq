#!/bin/bash


base_json=~/projects/atacseq/atac_scg/json/base_json
genome_ref=~/projects/atacseq/atac_scg/reference/rn6/rn6.tsv

fastq_dir=~/projects/atacseq/fastq/kevin/FASTQ_RUN8
merged_fastq_dir=~/projects/atacseq/fastq/merged


json_dir=~/projects/atacseq/atac_scg/json

#suffix of input fastq files
SUF_R1=_R1_001.fastq.gz
SUF_R2=_R2_001.fastq.gz
#suffix of output files
OUT1_SUF=merge_R1.fastq.gz
OUT2_SUF=merge_R2.fastq.gz

# If array is present, it is cleared, and then the zeroth element of array is set to the entire portion of string matched by regexp. If regexp contains parentheses, the integer-indexed elements of array are set to contain the portion of string matching the corresponding parenthesized subexpression. 

# indiv=$(ls -1 ${fastq_dir}/RD*_001.fastq.gz | awk '{ match($0, /(RD[0-9]+)_/, arr); print arr[1]}' | sort | uniq)
indiv=$(ls -1 ${fastq_dir}/*_001.fastq.gz | awk '{ match($0, /([\-A-z0-9]+)_L[0-9]+/, arr); print arr[1]}' | sort | uniq)

# echo $indiv

for i in $indiv
do

        json_file=${json_dir}/${i}.json

	echo "{" > ${json_file}
	echo "\"atac.qc_report.name\" : \"${i}\"," >> ${json_file}
    	echo "\"atac.qc_report.desc\" : \"ATAC-seq on motrpac\"," >> ${json_file}

	echo "\"atac.pipeline_type\" : \"atac\"," >> ${json_file}
	echo  "\"atac.genome_tsv\" : \"${genome_ref}\"," >> ${json_file}
	
	cat ${base_json} >> ${json_file}

	echo "\"atac.fastqs_rep1_R1\" : [" >> ${json_file}
	counter=1
	for j in $(ls ${fastq_dir}/${i}_*L00*${SUF_R1})
	do
		if [ "$counter" = 1 ]; then
			echo "\"${j}\"" >> ${json_file}
		else
			echo ",\"${j}\"" >> ${json_file}
		fi
		counter=$((counter +1))
	done
	echo "]," >> ${json_file}
	echo "\"atac.fastqs_rep1_R2\" : [" >> ${json_file}
	counter=1
	for k in $(ls ${fastq_dir}/${i}_*L00*${SUF_R2})
        do
                if [ "$counter" = 1 ]; then
                        echo "\"${k}\"" >> ${json_file}
                else
                        echo ",\"${k}\"" >> ${json_file}
                fi
                counter=$((counter +1))
	done
	echo "]" >> ${json_file}

	echo "}" >> ${json_file}

done





