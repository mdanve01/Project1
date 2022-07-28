%%%% CHECK LINES 77 AND 95, THEY MIGHT NOT BE CALCULATING THE RIGHT
%%%% DIMENSIONS %%%% ALSO LINE 192 MAY NOT WORK %%%%

addpath /usr/local/apps/psycapps/spm/spm12-r7487
cd ('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range');
load stack_rand;
stack = stack_rand(:,1:2);
cd ('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/outliers');
save stack stack;

for z = 1:length(stack(:,1));
    ID = stack(z,1);
    ID2 = num2str(ID);
    path = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/epi_smt/sub-CC',ID2,'/epi_smt');
    sub = strcat('sub-CC',ID2,'_epi_smt.nii');
    
    
    cd(path);

% get volumes
vols = sub;
M=nifti(vols);

% we have 4D data (64 x 64 x 32 x 261), here I calculate the mean slice values (1:32) at volume 1, then
% volume 2 etc. The 64 x 64 is the 2D epi sheet represented at a slice.
% This is then replicated at each volume.
for v = 1:(M.dat.dim(4));
    for s = 1:(M.dat.dim(3));
        slicemean(v,s) = mean(mean(M.dat(:,:,s,v)));
    end
end

slicemean_t = slicemean';

% looks at each value in slicemean_t, and subtracts the mean of that slice,
% to normalise the scores (so the mean value = 0)
for n = 1:s
    slicemean_norm_slice(n,:) = slicemean_t(n,:) - mean(slicemean_t(n,:));
end

% repeats normalising for each volume
for n = 1:v
    slicemean_norm_vol(:,n) = slicemean_t(:,n) - mean(slicemean_t(:,n));
end

