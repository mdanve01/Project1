addpath /usr/local/apps/psycapps/spm/spm12-r7487;
spm_get_defaults('mat.format','-v7.3');

% load the fourier f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';
f_cer = niftiread('f_cer.nii');
f_pfc = niftiread('f_fp1.nii');
f_a1 = niftiread('f_a1.nii');
f_m1 = niftiread('f_m1.nii');
f_v1 = niftiread('f_v1.nii');

% load the HRFtd f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd';
h_cer = niftiread('htd_cer.nii');
h_pfc = niftiread('htd_fp1.nii');
h_a1 = niftiread('htd_a1.nii');
h_m1 = niftiread('htd_m1.nii');
h_v1 = niftiread('htd_v1.nii');

% load the fourier(hrftd) f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier_hrftd';
fh_cer = niftiread('fh_cer.nii');
fh_pfc = niftiread('fh_fp1.nii');
fh_a1 = niftiread('fh_a1.nii');
fh_m1 = niftiread('fh_m1.nii');
fh_v1 = niftiread('fh_v1.nii');

% load the fourier(hrftd) f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd_fourier';
hf_cer = niftiread('hf_cer.nii');
hf_pfc = niftiread('hf_fp1.nii');
hf_a1 = niftiread('hf_a1.nii');
hf_m1 = niftiread('hf_m1.nii');
hf_v1 = niftiread('hf_v1.nii');

% load the functions
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';
fourier = importdata('Fourier.mat');
hrftd = importdata('HRFtd.mat');

%%% SET WINDOW LENGTH %%%%
window = 18;
% calculates how many indices equate to 1 second
sec = length(fourier(:,1)) ./ window;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';
one = spm_vol('beta_0001.nii');
[a,XYZ1]=spm_read_vols(one);

two = spm_vol('beta_0002.nii');
[b,XYZ2]=spm_read_vols(two);

three = spm_vol('beta_0003.nii');
[c,XYZ3]=spm_read_vols(three);

four = spm_vol('beta_0004.nii');
[d,XYZ4]=spm_read_vols(four);

five = spm_vol('beta_0005.nii');
[e,XYZ5]=spm_read_vols(five);

six = spm_vol('beta_0006.nii');
[f,XYZ6]=spm_read_vols(six);

seven = spm_vol('beta_0007.nii');
[g,XYZ7]=spm_read_vols(seven);

total_run(1,1:151) = 0;


% run this with aPFC
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_pfc(first,second,third) > 0;
                fh_pfc(first,second,third) = 1;
            else fh_pfc(first,second,third) = 0;
            end
            if hf_pfc(first,second,third) > 0;
                hf_pfc(first,second,third) = 1;
            else hf_pfc(first,second,third) = 0;
            end
            if fh_pfc(first,second,third) == 1 & hf_pfc(first,second,third) == 0;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91);
                        subplot(5,2,10);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,10);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 1;
                    total_run(n,150) = 2;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,10);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('aPFC: Fourier(HRFtd)');
% ylim([-1.1 1.1]);
hold off

% run this with aPFC
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_pfc(first,second,third) > 0;
                fh_pfc(first,second,third) = 1;
            else fh_pfc(first,second,third) = 0;
            end
            if hf_pfc(first,second,third) > 0;
                hf_pfc(first,second,third) = 1;
            else hf_pfc(first,second,third) = 0;
            end
            if fh_pfc(first,second,third) == 0 & hf_pfc(first,second,third) == 1;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91);
                        subplot(5,2,9);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,9);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 1;
                    total_run(n,150) = 2;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,9);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('aPFC: HRFtd(Fourier)');
% ylim([-1.1 1.1]);
hold off


% run this with a1
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_a1(first,second,third) > 0;
                fh_a1(first,second,third) = 1;
            else fh_a1(first,second,third) = 0;
            end
            if hf_a1(first,second,third) > 0;
                hf_a1(first,second,third) = 1;
            else hf_a1(first,second,third) = 0;
            end
            if fh_a1(first,second,third) == 1 & hf_a1(first,second,third) == 0;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,2)
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,2);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 2;
                    total_run(n,150) = 2; 
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,2);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('A1: Fourier(HRFtd)');
% ylim([-1.1 1.1]);
hold off

% run this with a1 (HRFtd(Fourier))
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_a1(first,second,third) > 0;
                fh_a1(first,second,third) = 1;
            else fh_a1(first,second,third) = 0;
            end
            if hf_a1(first,second,third) > 0;
                hf_a1(first,second,third) = 1;
            else hf_a1(first,second,third) = 0;
            end
            if fh_a1(first,second,third) == 0 & hf_a1(first,second,third) == 1;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,1);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,1);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 2;
                    total_run(n,150) = 1;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,1);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('A1: HRFtd(Fourier)');
