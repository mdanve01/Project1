% enter the name of the matlab script below, followed by (subject_number)
function a_plot_all_Voxels_hrftd_TPM_v3;

addpath /usr/local/apps/psycapps/spm/spm12-r7487;

% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf_td1/CC110033_hrf_td_test';
first_spm = load('SPM.mat');

% load the 3 functions
bfs = first_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window = first_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec = length(bfs) ./ window;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrftd';
one = spm_vol('beta_0001.nii');
[a,XYZ1]=spm_read_vols(one);

two = spm_vol('beta_0002.nii');
[b,XYZ2]=spm_read_vols(two);

three = spm_vol('beta_0003.nii');
[c,XYZ3]=spm_read_vols(three);

brain = niftiread('htd_all.nii');

% load hrfc data
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrfc';
hrfc = niftiread('h_all.nii');
one2 = spm_vol('beta_0001.nii');
[a_c,XYZ_c]=spm_read_vols(one2);


% load fourier data
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';
fourier = niftiread('f_all.nii');

% load GM template
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels';
mask = niftiread('old_gm.nii');


total_run(1,1:272) = 0;
betas(1,1:3) = 0;

% cycle through the beta arrays
for first = 1:length(a(1,1,:));
    for second = 1:length(a(1,:,1));
        for third = 1:length(a(:,1,1));
            % make a run for each function, multiplying the function by the
            % beta value
            if mask(first,second,third) > 0.5;
                % only look at shared significant voxels
                if brain(first,second,third) > 0 & hrfc(first,second,third) > 0;
                    a1 = bfs(:,1) .* a(first,second,third);
                    b1 = bfs(:,2) .* b(first,second,third);
                    c1 = bfs(:,3) .* c(first,second,third);
                    % sum these to create a single function
                    sum_all = a1 + b1 + c1;

                    clear a1
                    clear b1
                    clear c1

                    clear m
                    m = length(betas(:,1)) + 1;
                    betas(m,1) = a(first,second,third);
                    betas(m,2) = b(first,second,third);
                    betas(m,3) = c(first,second,third);

                    % determine which cycle number we are on and create an
                    % array of the summed functions
                    n = length(total_run(:,1)) + 1;


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

                    % if we are looking at a positive function (defined by
                    % HRFc being positively weighted)
                    if a_c(first,second,third) > 0;
                        try
                            % find the peak latency, peak amplitude and fwhm.
                            % Look for the max peak with a prominence eceeding
                            % the threshold. Use this as peak amp
                            [PKS,LOCS,widths] = findpeaks(sum_all,'MinPeakProminence',thresh1,'WidthReference','halfheight');
                            if max(PKS) ~= max(sum_all);
                                total_run(n,272) = 999;
                            else
                                total_run(n,272) = 1;
                            end
                            total_run(n,261) = LOCS(find(PKS == max(PKS)))./sec;
                            total_run(n,262) = widths(find(PKS == max(PKS)))./sec;
                            total_run(n,263) = PKS(find(PKS == max(PKS)));
                            total_run(n,264) = length(PKS);
                            total_run(n,271) = 1;
%                             % new addition
%                             total_run(n,272) = sum_all(LOCS(loc_max));
%                             total_run(n,273) = max(-sum_all(LOCS(loc_max):260));
%                             total_run(n,274) = total_run(n,273) ./ total_run(n,272);
%                             clear one_pc
%                             one_pc = total_run(n,272) ./ 100;
%                             clear rise
%                             rise = find(sum_all > (total_run(n,272) ./ 2) - one_pc,1);
%                             clear fall
%                             fall = find(sum_all(rise:260) < (total_run(n,272) ./ 2) - one_pc,1);
%                             total_run(n,275) = fall ./ sec;
                            if length(PKS) > 1;
                                total_run(n,271) = 2;
                            end
                        catch

                            total_run(n,261:264) = 999;
                            total_run(n,271) = 0;
                        end
    %                     alternatively if the HRFc model finds a negative
    %                     beta
                    else if a_c(first,second,third) < 0;  
                            try
                                clear PKS
                                clear LOCS
                                clear widths
                                [PKS,LOCS,widths] = findpeaks(-sum_all,'MinPeakProminence',thresh2,'WidthReference','halfheight');
                                if max(PKS) ~= max(-sum_all);
                                    total_run(n,272) = 999;
                                else
                                    total_run(n,272) = 1;
                                end
                                total_run(n,261) = LOCS(find(PKS == max(PKS)))./sec;
                                total_run(n,262) = widths(find(PKS == max(PKS)))./sec;
                                total_run(n,263) = PKS(find(PKS == max(PKS)));
                                total_run(n,264) = length(PKS);
                                total_run(n,271) = -1;
% %                                 new addition
% %                                 total_run(n,272) = -sum_all(LOCS(loc_max));
% %                                 total_run(n,273) = max(sum_all(LOCS(loc_max):260));
% %                                 total_run(n,274) = total_run(n,273) ./ total_run(n,272);
% %                                 clear one_pc
% %                                 one_pc = total_run(n,272) ./ 100;
% %                                 clear rise
% %                                 rise = find(-sum_all > (total_run(n,272) ./ 2) - one_pc,1);
% %                                 clear fall
% %                                 fall = find(-sum_all(rise:260) < (total_run(n,272) ./ 2) - one_pc,1);
% %                                 total_run(n,275) = fall ./ sec;
                                if length(PKS) > 1;
                                    total_run(n,271) = -2;
                                end
                            catch
                                total_run(n,261:264) = 999;
                                total_run(n,271) = 0;
                            end
                        end
                    end
                    
                    
                                   
                   
                        
                % also save these at the end of the summed run
                total_run(n,265) = first;
                total_run(n,266) = second;
                total_run(n,267) = third;
                total_run(n,268) = a(first,second,third);
                total_run(n,269) = b(first,second,third);
                total_run(n,270) = c(first,second,third);
                end
            end
        end
    end
end

          

                    
                    
                    
clear sum_all
                


total_run2 = total_run(2:length(total_run(:,1)),:);
betas2 = betas(2:length(betas(:,1)),:);

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';
save GM_HRFtd_v6 total_run2
save beta_GM_HRFtd_v6 betas2

end
