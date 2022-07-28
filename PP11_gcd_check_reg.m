% % % addpath /usr/local/apps/psycapps/spm/spm12-r7487;
% % % spm fmri

% List of open inputs
% Check Registration: Images to Display - cfg_files


cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways';
epi = importdata('uepi_files_out.txt');

aa = 554
bb = aa + 1;
cc = bb + 1;
dd = cc + 1;
ee = dd + 1;




% random number for slice
ran = num2str(round(rand(1)*261));

jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/batch/check_reg_job.m'};
jobs = repmat(jobfile, 1, 1);
inputs = cell(1, 1);

    a = epi(aa)
    b = epi(bb)
    c = epi(cc)
    d = epi(dd)
    e = epi(ee)

    f = strcat(a,',',ran)
    g = strcat(b,',',ran)
    h = strcat(c,',',ran)
    i = strcat(d,',',ran)
    j = strcat(e,',',ran)

    z = {'/usr/local/apps/psycapps/spm/spm12-r7487/canonical/single_subj_T1.nii'}
  
    
    w = [f; g; h; i; j; z]
    inputs{1, 1} = w; % Check Registration: Images to Display - cfg_files

spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});

