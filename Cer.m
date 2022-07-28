addpath /usr/local/apps/psycapps/spm/spm12-r7487;

% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf1/CC110033_hrf_test';
first_spm = load('SPM.mat');

% load the 3 functions
bfs = first_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window = first_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec = length(bfs) ./ window;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrfc';
one = spm_vol('beta_0001.nii');
[a,XYZ1]=spm_read_vols(one);
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrfc';
brain = niftiread('h_cer.nii');



total_run(1,1:269) = 0;
betas(1,1:3) = 0;

% cycle through the beta arrays
for first = 1:length(a(1,1,:));
    for second = 1:length(a(1,:,1));
        for third = 1:length(a(:,1,1));
            % make a run for each function, multiplying the function by the
            % beta value. look only at GM locations, and then register details only if
            % the participant has a significant voxel here
            if brain(first,second,third) > 0;
               sum_all = bfs .* a(first,second,third);


                clear m
                m = length(betas(:,1)) + 1;
                betas(m,1) = a(first,second,third);




                n = length(total_run(:,1)) + 1


                clear t1
                clear thresh2
                clear thresh1
                % set a threshold for min peak prominence, set out as 50%
                % of the maximum or minimum value, whichever is greater
                t1(1) = max(sum_all);
                t1(2) = max(-sum_all);
                thresh1 = t1(1) .* 0.25;
                thresh2 = t1(2) .* 0.25;

                clear PKS
                clear LOCS
                clear widths


                total_run(n,1:260) = sum_all;

                % if we are looking at a positive function (max pos > max
                % neg)
                if a(first,second,third) > 0;
                    try
                        % find the peak latency, peak amplitude and fwhm.
                        % Look for the max peak with a prominence eceeding
                        % the threshold. Use this as peak amp
                        [PKS,LOCS,widths] = findpeaks(sum_all,'MinPeakProminence',thresh1,'WidthReference','halfheight');
                        
                        total_run(n,261) = LOCS(find(PKS == max(PKS)))./sec;
                        total_run(n,262) = widths(find(PKS == max(PKS)))./sec;
                        total_run(n,263) = PKS(find(PKS == max(PKS)));
                        total_run(n,264) = length(PKS);
                        total_run(n,269) = 1;
                        if length(PKS) > 1;
                            total_run(n,269) = 2;
                        end
                    catch

                        total_run(n,261:264) = 999;
                        total_run(n,269) = 0;
                    end
%                         alternatively if the negative peak is greater than
%                         the positive, find the max amplitude, then use this
%                         as the pak of interest.
                else if a(first,second,third) < 0;  
                        try
                            clear PKS
                            clear LOCS
                            clear widths
                            [PKS,LOCS,widths] = findpeaks(-sum_all,'MinPeakProminence',thresh2,'WidthReference','halfheight');
                           
                            total_run(n,261) = LOCS(find(PKS == max(PKS)))./sec;
                            total_run(n,262) = widths(find(PKS == max(PKS)))./sec;
                            total_run(n,263) = PKS(find(PKS == max(PKS)));
                            total_run(n,264) = length(PKS);
                            total_run(n,269) = -1;
                            if length(PKS) > 1;
                                total_run(n,269) = -2;
                            end
                        catch
                            total_run(n,261:264) = 999;
                            total_run(n,269) = 0;
                        end
                    end
                end





                % also save these at the end of the summed run
                total_run(n,265) = first;
                total_run(n,266) = second;
                total_run(n,267) = third;
                total_run(n,268) = a(first,second,third);

                clear sum_all
            end
        end
    end
end
                
total_run2 = total_run(2:length(total_run(:,1)),:);
betas2 = betas(2:length(betas(:,1)),:);

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/ROIs_HRFc';
save GM_HRFc_Cer total_run2

