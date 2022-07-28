
addpath /usr/local/apps/psycapps/spm/spm12-r7487
epi = importdata('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways/epi_files.txt');
num_sub = 645;


for z = 1:num_sub
    
    line = epi{z};
    path = line(1:83);
    sub = line(84:107);
    ID2 = line(90:95);
    ID = str2num(ID2);

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

% repeats normalising each volume
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

% calculates the coefficient of variation accross volumes at each slice
clear xnx
for xnx = 1:length(slicemean(1,:));
    cov_t(xnx) = std(slicemean(:,xnx))./mean(slicemean(:,xnx));
end
max_cov_t = max(cov_t);

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

% does as per above, but here looks at each volume (accross slices), then calculates the
% maximum range accross slices
clear nxn
for nxn = 1:length(slicemean(:,1));
all_val_s(nxn) = max(slicemean(nxn,:)) - min(slicemean(nxn,:));
end
max_range_spatial = max(all_val_s);
min_range_spatial = min(all_val_s);

% calculates the coefficient of variation accross slices at each volume
clear nxn
for nxn = 1:length(slicemean(:,1));
cov_s(nxn) = std(slicemean(nxn,:))./mean(slicemean(nxn,:));
end
max_cov_s = max(cov_s);

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
h = figure(z);


set(h, 'Visible', 'off');
% % % %     subplot(5,1,1), imagesc(slicemean');
% % % %     subplot(5,1,1), title('signal intensity (raw)');
% % % %     subplot(5,1,1), xlabel('volume');
% % % %     subplot(5,1,1), ylabel('slice');
% % % %     colorbar;
% % % %     %subplot(3,1,2), axis([1 length(A_norm) min(min(A_norm)) max(max(A_norm))])
% % % %     
% % % %     subplot(5,1,2), plot(slicemean_mean);
% % % %     subplot(5,1,2), title('mean across volumes');
% % % %     subplot(5,1,2), xlabel('slice');
% % % %     subplot(5,1,2), ylabel('mean');
% % % %     %subplot(5,1,1), axis([1 length(C) min(C) max(C)])
% % % %     colorbar;
    
    subplot(5,1,1), plot(slicemean_std_slice);
    subplot(5,1,1), title('standard deviation of each slice');
    subplot(5,1,1), xlabel('slice');
    subplot(5,1,1), ylabel('std');
    subplot(5,1,1), axis([1 length(slicemean_std_slice) -5 20]);
%     subplot(5,1,1), axis([1 length(B) min(B) max(B)])    
%     colorbar;
    
    subplot(5,1,2), imagesc(slicemean_norm_vol);
    subplot(5,1,2), title('signal intensity (slice mean corrected)');
    subplot(5,1,2), xlabel('volume');
    subplot(5,1,2), ylabel('slice');
    colorbar;
    %subplot(3,1,2), axis([1 length(A_norm) min(min(A_norm)) max(max(A_norm))])
    
    subplot(5,1,3), imagesc(slicemean_fft(:,2:(length(slicemean_fft)-1)));
    subplot(5,1,3), axis([1 50 1 size(slicemean_fft,1)]);
    subplot(5,1,3), title('Fast Fourier Transform of above');
    subplot(5,1,3), xlabel('Number of cycles in timecourse');
    subplot(5,1,3), ylabel('slice');
    colorbar;

    subplot(5,1,4), plot(all_val_s);
    subplot(5,1,4), title('Max Range Within Each Volume (Spatial)');
    subplot(5,1,4), xlabel('Slice');
    subplot(5,1,4), ylabel('Max Range');
    subplot(5,1,4), axis([1 length(all_val_s) min_range_spatial max_range_spatial]);
    
    subplot(5,1,5), plot(all_val_t);
    subplot(5,1,5), title('Max Range Within Each Slice (Temporal)');
    subplot(5,1,5), xlabel('Slice');
    subplot(5,1,5), ylabel('Max Range');
    subplot(5,1,5), axis([1 length(all_val_t) -5 50]);
%     colorbar;
    % cd into the directory in which I can save plots, then save each plot
    % in a loop
    cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range/all_fig';
    saveas(h,sprintf('FIG%d.jpg',z));
    
    
end

% saves key files
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range';
save results results;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% IF THE ORIGINAL FILE HAS BEEN MADE START FROM HERE %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

addpath /usr/local/apps/psycapps/spm/spm12-r7487
epi = importdata('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways/epi_files.txt');
num_sub = 645;

% loads key files
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range';
load results;

% creates boxplots for each variable
mrt = boxplot(results(:,2));
% finds the outlier values
outliers = findobj(mrt,'Tag','Outliers');
mrt_out = get(outliers,'YData');
% inverts the vector
mrt_out = mrt_out';
% looks in every outlier value, then accross every datapoint, and when it
% finds a match adds the participant number to the outlier folder (xxx_out)
for n = 1:length(mrt_out);
    for m = 1:length(results(:,2));
        if mrt_out(n,1) == results(m,2);
            mrt_out(n,2) = results(m,1);
        end
    end
end



mrs = boxplot(results(:,3));
outliers = findobj(mrs,'Tag','Outliers');
mrs_out = get(outliers,'YData');
mrs_out = mrs_out';
for n = 1:length(mrs_out);
    for m = 1:length(results(:,3));
        if mrs_out(n,1) == results(m,3);
            mrs_out(n,2) = results(m,1);
        end
    end
end

mst = boxplot(results(:,4));
outliers = findobj(mst,'Tag','Outliers');
mst_out = get(outliers,'YData');
mst_out = mst_out';
for n = 1:length(mst_out);
    for m = 1:length(results(:,4));
        if mst_out(n,1) == results(m,4);
            mst_out(n,2) = results(m,1);
        end
    end
end

mss = boxplot(results(:,5));
outliers = findobj(mss,'Tag','Outliers');
mss_out = get(outliers,'YData');
mss_out = mss_out';
for n = 1:length(mss_out);
    for m = 1:length(results(:,5));
        if mss_out(n,1) == results(m,5);
            mss_out(n,2) = results(m,1);
        end
    end
end

mct = boxplot(results(:,6));
outliers = findobj(mct,'Tag','Outliers');
mct_out = get(outliers,'YData');
mct_out = mct_out';
for n = 1:length(mct_out);
    for m = 1:length(results(:,6));
        if mct_out(n,1) == results(m,6);
            mct_out(n,2) = results(m,1);
        end
    end
end

mcs = boxplot(results(:,7));
outliers = findobj(mcs,'Tag','Outliers');
mcs_out = get(outliers,'YData');
mcs_out = mcs_out';
for n = 1:length(mcs_out);
    for m = 1:length(results(:,7));
        if mcs_out(n,1) == results(m,7);
            mcs_out(n,2) = results(m,1);
        end
    end
end


% set threshold
thresh_val = 2.5

% generates a threshold of mean plus 3 stds for my results table
temp_mean = mean(results(:,2));
temp_std = std(results(:,2));
thresh_temp = temp_mean + (thresh_val.*temp_std);

spat_mean = mean(results(:,3));
spat_std = std(results(:,3));
thresh_spat = spat_mean + (thresh_val.*spat_std);

temp_mean_shift = mean(results(:,4));
temp_std_shift = std(results(:,4));
thresh_temp_shift = temp_mean_shift + (thresh_val.*temp_std_shift);

spat_mean_shift = mean(results(:,5));
spat_std_shift = std(results(:,5));
thresh_spat_shift = spat_mean_shift + (thresh_val.*spat_std_shift);

covt_mean = mean(results(:,6));
covt_std = std(results(:,6));
thresh_covt = covt_mean + (thresh_val.*covt_std);

covs_mean = mean(results(:,7));
covs_std = std(results(:,7));
thresh_covs = covs_mean + (thresh_val.*covs_std);

sig_mean = mean(results(:,8));
sig_std = std(results(:,8));
thresh_sig = sig_mean + (thresh_val.*sig_std);

% saves key files
% cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/';
% mkdir range;
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range';
save results results;


% saves histograms of the coefficients
figure(1000); histogram(results(:,2));
title('Maximum Range (temporal)')
xlabel('Range (maximum)');
ylabel('Number of participants');

figure(1001); histogram(results(:,3));
title('Maximum Range (spatial)')
xlabel('Range (maximum)');
ylabel('Number of participants');

figure(1002); histogram(results(:,4));
title('Maximum Shift (temporal)')
xlabel('Shift (maximum)');
ylabel('Number of participants');

figure(1003); histogram(results(:,5));
title('Maximum Shift (spatial)')
xlabel('Shift (maximum)');
ylabel('Number of participants');

figure(1004); histogram(results(:,6));
title('Maximum Cov (temporal)')
xlabel('COV (maximum)');
ylabel('Number of participants');

figure(1005); histogram(results(:,7));
title('Maximum Cov (spatial)')
xlabel('COV (maximum)');
ylabel('Number of participants');

figure(1006); histogram(results(:,8));
title('Mean Signal')
xlabel('Signal');
ylabel('Number of participants');

j = figure(1000);
saveas(j,'max_range_temp.jpg');
jj = figure(1001);
saveas(jj,'max_range_spat.jpg');
jjj = figure(1002);
saveas(jjj,'max_shift_temp.jpg');
l = figure(1003);
saveas(l,'max_shift_spat.jpg');
ll = figure(1004);
saveas(ll,'max_cov_temp.jpg');
lll = figure(1005);
saveas(lll,'max_cov_spat.jpg');
lj = figure(1006);
saveas(lj,'mean_signal.jpg');
% runs through all subjects, if their max range (temporal) is above the threshold it
% is saved into an outliers file, if not it goes into an included file
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,2) > thresh_temp;
        outliers_temp(loop,1) = ID4;
        outliers_temp(loop,2) = results(loop,2);
    else included_temp(loop,1) = ID4;
        included_temp(loop,2) = results(loop,2);
    end
