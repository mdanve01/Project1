% % enter the name of the matlab script below, followed by (subject_number)
% function create_ANOVA_data;

addpath /usr/local/apps/psycapps/spm/spm12-r7487;
spm_get_defaults('mat.format','-v7.3');

% FOURIER

% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/fourier1/CC110033_fourier_test';
first_spm = load('SPM.mat');

% load the 7 functions
bfs = first_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window = first_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec = length(bfs) ./ window;

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

brain = niftiread('f_all.nii');

% HRFtd
% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf_td1/CC110033_hrf_td_test';
second_spm = load('SPM.mat');

% load the 3 functions
bfs_h = second_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window_h = second_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec_h = length(bfs_h) ./ window_h;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd';
one_h = spm_vol('beta_0001.nii');
[a_h,XYZ1_h]=spm_read_vols(one_h);

two_h = spm_vol('beta_0002.nii');
[b_h,XYZ2_h]=spm_read_vols(two_h);

three_h = spm_vol('beta_0003.nii');
[c_h,XYZ3_h]=spm_read_vols(three_h);

brain_h = niftiread('htd_all.nii');

% load hrfc data
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrfc';
hrfc = niftiread('h_all.nii');
one = spm_vol('beta_0001.nii');
[a_c,XYZ_c]=spm_read_vols(one);

% GM template
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels';
mask = niftiread('old_gm.nii');

