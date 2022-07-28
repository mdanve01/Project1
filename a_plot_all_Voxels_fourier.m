% enter the name of the matlab script below, followed by (subject_number)
% function a_plot_all_Voxels_fourier;

addpath /usr/local/apps/psycapps/spm/spm12-r7487;
spm_get_defaults('mat.format','-v7.3');
% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/fourier1/CC110033_fourier_test';
first_spm = load('SPM.mat');

% load the 7 functions
bfs = first_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window = first_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec = length(bfs) ./ window;

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';
mask.m1 = niftiread('f_m1');
mask.a1 = niftiread('f_a1');
mask.v1 = niftiread('f_v1');
mask.ce = niftiread('f_cer');
mask.pf = niftiread('f_fp1');

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

mask.brain = niftiread('f_all');

% load hrfc data
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/hrfc';
mask.hrfc = niftiread('h_all.nii');
hrfc.one = spm_vol('beta_0001.nii');
[hrfc.a,hrfc.XYZ]=spm_read_vols(hrfc.one);

total_run(1,1:162) = 0;
betas(1,1:7) = 0;
% cycle through the beta arrays
for first = 1:length(four.a(:,1,1));
    for second = 1:length(four.a(1,:,1));
        for third = 1:length(four.a(1,1,:));
            % make a run for each function, multiplying the function by the
            % beta value
            if mask.brain(first,second,third) > 0 & mask.hrfc(first,second,third) > 0;
            bas.a1 = bfs(:,1) .* four.a(first,second,third);
            bas.b1 = bfs(:,2) .* four.b(first,second,third);
            bas.c1 = bfs(:,3) .* four.c(first,second,third);
            bas.d1 = bfs(:,4) .* four.d(first,second,third);
            bas.e1 = bfs(:,5) .* four.e(first,second,third);
            bas.f1 = bfs(:,6) .* four.f(first,second,third);
            bas.g1 = bfs(:,7) .* four.g(first,second,third);
            % sum these to create a single function
            sum_all = bas.a1 + bas.b1 + bas.c1 + bas.d1 + bas.e1 + bas.f1 + bas.g1;

            clear bas

            clear m
            m = length(betas(:,1)) + 1;
            betas(m,1) = four.a(first,second,third);
            betas(m,2) = four.b(first,second,third);
            betas(m,3) = four.c(first,second,third);
            betas(m,4) = four.d(first,second,third);
            betas(m,5) = four.e(first,second,third);
            betas(m,6) = four.f(first,second,third);
            betas(m,7) = four.g(first,second,third);

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


            total_run(n,1:147) = sum_all;

            % if we are looking at a positive function (max pos > max
            % neg)
            if hrfc.a(first,second,third) > 0;
                try
                    % find the peak latency, peak amplitude and fwhm.
                    % Look for the max peak with a prominence eceeding
                    % the threshold. Use this as peak amp
                    [PKS,LOCS,widths] = findpeaks(sum_all,'MinPeakProminence',thresh1,'WidthReference','halfheight');
                    total_run(n,148) = LOCS(find(PKS == max(PKS)))./sec;
                    total_run(n,149) = widths(find(PKS == max(PKS)))./sec;
                    total_run(n,150) = PKS(find(PKS == max(PKS)));
                    total_run(n,151) = length(PKS);
                    total_run(n,162) = 1;
                    
                    % checks for mismatches between max value and max peak
                    if total_run(n,150) ~= max(sum_all);
                        issue(n) = 999;
                    end

                    if length(PKS) > 1;
                        total_run(n,162) = 2;
                    end
                catch

                    total_run(n,148:150) = 999;
                    total_run(n,162) = 0;
                end

%                     alternatively if the negative peak is greater than
%                     the positive, find the max amplitude, then use this
%                     as the pak of interest.
            else if hrfc.a(first,second,third) < 0;  
                    try
                        clear PKS
                        clear LOCS
                        clear widths
                        [PKS,LOCS,widths] = findpeaks(-sum_all,'MinPeakProminence',thresh2,'WidthReference','halfheight');
                        total_run(n,148) = LOCS(find(PKS == max(PKS)))./sec;
                        total_run(n,149) = widths(find(PKS == max(PKS)))./sec;
                        total_run(n,150) = PKS(find(PKS == max(PKS)));
                        total_run(n,151) = length(PKS);
                        total_run(n,162) = -1;
                        
                        % checks for mismatches between max value and max peak
                        if total_run(n,150) ~= max(-sum_all);
                            issue(n) = 999;
                        end

                        if length(PKS) > 1;
                            total_run(n,162) = -2;
                        end
                    catch
                        total_run(n,148:151) = 999;
                        total_run(n,162) = 0;
                    end
                end
            end





            % also save these at the end of the summed run
            total_run(n,152) = first;
            total_run(n,153) = second;
            total_run(n,154) = third;
            total_run(n,155) = four.a(first,second,third);
            total_run(n,156) = four.b(first,second,third);
            total_run(n,157) = four.c(first,second,third);
            total_run(n,158) = four.d(first,second,third);
            total_run(n,159) = four.e(first,second,third);
            total_run(n,160) = four.f(first,second,third);
            total_run(n,161) = four.g(first,second,third);
            
            if mask.m1(first,second,third) > 0;
                total_run(n,163) = 1;
            elseif mask.a1(first,second,third) > 0;
                total_run(n,163) = 2;
            elseif mask.v1(first,second,third) > 0;
                total_run(n,163) = 3;
            elseif mask.ce(first,second,third) > 0;
                total_run(n,163) = 4;
            elseif mask.pf(first,second,third) > 0;
                total_run(n,163) = 5;
            else total_run(n,163) = 0;
            end



            clear sum_all
            end
        end
    end
end
         

total_run2 = total_run(2:length(total_run(:,1)),:);
betas2 = betas(2:length(betas(:,1)),:);

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/ROIs';
save all_fourier total_run2
save all_fourier_betas betas2

% end
