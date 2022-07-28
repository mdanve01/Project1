#!/bin/sh

# Script to take list of subject names and performs 
# first level processing on Target Task files


### Select the proper version of matlab

source /usr/local/apps/psycapps/config/matlab_bash

cd /MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/cluster_access

# Make sure to change this according to your account and that this folder exists
OUTPUT_LOG_DIR=$(pwd)/log_1stlvl_hrf
mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)

for subject_number in CC110033 CC110037 CC110056 CC110069 CC110087 CC110098 CC110126 CC110174 CC110187 CC110319 CC110606 CC112141 CC120008 CC120049 CC120061 CC120120 CC120123 CC120166 CC120208 CC120218 CC120234 CC120264 CC120276 CC120286 CC120309 CC120313 CC120319 CC120347 CC120376 CC120409 CC120462 CC120469 CC120470 CC120550 CC120640 CC120727 CC120764 CC120795 CC120816 CC120987 CC121106 CC121111 CC121144 CC121158 CC121200 CC121317 CC121397 CC121411 CC121428 CC121479 CC121685 CC121795 CC122172 CC122405 CC122620 CC210051 CC210088 CC210124 CC210148 CC210172 CC210182 CC210250 CC210304 CC210314 CC210422 CC210519 CC210526 CC210617 CC210657 CC212153 CC220098 CC220107 CC220115 CC220132 CC220151 CC220198 CC220203 CC220223 CC220232 CC220284 CC220323 CC220335 CC220352 CC220372 CC220394 CC220419 CC220506 CC220518 CC220526 CC220535 CC220567 CC220610 CC220635 CC220697 CC220713 CC220806 CC220828 CC220843 CC220901 CC220920 CC220974 CC220999 CC221002 CC221031 CC221033 CC221038 CC221040 CC221054 CC221107 CC221209 CC221220 CC221244 CC221324 CC221352 CC221373 CC221487 CC221511 CC221527 CC221580 CC221595 CC221648 CC221740 CC221775 CC221828 CC221886 CC221935 CC221977 CC221980 CC222120 CC222125 CC222185 CC222258 CC222264 CC222304 CC222326 CC222367 CC222496 CC222555 CC222652 CC222797
do
    echo "Processing Subject $subject_number"
    qsub    -l h_rss=4G \
            -o ${OUTPUT_LOG_DIR}/matlab_${subject_number}.out \
            -e ${OUTPUT_LOG_DIR}/matlab_${subject_number}.err \
            $script_folder/j_call_function.sh $subject_number;       
done