total_run(1,1:155) = 0;
% cycle through the beta arrays
for first = 1:length(a(:,1,1));
    for second = 1:length(a(1,:,1));
        for third = 1:length(a(1,1,:));
            % make a run for each function, multiplying the function by the
            % beta value
            if mask(first,second,third) > 0.5;
                if brain(first,second,third) > 0 & brain_h(first,second,third) > 0 & hrfc(first,second,third) > 0;
                    
                    % fourier
                    a1 = bfs(:,1) .* a(first,second,third);
                    b1 = bfs(:,2) .* b(first,second,third);
                    c1 = bfs(:,3) .* c(first,second,third);
                    d1 = bfs(:,4) .* d(first,second,third);
                    e1 = bfs(:,5) .* e(first,second,third);
                    f1 = bfs(:,6) .* f(first,second,third);
                    g1 = bfs(:,7) .* g(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1 + d1 + e1 + f1 + g1;

                    % HRFtd
                    a1_h = bfs_h(:,1) .* a_h(first,second,third);
                    b1_h = bfs_h(:,2) .* b_h(first,second,third);
                    c1_h = bfs_h(:,3) .* c_h(first,second,third);
                    sum_all_h = a1_h + b1_h + c1_h;

                    clear a1
                    clear b1
                    clear c1
                    clear d1
                    clear e1
                    clear f1
                    clear g1
                    clear a1_h
                    clear b1_h
                    clear c1_h

                    % determine which cycle number we are on and create an
                    % array of the summed functions
                    n = length(total_run(:,1)) + 1;

                    clear t1
                    clear thresh2
                    clear thresh1

                    % fourier
                    % set a threshold for min peak prominence, set out as 50%
                    % of the maximum or minimum value, whichever is greater
                    t1(1) = max(sum_all);
                    t1(2) = max(-sum_all);
                    thresh1 = t1(1) .* 0.25;
                    thresh2 = t1(2) .* 0.25;

                    clear PKS
                    clear LOCS
                    clear widths


                    total_run(n,1:147) = sum_all;

                    % if we are looking at a positive function (max pos > max
                    % neg)
                    if a_c(first,second,third) > 0;
                        try
                            % find the peak latency, peak amplitude and fwhm.
                            % Look for the max peak with a prominence eceeding
                            % the threshold. Use this as peak amp
                            [PKS,LOCS,widths] = findpeaks(sum_all,'MinPeakProminence',thresh1,'WidthReference','halfheight');
                            total_run(n,148) = LOCS(find(PKS == max(PKS)))./sec;
                            total_run(n,149) = widths(find(PKS == max(PKS)))./sec;
                            total_run(n,150) = PKS(find(PKS == max(PKS)));
                            total_run(n,151) = length(PKS);
                            total_run(n,152) = 1;
                            if length(PKS) > 1;
                                total_run(n,152) = 2;
                            end
                        catch

                            total_run(n,148:150) = 999;
                            total_run(n,152) = 0;
                        end
                     %alternatively if the negative peak is greater than
    %                     the positive, find the max amplitude, then use this
    %                     as the pak of interest.
                    else if a_c(first,second,third) < 0;
                            try
                                clear PKS
                                clear LOCS
                                clear widths
                                [PKS,LOCS,widths] = findpeaks(-sum_all,'MinPeakProminence',thresh2,'WidthReference','halfheight');
                                total_run(n,148) = LOCS(find(PKS == max(PKS)))./sec;
                                total_run(n,149) = widths(find(PKS == max(PKS)))./sec;
                                total_run(n,150) = PKS(find(PKS == max(PKS)));
                                total_run(n,151) = length(PKS);
                                total_run(n,152) = -1;
                                if length(PKS) > 1;
                                    total_run(n,152) = -2;
                                end
                            catch
                                total_run(n,148:151) = 999;
                                total_run(n,152) = 0;
                            end
                        end
                    end
                    
                    
                    clear t1_h
                    clear thresh1_h
                    clear thresh2_h

                    % HRFtd
                    % set a threshold for min peak prominence, set out as 50%
                    % of the maximum or minimum value, whichever is greater
                    t1_h(1) = max(sum_all_h);
                    t1_h(2) = max(-sum_all_h);
                    thresh1_h = t1_h(1) .* 0.25;
                    thresh2_h = t1_h(2) .* 0.25;

                    clear PKS
                    clear LOCS
                    clear widths


                    total_run_h(n,1:260) = sum_all_h;

                    % if we are looking at a positive function (max pos > max
                    % neg)
                    if a_c(first,second,third) > 0;
                        try
                            % find the peak latency, peak amplitude and fwhm.
                            % Look for the max peak with a prominence eceeding
                            % the threshold. Use this as peak amp
                            [PKS,LOCS,widths] = findpeaks(sum_all_h,'MinPeakProminence',thresh1_h,'WidthReference','halfheight');

                            total_run_h(n,261) = LOCS(find(PKS == max(PKS)))./sec_h;
                            total_run_h(n,262) = widths(find(PKS == max(PKS)))./sec_h;
                            total_run_h(n,263) = PKS(find(PKS == max(PKS)));
                            total_run_h(n,264) = length(PKS);
                            total_run_h(n,265) = 1;
                            if length(PKS) > 1;
                                total_run_h(n,265) = 2;
                            end
                        catch

                            total_run_h(n,261:263) = 999;
                            total_run_h(n,265) = 0;
                        end
                    
                    else if a_c(first,second,third) < 0;
                            try
                                clear PKS
                                clear LOCS
                                clear widths
                                [PKS,LOCS,widths] = findpeaks(-sum_all_h,'MinPeakProminence',thresh2_h,'WidthReference','halfheight');

                                total_run_h(n,261) = LOCS(find(PKS == max(PKS)))./sec_h;
                                total_run_h(n,262) = widths(find(PKS == max(PKS)))./sec_h;
                                total_run_h(n,263) = PKS(find(PKS == max(PKS)));
                                total_run_h(n,264) = length(PKS);
                                total_run_h(n,265) = -1;
                                if length(PKS) > 1;
                                    total_run_h(n,265) = -2;
                                end
                            catch
                                total_run_h(n,261:263) = 999;
                                total_run_h(n,265) = 0;
                            end
                        end
                    end
   
                % also save these at the end of the summed run
                total_run(n,153) = first;
                total_run(n,154) = second;
                total_run(n,155) = third;
                total_run(n,156) = a(first,second,third);
                total_run(n,157) = b(first,second,third);
                total_run(n,158) = c(first,second,third);
                total_run(n,159) = d(first,second,third);
                total_run(n,160) = e(first,second,third);
                total_run(n,161) = f(first,second,third);
                total_run(n,162) = g(first,second,third);
                total_run_h(n,266) = first;
                total_run_h(n,267) = second;
                total_run_h(n,268) = third;
                total_run_h(n,269) = a_h(first,second,third);
                total_run_h(n,270) = b_h(first,second,third);
                total_run_h(n,271) = c_h(first,second,third);

                    
                    
                    
                clear sum_all
                clear sum_all_h
                clear n
                end
            end
        end
    end
end
         

total_run2 = total_run(2:length(total_run(:,1)),:);
total_run2_h = total_run_h(2:length(total_run_h(:,1)),:);

final_pos(1,1:8) = 0;
final_neg(1,1:8) = 0;

clear m
for m = 1:length(total_run2(:,1));
    if total_run2(m,152) > 0 & total_run2_h(m,265) > 0;
        clear leng
        leng = length(final_pos(:,1))+1;
        final_pos(leng,1) = total_run2(m,148);
        final_pos(leng,3) = total_run2(m,149);
        final_pos(leng,5) = total_run2_h(m,261);
        final_pos(leng,7) = total_run2_h(m,262);
    else if total_run2(m,152) < 0 & total_run2_h(m,265) < 0;
            clear leng2
            leng2 = length(final_neg(:,1))+1;
        final_neg(leng2,1) = total_run2(m,148);
        final_neg(leng2,3) = total_run2(m,149);
        final_neg(leng2,5) = total_run2_h(m,261);
        final_neg(leng2,7) = total_run2_h(m,262);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

final_pos2 = final_pos(2:length(final_pos(:,1)),:);
final_neg2 = final_neg(2:length(final_neg(:,1)),:);

final_pos2(:,2) = final_pos2(:,1) - final_pos2(:,5);
final_pos2(:,4) = final_pos2(:,3) - final_pos2(:,7);

final_neg2(:,2) = final_neg2(:,1) - final_neg2(:,5);
final_neg2(:,4) = final_neg2(:,3) - final_neg2(:,7);

figure(300);
subplot(4,1,1); histogram(final_pos2(:,2));
subplot(4,1,2); histogram(final_pos2(:,4));
subplot(4,1,3); histogram(final_neg2(:,2));
subplot(4,1,4); histogram(final_neg2(:,4));

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons';
save GM_pos_NOREM_all final_pos2
save GM_neg_NOREM_all final_neg2
save fourier_NOREM_all total_run2
save hrftd_NOREM_all total_run2_h

figure(201);
subplot(6,2,9);histogram(final_pos2(:,2),'BinWidth',0.095,'facecolor','r');
xlabel('Peak Latency Difference (secs)');
ylabel('Number of Voxels');
title('Positive Function');
figure(201);
subplot(6,2,10);histogram(final_pos2(:,4),'BinWidth',0.03,'facecolor','g');
xlabel('FWHM Difference (secs)');
ylabel('Number of Voxels');
title('Positive Function');
figure(201);
subplot(6,2,11);histogram(final_neg2(:,2),'BinWidth',0.40,'facecolor','b');
xlabel('Peak Latency Difference (secs)');
ylabel('Number of Voxels');
title('Negative Function');
figure(201);
subplot(6,2,12);histogram(final_neg2(:,4),'BinWidth',0.16,'facecolor','y');
xlabel('FWHM Difference (secs)');
ylabel('Number of Voxels');
title('Negative Function');

thresh = 0.05 ./ 12;

% compare within subject
clear p
clear h
clear STATS
[p,h,STATS] = signrank(final_pos2(:,1),final_pos2(:,5),'alpha',thresh);
results(1,1) = p;
results(2,1) = h;
results(3,1) = median(final_pos2(:,1));
results(4,1) = median(final_pos2(:,5));
results(5,1) = range(final_pos2(:,1));
results(6,1) = range(final_pos2(:,5));
results(7,1) = STATS.zval
clear p
clear h
clear STATS
[p,h,STATS] = signrank(final_pos2(:,3),final_pos2(:,7),'alpha',thresh);
results(1,2) = p;
results(2,2) = h;
results(3,2) = median(final_pos2(:,3));
results(4,2) = median(final_pos2(:,7));
results(5,2) = range(final_pos2(:,3));
results(6,2) = range(final_pos2(:,7));
results(7,2) = STATS.zval
clear p
clear h
clear STATS
[p,h,STATS] = signrank(final_neg2(:,1),final_neg2(:,5),'alpha',thresh);
results(1,3) = p;
results(2,3) = h;
results(3,3) = median(final_neg2(:,1));
results(4,3) = median(final_neg2(:,5));
results(5,3) = range(final_neg2(:,1));
results(6,3) = range(final_neg2(:,5));
results(7,3) = STATS.zval
clear p
clear h
clear STATS
[p,h,STATS] = signrank(final_neg2(:,3),final_neg2(:,7),'alpha',thresh);
results(1,4) = p;
results(2,4) = h;
results(3,4) = median(final_neg2(:,3));
results(4,4) = median(final_neg2(:,7));
results(5,4) = range(final_neg2(:,3));
results(6,4) = range(final_neg2(:,7));
results(7,4) = STATS.zval

save GM_results_four_hrftd_comparison_NOREM_all results