end

% removes zero values
outliernew_temp = outliers_temp(outliers_temp(:,1)>0,:);
includednew_temp = included_temp(included_temp(:,1)>0,:);
% orders files in ascending order
outlier_files_temp = sortrows(outliernew_temp,1);
included_files_temp = sortrows(includednew_temp,1);

% repeats for temp shift values
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,4) > thresh_temp_shift;
        outliers_temp_shift(loop,1) = ID4;
        outliers_temp_shift(loop,2) = results(loop,4);
    else included_temp_shift(loop,1) = ID4;
        included_temp_shift(loop,2) = results(loop,4);
    end
end

% removes zero values
outliernew_temp_shift = outliers_temp_shift(outliers_temp_shift(:,1)>0,:);
includednew_temp_shift = included_temp_shift(included_temp_shift(:,1)>0,:);
% orders files in ascending order
outlier_files_temp_shift = sortrows(outliernew_temp_shift,1);
included_files_temp_shift = sortrows(includednew_temp_shift,1);

% same for spatial range
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,3) > thresh_spat;
        outliers_spat(loop,1) = ID4;
        outliers_spat(loop,2) = results(loop,3);
    else included_spat(loop,1) = ID4;
        included_spat(loop,2) = results(loop,3);
    end
end

% removes zero values
outliernew_spat = outliers_spat(outliers_spat(:,1)>0,:);
includednew_spat = included_spat(included_spat(:,1)>0,:);
% orders files in ascending order
outlier_files_spat = sortrows(outliernew_spat,1);
included_files_spat = sortrows(includednew_spat,1);

