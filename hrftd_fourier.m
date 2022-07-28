function hrftd_fourier;

    disp('inside the main matlab function');
    disp('Processing Subject');

addpath /usr/local/apps/psycapps/spm/spm12-r7487

% List of open inputs

jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_analyses/functions_separate/batch/hrftd_fourier1_job.m'};
jobs = repmat(jobfile, 1, 1);
inputs = cell(0, 1);

spm('defaults', 'FMRI');
spm_get_defaults('mat.format','-v7.3');
spm_jobman('run', jobs, inputs{:});


end
