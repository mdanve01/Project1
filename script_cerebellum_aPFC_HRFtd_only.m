addpath /usr/local/apps/psycapps/spm/spm12-r7487;
spm_get_defaults('mat.format','-v7.3');

% load the fourier f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/fourier_conimages/1_con';
f_cer = niftiread('cerebellum_fourier.nii');
f_pfc = niftiread('fp1_all.nii');

% load the HRFtd f maps
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/hrf_td_conimages/1_con';
h_cer = niftiread('cerebellum_HRFtd.nii');
h_pfc = niftiread('fp1_all.nii');

% load the functions
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';
fourier = importdata('Fourier.mat');
hrftd = importdata('HRFtd.mat');

% modify the F maps to be binary
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));
            if f_cer(first,second,third) > 0;
                f_cer(first,second,third) = 1;
            else f_cer(first,second,third) = 0;
            end
            if f_pfc(first,second,third) > 0;
                f_pfc(first,second,third) = 1;
            else f_pfc(first,second,third) = 0;
            end
            if h_cer(first,second,third) > 0;
                h_cer(first,second,third) = 1;
            else h_cer(first,second,third) = 0;
            end
            if h_pfc(first,second,third) > 0;
                h_pfc(first,second,third) = 1;
            else h_pfc(first,second,third) = 0;
            end
        end
    end
end

%%% SET WINDOW LENGTH %%%%
window = 32;
% calculates how many indices equate to 1 second
sec = length(hrftd(:,1)) ./ window;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/3rd_level/hrftd';
one = spm_vol('beta_0001.nii');
[a,XYZ1]=spm_read_vols(one);

two = spm_vol('beta_0002.nii');
[b,XYZ2]=spm_read_vols(two);

three = spm_vol('beta_0003.nii');
[c,XYZ3]=spm_read_vols(three);

total_run(1,1:261) = 0;

% cycle through the funtions to estimate parameters
for first = 1:length(f_cer(:,1,1));
    for second = 1:length(f_cer(1,:,1));
        for third = 1:length(f_cer(1,1,:));            
            if h_cer(first,second,third) > 0 || h_pfc(first,second,third) > 0;
                if f_cer(first,second,third) == 0 & f_pfc(first,second,third) == 0;
                    clear sum_all;
                    clear a1
                    clear b1
                    clear c1
                    a1 = hrftd(:,1) .* a(first,second,third);
                    b1 = hrftd(:,2) .* b(first,second,third);
                    c1 = hrftd(:,3) .* c(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1;

                    clear n
                    n = length(total_run(:,1)) + 1

                    total_run(n,1:260) = sum_all;
                    
                    % roughly separate by valence
                    if a(first,second,third) > 0;
                        figure(98); plot(sum_all);
                        hold on
                        total_run(n,261) = 1;
                    else figure(99); plot(sum_all);
                        hold on
                        total_run(n,261) = -1;
                    end
                end
            end
        end
    end
end

figure(99);
xlabel('Time (secs)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
hold off

figure(98);
xlabel('Time (secs)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
hold off

figure(100);
clear a;
a = find(total_run(:,261) == 1);
mean_func = mean(total_run(a,1:260));
plot(mean_func,'LineWidth',2);
xlabel('Time (secs)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));

figure(101);
clear a;
a = find(total_run(:,261) == -1);
mean_func = mean(total_run(a,1:260));
plot(mean_func,'LineWidth',2);
xlabel('Time (secs)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));