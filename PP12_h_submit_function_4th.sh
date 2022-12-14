#!/bin/sh

# Script to take list of subject names and performs 
# first level processing on Target Task files


### Select the proper version of matlab

source /usr/local/apps/psycapps/config/matlab_bash

cd /MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/cluster_access

# Make sure to change this according to your account and that this folder exists
OUTPUT_LOG_DIR=$(pwd)/log_1stlvl_gammaTD
mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)

for subject_number in CC610071 CC610076 CC610099 CC610101 CC610178 CC610210 CC610212 CC610227 CC610288 CC610292 CC610308 CC610344 CC610392 CC610405 CC610469 CC610496 CC610508 CC610576 CC610614 CC610631 CC610653 CC610671 CC620005 CC620026 CC620044 CC620073 CC620085 CC620090 CC620106 CC620114 CC620118 CC620121 CC620164 CC620193 CC620259 CC620262 CC620264 CC620279 CC620314 CC620354 CC620359 CC620405 CC620429 CC620436 CC620451 CC620466 CC620479 CC620490 CC620496 CC620499 CC620515 CC620518 CC620526 CC620549 CC620560 CC620567 CC620572 CC620592 CC620610 CC620619 CC620659 CC620685 CC620720 CC620785 CC620793 CC620885 CC621118 CC621128 CC621184 CC621199 CC621248 CC621284 CC621642 CC710037 CC710088 CC710099 CC710154 CC710176 CC710313 CC710342 CC710382 CC710416 CC710429 CC710446 CC710462 CC710486 CC710548 CC710566 CC710591 CC710664 CC710858 CC710982 CC711027 CC711035 CC711128 CC711244 CC711245 CC720023 CC720071 CC720103 CC720119 CC720188 CC720238 CC720304 CC720329 CC720407 CC720497 CC720516 CC720622 CC720646 CC720670 CC720685 CC720941 CC720986 CC721052 CC721107 CC721224 CC721291 CC721374 CC721392 CC721418 CC721504 CC721519 CC721532 CC721585 CC721618 CC721648 CC721704 CC721707 CC721729 CC721888 CC721894 CC722421 CC722536 CC722542 CC722651 CC722891 CC723197
do
    echo "Processing Subject $subject_number"
    qsub    -l h_rss=4G \
            -o ${OUTPUT_LOG_DIR}/matlab_${subject_number}.out \
            -e ${OUTPUT_LOG_DIR}/matlab_${subject_number}.err \
            $script_folder/h_call_function.sh $subject_number;       
done