% repeats for spat shift values
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,5) > thresh_spat_shift;
        outliers_spat_shift(loop,1) = ID4;
        outliers_spat_shift(loop,2) = results(loop,5);
    else included_spat_shift(loop,1) = ID4;
        included_spat_shift(loop,2) = results(loop,5);
    end
end

% removes zero values
outliernew_spat_shift = outliers_spat_shift(outliers_spat_shift(:,1)>0,:);
includednew_spat_shift = included_spat_shift(included_spat_shift(:,1)>0,:);
% orders files in ascending order
outlier_files_spat_shift = sortrows(outliernew_spat_shift,1);
included_files_spat_shift = sortrows(includednew_spat_shift,1);


% repeats for spat shift values
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,6) > thresh_covt;
        outliers_covt_max(loop,1) = ID4;
        outliers_covt_max(loop,2) = results(loop,6);
    else included_covt_max(loop,1) = ID4;
        included_covt_max(loop,2) = results(loop,6);
    end
end

% removes zero values
outliernew_covt_max = outliers_covt_max(outliers_covt_max(:,1)>0,:);
includednew_covt_max = included_covt_max(included_covt_max(:,1)>0,:);
% orders files in ascending order
outlier_files_covt_max = sortrows(outliernew_covt_max,1);
included_files_covt_max = sortrows(includednew_covt_max,1);