% ylim([-1.1 1.1]);
hold off


% run this with m1
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_m1(first,second,third) > 0;
                fh_m1(first,second,third) = 1;
            else fh_m1(first,second,third) = 0;
            end
            if hf_m1(first,second,third) > 0;
                hf_m1(first,second,third) = 1;
            else hf_m1(first,second,third) = 0;
            end
            if fh_m1(first,second,third) == 1 & hf_m1(first,second,third) == 0;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,4);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,4);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 3;
                    total_run(n,150) = 2;   
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,4);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('M1: Fourier(HRFtd)');
% ylim([-1.1 1.1]);
hold off

% run this with m1 (HRFtd(Fourier))
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_m1(first,second,third) > 0;
                fh_m1(first,second,third) = 1;
            else fh_m1(first,second,third) = 0;
            end
            if hf_m1(first,second,third) > 0;
                hf_m1(first,second,third) = 1;
            else hf_m1(first,second,third) = 0;
            end
            if fh_m1(first,second,third) == 0 & hf_m1(first,second,third) == 1;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,3);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,3);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 3;
                    total_run(n,150) = 1;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,3);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('M1: HRFtd(Fourier)');
% ylim([-1.1 1.1]);
hold off



% run this with v1
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_v1(first,second,third) > 0;
                fh_v1(first,second,third) = 1;
            else fh_v1(first,second,third) = 0;
            end
            if hf_v1(first,second,third) > 0;
                hf_v1(first,second,third) = 1;
            else hf_v1(first,second,third) = 0;
            end
            if fh_v1(first,second,third) == 1 & hf_v1(first,second,third) == 0;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,6);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,6);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 4;
                    total_run(n,150) = 2;  
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,6);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('V1: Fourier(HRFtd)');
% ylim([-1.1 1.1]);
hold off

% run this with v1 (HRFtd(Fourier))
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_v1(first,second,third) > 0;
                fh_v1(first,second,third) = 1;
            else fh_v1(first,second,third) = 0;
            end
            if hf_v1(first,second,third) > 0;
                hf_v1(first,second,third) = 1;
            else hf_v1(first,second,third) = 0;
            end
            if fh_v1(first,second,third) == 0 & hf_v1(first,second,third) == 1;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,5);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,5);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 4;
                    total_run(n,150) = 1;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,5);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('V1: HRFtd(Fourier)');
% ylim([-1.1 1.1]);
hold off



% run this with cer
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_cer(first,second,third) > 0;
                fh_cer(first,second,third) = 1;
            else fh_cer(first,second,third) = 0;
            end
            if hf_cer(first,second,third) > 0;
                hf_cer(first,second,third) = 1;
            else hf_cer(first,second,third) = 0;
            end
            if fh_cer(first,second,third) == 1 & hf_cer(first,second,third) == 0;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,8);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,8);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 5;
                    total_run(n,150) = 2;  
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,8);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('Cerebellum: Fourier(HRFtd)');
% ylim([-1.1 1.1]);
hold off

% run this with cer (HRFtd(Fourier))
% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if fh_cer(first,second,third) > 0;
                fh_cer(first,second,third) = 1;
            else fh_cer(first,second,third) = 0;
            end
            if hf_cer(first,second,third) > 0;
                hf_cer(first,second,third) = 1;
            else hf_cer(first,second,third) = 0;
            end
            if fh_cer(first,second,third) == 0 & hf_cer(first,second,third) == 1;
                try
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    a1 = fourier(:,1) .* a(first,second,third);
                    b1 = fourier(:,2) .* b(first,second,third);
                    c1 = fourier(:,3) .* c(first,second,third);
                    d1 = fourier(:,4) .* d(first,second,third);
                    e1 = fourier(:,5) .* e(first,second,third);
                    f1 = fourier(:,6) .* f(first,second,third);
                    g1 = fourier(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:147) = sum_all;

                    clear val
                    val(1) = max(sum_all);
                    val(2) = max(-sum_all);

                    % roughly separate by valence
                    if val(1) > val(2);
                        sum_all = sum_all ./ max(sum_all);
                        figure(91); 
                        subplot(5,2,7);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = 1;
                    else sum_all = sum_all ./ max(-sum_all);
                        figure(91); 
                        subplot(5,2,7);
                        plot(sum_all);
                        hold on
                        total_run(n,148) = -1;
                    end
                    total_run(n,149) = 5;
                    total_run(n,150) = 1;
                    catch
                        total_run(n,151) = 1;
                end
            end
        end
    end
end


figure(91);
subplot(5,2,7);
xlabel('Time (secs)');
ylabel('Normalised Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
title('Cerebellum: HRFtd(Fourier)');
% ylim([-1.1 1.1]);
hold off
