#!/bin/sh

subject_number=$1

echo $subject_number

### in this case the script folder is same as pwd but in other occasions change the path to your script directory

script_folder=/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run

cd $script_folder

matlab -nosplash -r "aFM_realign_coreg_coreg_segment_V2('$subject_number');exit;"
