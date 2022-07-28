addpath /usr/local/apps/psycapps/spm/spm12-r7487;

% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf_td1/CC110033_hrf_td_test';
first_spm.htd = load('SPM.mat');

% load the 3 functions
bfs.htd = first_spm.htd.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window.htd = first_spm.htd.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec.htd = length(bfs.htd) ./ window.htd;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd';
htd.one = spm_vol('beta_0001.nii');
[htd.a,htd.XYZ1]=spm_read_vols(htd.one);

htd.two = spm_vol('beta_0002.nii');
[htd.b,htd.XYZ2]=spm_read_vols(htd.two);

htd.three = spm_vol('beta_0003.nii');
[htd.c,htd.XYZ3]=spm_read_vols(htd.three);

brain.htd = niftiread('htd_all.nii');



% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/fourier1/CC110033_fourier_test';
first_spm.four = load('SPM.mat');

% load the 7 functions
bfs.four = first_spm.four.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window.four = first_spm.four.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec.four = length(bfs.four) ./ window.four;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';
four.one = spm_vol('beta_0001.nii');
[four.a,four.XYZ1]=spm_read_vols(four.one);

four.two = spm_vol('beta_0002.nii');
[four.b,four.XYZ2]=spm_read_vols(four.two);

four.three = spm_vol('beta_0003.nii');
[four.c,four.XYZ3]=spm_read_vols(four.three);

four.four = spm_vol('beta_0004.nii');
[four.d,four.XYZ4]=spm_read_vols(four.four);

four.five = spm_vol('beta_0005.nii');
[four.e,four.XYZ5]=spm_read_vols(four.five);

four.six = spm_vol('beta_0006.nii');
[four.f,four.XYZ6]=spm_read_vols(four.six);

four.seven = spm_vol('beta_0007.nii');
[four.g,four.XYZ7]=spm_read_vols(four.seven);

brain.four = niftiread('f_all');

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier_hrftd';
brain.fh = niftiread('fh_all.nii');

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd_fourier';
brain.hf = niftiread('hf_all.nii');

% run through the f masks and replace values with 1, and non values with
% 0
for first = 1:length(brain.hf(:,1,1));
    for second = 1:length(brain.hf(1,:,1));
        for third = 1:length(brain.hf(1,1,:));
            % check HRFtd(Fourier)
            if brain.hf(first,second,third) > 0;
                brain.hf(first,second,third) = 1;
            else
                brain.hf(first,second,third) = 0;
            end
            % check Fourier(HRFtd)
            if brain.fh(first,second,third) > 0;
                brain.fh(first,second,third) = 1;
            else
                brain.fh(first,second,third) = 0;
            end
        end
    end
end