% calculate mean for each slice (accross volumes)
slicemean_mean_slice = mean(slicemean);
slicemean_norm_mean_slice = mean(slicemean_norm_slice');
% calculate mean for each volume (accross slices)
slicemean_mean_vol = mean(slicemean');
slicemean_norm_mean_vol = mean(slicemean_norm_vol);
% calculate std for each slice
slicemean_std_slice = std(slicemean);
slicemean_norm_std_slice = std(slicemean_norm_slice');
% calculate std for each volume
slicemean_std_vol = std(slicemean');
slicemean_norm_std_vol = std(slicemean_norm_vol);

% fast fourier transform
slicemean_fft = (abs(fft(slicemean_norm_slice')))';

% looks at each slice, and calculates the range of scores accross volumes.
% Then calculates the maximum range for this subject
clear xnx
for xnx = 1:length(slicemean(1,:));
    all_val_t(xnx) = max(slicemean(:,xnx)) - min(slicemean(:,xnx));
end
max_range_temporal = max(all_val_t);
min_range_temporal = min(all_val_t);

% looks at each slice, within each slice looks accross volumes, calculates
% the difference from one volume to the next, within the slice. Looks for
% large shifts
clear xnx
clear xxn
for xnx = 1:length(slicemean(1,:));
    for xxn = 1:length(slicemean(:,1)) - 1;
        all_shift_t(xnx,xxn) = slicemean(xxn + 1,xnx) - slicemean(xxn,xnx);
    end
end
max_shift_temporal = max(max(abs(all_shift_t')));
max_sh_t = max(abs(all_shift_t'));

% calculates the coefficient of variation accross volumes at each slice
clear xnx
for xnx = 1:length(slicemean(1,:));
    cov_t(xnx) = std(slicemean(:,xnx))./mean(slicemean(:,xnx));
end
max_cov_t = max(cov_t);
min_cov_t = min(cov_t);
% does as per above, but here looks at each volume (accross slices), then calculates the
% maximum range accross slices
clear nxn
for nxn = 1:length(slicemean(:,1));
all_val_s(nxn) = max(slicemean(nxn,:)) - min(slicemean(nxn,:));
end
max_range_spatial = max(all_val_s);
min_range_spatial = min(all_val_s);

% looks at each volume, within each volume looks accross slices, calculates
% the difference from one slice to the next, within the volume. Looks for
% large shifts
clear xnx
clear xxn
for xxn = 1:length(slicemean(:,1));
    for xnx = 1:length(slicemean(1,:)) - 1;
        all_shift_s(xxn,xnx) = slicemean(xxn,xnx +1) - slicemean(xxn,xnx);
    end
end
max_shift_spatial = max(max(abs(all_shift_s')));
% min_shift_spatial = min(abs(all_shift_s'));
max_sh_s = max(abs(all_shift_s'));

% calculates the coefficient of variation accross slices at each volume
clear nxn
for nxn = 1:length(slicemean(:,1));
cov_s(nxn) = std(slicemean(nxn,:))./mean(slicemean(nxn,:));
end
max_cov_s = max(cov_s);
min_cov_s = min(cov_s);

% create a results file with key info for automatic outlier
% identification
    results(z,1) = ID;
    results(z,2) = max_range_temporal;
    results(z,3) = max_range_spatial;
    results(z,4) = max_shift_temporal;
    results(z,5) = max_shift_spatial;
    results(z,6) = max_cov_t;
    results(z,7) = max_cov_s;
    results(z,8) = mean(mean(slicemean));

figure(z);

% specify the file into a variable to later save the plots in a loop
y = figure(z);


set(y, 'Visible', 'off');
    
    subplot(3,1,1), imagesc(slicemean_norm_slice);
    subplot(3,1,1), title('signal intensity (corrected within slice)');
    subplot(3,1,1), xlabel('volume');
    subplot(3,1,1), ylabel('slice');
    colorbar;
    %subplot(3,1,2), axis([1 length(A_norm) min(min(A_norm)) max(max(A_norm))])
    
    subplot(3,1,2), imagesc(slicemean_norm_vol);
    subplot(3,1,2), title('signal intensity (corrected within volume)');
    subplot(3,1,2), xlabel('volume');
    subplot(3,1,2), ylabel('slice');
    colorbar;
    %subplot(3,1,2), axis([1 length(A_norm) min(min(A_norm)) max(max(A_norm))])
    
    subplot(3,1,3), imagesc(slicemean_fft(:,2:(length(slicemean_fft)-1)));
    subplot(3,1,3), axis([1 50 1 size(slicemean_fft,1)]);
    subplot(3,1,3), title('Fast Fourier Transform of above');
    subplot(3,1,3), xlabel('Number of cycles in timecourse');
    subplot(3,1,3), ylabel('slice');
    colorbar;

        
% cd into the directory in which I can save plots, then save each plot
    % in a loop
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/outliers';
    saveas(y,sprintf('FIG%d.jpg',z));    
    
    


% specify the file into a variable to later save the plots in a loop
h = figure(z);


set(h, 'Visible', 'off');
    
    subplot(4,1,1), plot(slicemean_norm_std_vol);
    subplot(4,1,1), title('standard deviation of each volume');
    subplot(4,1,1), xlabel('volume');
    subplot(4,1,1), ylabel('std');
    subplot(4,1,1), axis([1 length(slicemean_norm_std_vol) 40 140]);
%     subplot(5,1,1), axis([1 length(B) min(B) max(B)])    
%     colorbar;
    
    subplot(4,1,2), plot(slicemean_norm_std_slice);
    subplot(4,1,2), title('standard deviation of each slice');
    subplot(4,1,2), xlabel('slice');
    subplot(4,1,2), ylabel('std');
    subplot(4,1,2), axis([1 length(slicemean_norm_std_slice) -5 20]);
%     subplot(5,1,1), axis([1 length(B) min(B) max(B)])    
%     colorbar;

%     subplot(5,1,3), imagesc(slicemean_norm_slice);
%     subplot(5,1,3), title('signal intensity (slice mean corrected)');
%     subplot(5,1,3), xlabel('volume');
%     subplot(5,1,3), ylabel('slice');
%     colorbar;
%     %subplot(3,1,2), axis([1 length(A_norm) min(min(A_norm)) max(max(A_norm))])
    
    maxcovt = min_cov_t + 0.2;
    mincovt = min_cov_t - 0.1;
    subplot(4,1,3), plot(cov_t);
    subplot(4,1,3), title('COV Within Each Slice (Temporal)');
    subplot(4,1,3), xlabel('Slice');
    subplot(4,1,3), ylabel('COV');
    subplot(4,1,3), axis([1 length(cov_t) 0 0.28]);
    
    maxcovs = min_cov_s + 0.2;
    mincovs = min_cov_s - 0.1;
    subplot(4,1,4), plot(cov_s);
    subplot(4,1,4), title('COV Within Each Volume (Spatial)');
    subplot(4,1,4), xlabel('Volume');
    subplot(4,1,4), ylabel('COV');
    subplot(4,1,4), axis([1 length(cov_s) 0.3 0.69]);
    
% cd into the directory in which I can save plots, then save each plot
    % in a loop
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/outliers';
    saveas(h,sprintf('FIG%da.jpg',z));
    
    
x = z+100  

% specify the file into a variable to later save the plots in a loop
k = figure(z);


set(k, 'Visible', 'off');
% mrs = min_range_spatial + 30
    subplot(4,1,1), plot(all_val_s);
    subplot(4,1,1), title('Max Range Within Each Volume (Spatial)');
    subplot(4,1,1), xlabel('Volume');
    subplot(4,1,1), ylabel('Range');
    subplot(4,1,1), axis([1 length(all_val_s) 50 467]);
    
    subplot(4,1,2), plot(all_val_t);
    subplot(4,1,2), title('Max Range Within Each Slice (Temporal)');
    subplot(4,1,2), xlabel('Slice');
    subplot(4,1,2), ylabel('Range');
    subplot(4,1,2), axis([1 length(all_val_t) -5 60]);
%     colorbar;
%     zzz = max_shift_spatial + 3;
%     zz = zzz - 18
    subplot(4,1,3), plot(max_sh_s);
    subplot(4,1,3), title('Max Range Slice to Slice (Spatial)');
    subplot(4,1,3), xlabel('Volume');
    subplot(4,1,3), ylabel('Range');
    subplot(4,1,3), axis([1 length(max_sh_s) 15 110]);
    
    subplot(4,1,4), plot(max_sh_t);
    subplot(4,1,4), title('Max Range Volume to Volume (Temporal)');
    subplot(4,1,4), xlabel('Slice');
    subplot(4,1,4), ylabel('Range');
    subplot(4,1,4), axis([1 length(max_sh_t) -5 60]);
%     colorbar;

% %     subplot(5,1,5), imagesc(slicemean_fft(:,2:(length(slicemean_fft)-1)));
% %     subplot(5,1,5), axis([1 50 1 size(slicemean_fft,1)]);
% %     subplot(5,1,5), title('Fast Fourier Transform of above');
% %     subplot(5,1,5), xlabel('Number of cycles in timecourse');
% %     subplot(5,1,5), ylabel('slice');
% %     colorbar;

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/outliers';
    saveas(k,sprintf('FIG%db.jpg',z));
    
end

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/outliers';

save results results;
colNames2 = {'ID','max_range_temporal','max_range_spatial','max_shift_temporal','max_shift_spatial','max_cov_temporal','min_cov_spatial','mean_signal'};
table_results = array2table(results,'VariableNames',colNames2);
save table_results table_results;