#!/bin/sh

subject_number=$1

echo $subject_number

### in this case the script folder is same as pwd but in other occasions change the path to your script directory

script_folder=/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run

cd $script_folder

matlab -nosplash -r "k_1st_Level_GammaTD_fourier('$subject_number');exit;"