% repeats for spat shift values
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,7) > thresh_covs;
        outliers_covs_max(loop,1) = ID4;
        outliers_covs_max(loop,2) = results(loop,7);
    else included_covs_max(loop,1) = ID4;
        included_covs_max(loop,2) = results(loop,7);
    end
end

% removes zero values
outliernew_covs_max = outliers_covs_max(outliers_covs_max(:,1)>0,:);
includednew_covs_max = included_covs_max(included_covs_max(:,1)>0,:);
% orders files in ascending order
outlier_files_covs_max = sortrows(outliernew_covs_max,1);
included_files_covs_max = sortrows(includednew_covs_max,1);

% repeats for mean signal values
for loop = 1:num_sub;
    line = epi{loop};
    ID3 = line(90:95);
    ID4 = str2num(ID3);
    if results(loop,8) > thresh_sig;
        outliers_sig(loop,1) = ID4;
        outliers_sig(loop,2) = results(loop,8);
    else included_sig(loop,1) = ID4;
        included_sig(loop,2) = results(loop,8);
    end
end

% removes zero values
outliernew_sig = outliers_sig(outliers_sig(:,1)>0,:);
includednew_sig = included_sig(included_sig(:,1)>0,:);
% orders files in ascending order
outlier_files_sig = sortrows(outliernew_sig,1);
included_files_sig = sortrows(includednew_sig,1);




% creates a grand file of all outliers, checking for duplicates and only
% adding if not present
grand_out = outlier_files_temp;

for aaa = 1:length(outlier_files_spat(:,1));
    if outlier_files_spat(aaa,1) ~= grand_out(:,1);
        nnn = length(grand_out(:,1)) + 1;
        grand_out(nnn,1) = outlier_files_spat(aaa,1);
        grand_out(nnn,2) = outlier_files_spat(aaa,2);
    end
end

for aaa = 1:length(outlier_files_spat_shift(:,1));
    if outlier_files_spat_shift(aaa,1) ~= grand_out(:,1);
        nnn = length(grand_out(:,1)) + 1;
        grand_out(nnn,1) = outlier_files_spat_shift(aaa,1);
        grand_out(nnn,2) = outlier_files_spat_shift(aaa,2);
    end
end

for aaa = 1:length(outlier_files_temp_shift(:,1));
    if outlier_files_temp_shift(aaa,1) ~= grand_out(:,1);
        % includes the below line to consistenly update the grand_out fie
        % to write to the next available line, starting at 1 beause its
        % original length is zero, so 0+1 = 1st row.
        nnn = length(grand_out(:,1)) + 1;
        grand_out(nnn,1) = outlier_files_temp_shift(aaa,1);
        grand_out(nnn,2) = outlier_files_temp_shift(aaa,2);
    end
end

for aaa = 1:length(outlier_files_covt_max(:,1));
    if outlier_files_covt_max(aaa,1) ~= grand_out(:,1);
        nnn = length(grand_out(:,1)) + 1;
        grand_out(nnn,1) = outlier_files_covt_max(aaa,1);
        grand_out(nnn,2) = outlier_files_covt_max(aaa,2);
    end
