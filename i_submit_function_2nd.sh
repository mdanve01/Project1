#!/bin/sh

# Script to take list of subject names and performs 
# first level processing on Target Task files


### Select the proper version of matlab

source /usr/local/apps/psycapps/config/matlab_bash

cd /MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/cluster_access

# Make sure to change this according to your account and that this folder exists
OUTPUT_LOG_DIR=$(pwd)/log_1stlvl_fourier
mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)

for subject_number in CC222956 CC223115 CC223286 CC310008 CC310051 CC310052 CC310086 CC310129 CC310142 CC310160 CC310203 CC310214 CC310224 CC310252 CC310256 CC310331 CC310361 CC310385 CC310391 CC310397 CC310400 CC310402 CC310407 CC310410 CC310414 CC310450 CC310463 CC310473 CC312058 CC312222 CC320002 CC320022 CC320059 CC320088 CC320107 CC320109 CC320160 CC320202 CC320206 CC320218 CC320267 CC320269 CC320297 CC320325 CC320342 CC320417 CC320429 CC320448 CC320461 CC320478 CC320500 CC320553 CC320568 CC320574 CC320575 CC320576 CC320608 CC320616 CC320621 CC320636 CC320651 CC320661 CC320680 CC320686 CC320687 CC320698 CC320759 CC320776 CC320814 CC320850 CC320870 CC320888 CC320893 CC321000 CC321025 CC321053 CC321069 CC321073 CC321087 CC321107 CC321137 CC321154 CC321174 CC321203 CC321281 CC321291 CC321331 CC321368 CC321428 CC321431 CC321464 CC321504 CC321506 CC321529 CC321544 CC321557 CC321585 CC321594 CC321595 CC321880 CC321899 CC321976 CC410015 CC410032 CC410040 CC410084 CC410086 CC410091 CC410094 CC410097 CC410101 CC410119 CC410121 CC410169 CC410173 CC410177 CC410182 CC410220 CC410226 CC410243 CC410248 CC410251 CC410284 CC410287 CC410323 CC410325 CC410354 CC410387 CC410390 CC410432 CC412004 CC412021 CC420004 CC420060 CC420061 CC420071 CC420075 CC420089 CC420091 CC420100
do
    echo "Processing Subject $subject_number"
    qsub    -l h_rss=4G \
            -o ${OUTPUT_LOG_DIR}/matlab_${subject_number}.out \
            -e ${OUTPUT_LOG_DIR}/matlab_${subject_number}.err \
            $script_folder/i_call_function.sh $subject_number;       
done
