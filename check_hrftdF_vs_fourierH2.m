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
            % check HRFtd
            if brain.htd(first,second,third) > 0;
                brain.htd(first,second,third) = 1;
            else
                brain.htd(first,second,third) = 0;
            end
            % check Fourier(HRFtd)
            if brain.fh(first,second,third) > 0;
                brain.fh(first,second,third) = 1;
            else
                brain.fh(first,second,third) = 0;
            end
            % check HRFtd(Fourier)
            if brain.four(first,second,third) > 0;
                brain.four(first,second,third) = 1;
            else
                brain.four(first,second,third) = 0;
            end
        end
    end
end

fourier_out(1:147) = 0;
hrftd_out(1:260) = 0;
fourier_out_h(1:260) = 0;
hrftd_out_f(1:147) = 0;

clear first
clear second
clear third
% now look for cases where fourier(hrftd) is sig but hrftd(fourier is not,
% and vice versa
for first = 1:length(brain.hf(:,1,1));
    for second = 1:length(brain.hf(1,:,1));
        for third = 1:length(brain.hf(1,1,:));
            if brain.fh(first,second,third) == 1 & brain.hf(first,second,third) == 0;
                clear n
                n = length(fourier_out(:,1)) + 1;
                %create the summed response
                run.a1 = bfs.four(:,1) .* four.a(first,second,third);
                run.b1 = bfs.four(:,2) .* four.b(first,second,third);
                run.c1 = bfs.four(:,3) .* four.c(first,second,third);
                run.d1 = bfs.four(:,4) .* four.d(first,second,third);
                run.e1 = bfs.four(:,5) .* four.e(first,second,third);
                run.f1 = bfs.four(:,6) .* four.f(first,second,third);
                run.g1 = bfs.four(:,7) .* four.g(first,second,third);
                % sum these to create a single function
                run.sum_all = run.a1 + run.b1 + run.c1 + run.d1 + run.e1 + run.f1 + run.g1;
                fourier_out(n,1:147) = run.sum_all;
                if brain.four(first,second,third) > 0;
                    fourier_out(n,148) = 1;
                end
                clear run
                if brain.htd(first,second,third) > 0;
                    fourier_out(n,149) = 1;
                    run.a1 = bfs.htd(:,1) .* htd.a(first,second,third);
                    run.b1 = bfs.htd(:,2) .* htd.b(first,second,third);
                    run.c1 = bfs.htd(:,3) .* htd.c(first,second,third);
                    run.sum_all = run.a1 + run.b1 + run.c1;
                    fourier_out_h(n,1:260) = run.sum_all;
                else fourier_out_h(n,1:260) = 0;
                end
                if brain.four(first,second,third) > 0 & brain.htd(first,second,third) == 0;
                    fourier_out(n,150) = 1;
                end
                if brain.four(first,second,third) == 0 & brain.htd(first,second,third) > 0;
                    fourier_out(n,151) = 1;
                end
                clear run
            end
            
            if brain.hf(first,second,third) == 1 & brain.fh(first,second,third) == 0;
                clear n
                n = length(hrftd_out(:,1)) + 1;
                %create the summed response
                run.a1 = bfs.htd(:,1) .* htd.a(first,second,third);
                run.b1 = bfs.htd(:,2) .* htd.b(first,second,third);
                run.c1 = bfs.htd(:,3) .* htd.c(first,second,third);
                % sum these to create a single function
                run.sum_all = run.a1 + run.b1 + run.c1;
                hrftd_out(n,1:260) = run.sum_all;
                if brain.four(first,second,third) > 0;
                    hrftd_out(n,261) = 1;
                    clear run
                    run.a1 = bfs.four(:,1) .* four.a(first,second,third);
                    run.b1 = bfs.four(:,2) .* four.b(first,second,third);
                    run.c1 = bfs.four(:,3) .* four.c(first,second,third);
                    run.d1 = bfs.four(:,4) .* four.d(first,second,third);
                    run.e1 = bfs.four(:,5) .* four.e(first,second,third);
                    run.f1 = bfs.four(:,6) .* four.f(first,second,third);
                    run.g1 = bfs.four(:,7) .* four.g(first,second,third);
                    % sum these to create a single function
                    run.sum_all = run.a1 + run.b1 + run.c1 + run.d1 + run.e1 + run.f1 + run.g1;
                    hrftd_out_f(n,1:147) = run.sum_all;
                else hrftd_out_f(n,1:147) = 0;
                end
                if brain.htd(first,second,third) > 0;
                    hrftd_out(n,262) = 1;
                end
                if brain.four(first,second,third) == 0 & brain.htd(first,second,third) > 0;
                    hrftd_out(n,263) = 1;
                end
                if brain.four(first,second,third) > 0 & brain.htd(first,second,third) == 0;
                    hrftd_out(n,264) = 1;
                end
                clear run
            end
        end
    end
end

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation';
hvf.hrftd = hrftd_out;
hvf.fourier = fourier_out;
hvf.sec.hrf = sec.htd;
hvf.sec.four = sec.four;
hvf.win.hrf = window.htd;
hvf.win.four = window.four;
hvf.fourier_within_hrftd = hrftd_out_f;
hvf.hrftd_within_fourier = fourier_out_h;

% remove irrelevant first row
hvf.hrftd(1,:) = [];
hvf.fourier(1,:) = [];
hvf.hrftd_within_fourier(1,:) = [];
hvf.fourier_within_hrftd(1,:) = [];

save hrftd_vs_fourier hvf

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation';
load('hrftd_vs_fourier.mat');

clear n
for n = 1:length(hvf.hrftd(:,1));
    hvf.correct.hrftd(n,:) = hvf.hrftd(n,1:260) ./ (max([max(hvf.hrftd(n,1:260)) max(-hvf.hrftd(n,1:260))]));
end
clear n
for n = 1:length(hvf.fourier(:,1));
    hvf.correct.fourier(n,1:147) = hvf.fourier(n,1:147) ./ (max([max(hvf.fourier(n,1:147)) max(-hvf.fourier(n,1:147))]));
end
clear n
for n = 1:length(hvf.hrftd_within_fourier(:,1));
    hvf.correct.hwf(n,:) = hvf.hrftd_within_fourier(n,1:260) ./ (max([max(hvf.hrftd_within_fourier(n,1:260)) max(-hvf.hrftd_within_fourier(n,1:260))]));
end
clear n
for n = 1:length(hvf.fourier_within_hrftd(:,1));
    hvf.correct.fwh(n,:) = hvf.fourier_within_hrftd(n,1:147) ./ (max([max(hvf.fourier_within_hrftd(n,1:147)) max(-hvf.fourier_within_hrftd(n,1:147))]));
end
% set number of randoms
randnum = 20;

figure(99);
subplot(1,2,1);
j = round(rand(1,randnum) .* length(hvf.correct.hrftd(:,1)));
clear n
for n = 1:length(j);
    plot(hvf.correct.hrftd(j(n),1:260));
    hold on
end
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
title('HRFtd(Fourier)');
hold off

figure(99);
subplot(1,2,2);
clear j
j = round(rand(1,randnum) .* length(hvf.correct.fourier(:,1)));
clear n
for n = 1:length(j);
    plot(hvf.correct.fourier(j(n),1:147));
    hold on
end
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
title('Fourier(HRFtd)');
hold off

% check the percentage of fourier or HRFtd
check.fh_hrftd = (sum(hvf.fourier(:,149)) ./ length(hvf.fourier(:,1))) .* 100;
check.fh_fourier = (sum(hvf.fourier(:,148)) ./ length(hvf.fourier(:,1))) .* 100;
check.hf_hrftd = (sum(hvf.hrftd(:,262)) ./ length(hvf.hrftd(:,1))) .* 100;
check.hf_fourier = (sum(hvf.hrftd(:,261)) ./ length(hvf.hrftd(:,1))) .* 100;

clear a
% identifies fourier only within fourier(HRFtd)
a = find(hvf.fourier(:,150) == 1);
clear b
% identifies HRFtd only within fourier(HRFtd)
b = find(hvf.fourier(:,151) == 1);
clear c
% identifies HRFtd only within HRFtd(Fourier)
c = find(hvf.hrftd(:,263) == 1);
clear d
% identifies Fourier only within HRFtd(Fourier)
d = find(hvf.hrftd(:,264) == 1);

figure(100);
subplot(2,2,1);
clear n
for n = 1:length(a);
    plot(hvf.correct.fourier(a(n),1:147));
    hold on
end
title('Fourier only within Fourier(HRFtd)');
hold off

subplot(2,2,2);
clear n
for n = 1:length(c);
    plot(hvf.correct.hrftd(c(n),1:260));
hold on
end
title('HRFtd only within HRFtd(Fourier)');
hold off

subplot(2,2,3);
clear n
for n = 1:length(d);
    plot(hvf.correct.fwh(d(n),1:147));
    hold on
end
title('Fourier only within HRFtd(Fourier)');
hold off

subplot(2,2,4);
clear n
for n = 1:length(b);
    plot(hvf.correct.hwf(b(n),1:260));
hold on
end
title('HRFtd only within Fourier(HRFtd)');
hold off