end

for aaa = 1:length(outlier_files_covs_max(:,1));
    if outlier_files_covs_max(aaa,1) ~= grand_out(:,1);
        nnn = length(grand_out(:,1)) + 1;
        grand_out(nnn,1) = outlier_files_covs_max(aaa,1);
        grand_out(nnn,2) = outlier_files_covs_max(aaa,2);
    end
end


% compares the grand out file to the boxplot derived outliers, adds a 1 to
% the num_xxx file every time it finds a match
    num_mrt = 0;
    num_mrs = 0;
    num_mst = 0;
    num_mss = 0;
    num_mct = 0;
    num_mcs = 0;


for m = 1:length(grand_out(:,1));   
    for n = 1:length(mrt_out);
        if grand_out(m,1) == mrt_out(n,2);
            num_mrt = num_mrt + 1;
        end
    end
    for n = 1:length(mrs_out);
        if grand_out(m,1) == mrs_out(n,2);
            num_mrs = num_mrs + 1;
        end
    end
    for n = 1:length(mst_out);
        if grand_out(m,1) == mst_out(n,2);
            num_mst = num_mst + 1;
        end
    end
    for n = 1:length(mss_out);
        if grand_out(m,1) == mss_out(n,2);
            num_mss = num_mss + 1;
        end
    end
    for n = 1:length(mct_out);
        if grand_out(m,1) == mct_out(n,2);
            num_mct = num_mct + 1;
        end
    end
    for n = 1:length(mcs_out);
        if grand_out(m,1) == mcs_out(n,2);
            num_mcs = num_mcs + 1;
        end
    end
end
% compares the length of the outlier file to the number of matches, to ascertain the number of new outliers found
not_caught_mrt = length(mrt_out(:,1)) - num_mrt;
not_caught_mrs = length(mrs_out(:,1)) - num_mrs;
not_caught_mst = length(mst_out(:,1)) - num_mst;
not_caught_mss = length(mss_out(:,1)) - num_mss;
not_caught_mct = length(mct_out(:,1)) - num_mct;
not_caught_mcs = length(mcs_out(:,1)) - num_mcs;
% sums the number of new outliers
total_new_outliers = not_caught_mrt + not_caught_mrs + not_caught_mst + not_caught_mss + not_caught_mct + not_caught_mcs;


%identifies included files
for aaa = 1:length(results);
    if results(aaa,1) ~= grand_out(:,1);
        grand_in3(aaa,1) = results(aaa,1);
        grand_in3(aaa,2) = 99999;
    end
end

% removes zero values
grand_in2 = grand_in3(grand_in3(:,1)>0,:);
% orders ascending
grand_in = sortrows(grand_in2,1);


% generates random numbers ranging from 1 to the number of included files,
% then uses these to randomly select control participants for the blind
% manual check
for check = 1:length(grand_out(:,1));
    xxx = length(grand_in(:,1));
    random = randi(xxx,1);
    control_list(check,1) = grand_in(random,1);
    control_list(check,2) = grand_in(random,2);
end

% puts the files together 
stack = [grand_out; control_list];

% randomises rows
stack(:,3) = rand(length(stack(:,1)),1);
stack_rand = sortrows(stack,3);

% saves the relevant files
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range';
save stack_rand stack_rand;
save grand_out grand_out
save grand_in grand_in
% save outlier_files outlier_files;
% save included_files included_files;

% adds titles to columns
colNames = {'ID','values','random_number'};
table_stack_rand = array2table(stack_rand,'VariableNames',colNames);
colNames2 = {'ID','max_range_temporal','max_range_spatial','max_shift_temporal','max_shift_spatial','max_covt','max_covs','mean_signal'};
table_results = array2table(results,'VariableNames',colNames2);


% saves the relevant files
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/QA/range';
save table_stack_rand table_stack_rand;
save table_results table_results;
