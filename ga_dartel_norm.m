% enter the name of the matlab script below, followed by (subject_number)
function ga_dartel_norm(subject_number);

    disp('inside the main matlab function');
    disp('Processing Subject');
    disp(subject_number);
    
    % set path
addpath /usr/local/apps/psycapps/spm/spm12-r7487


jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/batch/part2_dartel_FM_job.m'}; % sets the location of the template script (with no individual subject data)
jobs = repmat(jobfile, 1, 1) % repeatedly opens the jobfile nrun times
inputs = cell(3, 1) % specifies how many empty cells there are in the template script, to be filled with data in the below for loop

 
    clear a
    clear b
    clear c

   
    %%%%%%%%%% SET THE FIRST LINE TO THE FIRST SUBJECT'S
    %%%%%%%%%% ID!!!!!!!!!!! %%%%%%%%%%%%%%%%%%%%%%%%%%%
    a = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/anat/sub-CC110033/anat/Template_6.nii') % create path for template 6, found in the first subject's folder
    b = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/anat/sub-',subject_number,'/anat/u_rc1sub-',subject_number,'_T1w_Template.nii') % create path for flow field
    c = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/epi_smt/sub-',subject_number,'/epi_smt/usub-',subject_number,'_epi_smt.nii') % create path for unwarped epi files

    inputs{1, 1} = {a} % upload the anatomical template - template 6
    inputs{2, 1} = {b} % specify the flow field - u_rc1 path - specify the path
    inputs{3, 1} = {c} % load the realigned/coregistered epi files - usub prefix - specify the path


spm('defaults','FMRI')
spm_jobman('run',jobs,inputs{:})

end
