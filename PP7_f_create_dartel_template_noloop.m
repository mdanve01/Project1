% enter the name of the matlab script below, followed by (subject_number)
function f_create_dartel_template_noloop;

    disp('inside the main matlab function');
    disp('Processing Subject');
   

addpath /usr/local/apps/psycapps/spm/spm12-r7487



jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/e_load_rc1_2_job.m'};
jobs = repmat(jobfile, 1, 1);
inputs = cell(0, 1);

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

clear jobfile
clear jobs
clear inputs


end
