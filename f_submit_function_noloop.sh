#!/bin/sh

# Script to take list of subject names and performs 
# first level processing on Target Task files


### Select the proper version of matlab

source /usr/local/apps/psycapps/config/matlab_bash

cd /MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/cluster_access

# Make sure to change this according to your account and that this folder exists
OUTPUT_LOG_DIR=$(pwd)/log_make_template
mkdir -p $OUTPUT_LOG_DIR

script_folder=$(pwd)


qsub    -l h_rss=4G \
        -o ${OUTPUT_LOG_DIR}/matlab.out \
        -e ${OUTPUT_LOG_DIR}/matlab.err \
        $script_folder/f_call_function_noloop.sh;
