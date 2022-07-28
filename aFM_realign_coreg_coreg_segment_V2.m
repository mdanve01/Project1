% enter the name of the matlab script below, followed by (subject_number)
function aFM_realign_coreg_coreg_segment_V2(subject_number);

    disp('inside the main matlab function');
    disp('Processing Subject');
    disp(subject_number);
    
    % set path
addpath /usr/local/apps/psycapps/spm/spm12-r7487

 
jobfile = {'/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/batch/Up_to_seg_13May_V2_job.m'}; % sets the location of the template script (with no individual subject data)
jobs = repmat(jobfile, 1, 1) % repeatedly opens the jobfile nrun times
inputs = cell(5, 1) % specifies how many empty cells there are in the template script, to be filled with data in the below loop
% for crun = 1: % determines which subjects (rows in the above files) this is run on
    clear pha
    clear mag
    clear epi1
    clear epi
    clear t1
    
    
    
    % specifies the file to be loaded
    pha = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/fmap_smt/sub-',subject_number,'/fmap/sub-',subject_number,'_fmap.nii,1') % adds ,1 to the end of the path
    mag = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/fmap_smt/sub-',subject_number,'/fmap/sub-',subject_number,'_run-01_fmap.nii,1') % adds ,1 to the end of the path
    epi1 = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/epi_smt/sub-',subject_number,'/epi_smt/sub-',subject_number,'_epi_smt.nii,1') % adds ,1 to the end of the path 3
    epi = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/epi_smt/sub-',subject_number,'/epi_smt/sub-',subject_number,'_epi_smt.nii') % as above but for path 4
    t1 = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/anat/sub-',subject_number,'/anat/sub-',subject_number,'_T1w.nii,1') % adds ,1 to the end of the path
   
    
    % loads the files for this subject
    inputs{1, 1} = {pha} % Calculate VDM: Phase Image - cfg_files
    inputs{2, 1} = {mag} % Calculate VDM: Magnitude Image - cfg_files
    inputs{3, 1} = {epi1} % Calculate VDM: Select EPI to Unwarp - cfg_files
    inputs{4, 1} = {epi} % Realign & Unwarp: Images - cfg_files - specify the (path,:}
    inputs{5, 1} = {t1} % Coregister: Estimate & Reslice: Source Image - cfg_files - specify the {path,1}
  


% executes the analysis itself
spm('defaults','FMRI')
spm_jobman('run',jobs,inputs{:})

end