function lc_check_norm_via_mask_V3;

    disp('inside the main matlab function');
    disp('Processing Subject');


cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways';
% contians the loation of the mask for each p, mask shows us where in the
% scan the sanner identified brain tissue. tissue denoted as 1, non-tissue
% = 0
a = importdata('con_files_list_old.txt');
d = a{1};
cd(d);
% loads a single file to determine the 3D matrix size
c = niftiread('mask.nii');

% creates the first iteration of the new mask, based upon the first participant
mask = double(c);

% loops through ps, starting from the second
for full = 2:length(a);
    cd(a{full});
    rel_file = niftiread('mask.nii');
    % adds the values from each participant, at each voxel, to one another.
    % Set to double as otherwise is capped at 255
    rel_file = double(rel_file);
%     mask = double(mask);
    mask = mask + rel_file;
    clear rel_file;
end

% determines the length of the first second and third dimensions
for first = 1:length(mask(:,1,1));
    for second = 1:length(mask(1,:,1));
        for third = 1:length(mask(1,1,:));
            % calculates the mean value of each voxel in the new mask
            % template
            new_maska(first,second,third) = mask(first,second,third)./length(a);
            % determines any mean value above or equal to 0.5 to be a 1,
            % and below to be a zero, eassentially calculating the mode.
            if new_maska(first,second,third) >= 0.5;
                new_mask(first,second,third) = 1;
            else new_mask(first,second,third) = 0;
            end
        end
    end
end


cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/check_normalisation/first';
save mask mask;
save new_mask new_mask;

% looks at each subject, one at a time
for sub = 1:length(a);
    cd(a{sub});
    % loads their mask
    f = niftiread('mask.nii');
    for first = 1:length(f(:,1,1));
        for second = 1:length(f(1,:,1));
            for third = 1:length(f(1,1,:));
                % looks one voxel at a time, comparing to the value in the
                % standard mask. If an outlier (e.g. subject has tissue
                % where standard doesn't or vice versa) then adds 1 to the
                % error file, which is in the same 3D space. If no error,
                % adds a zero
                if f(first,second,third) ~= new_mask(first,second,third);
                    error(first,second,third) = 1;
                else error(first,second,third) = 0;
                end
            end
        end
    end
    % sums all the 1s for this subject, and adds to a results folder
    results(sub,1) = sum(sum(sum(error)));
    % creates a subject number for the relevant loop
    line = a{sub};
    name1 = line(71:76);
    name = str2num(name1)
    % adds the subject number to the results file
    results(sub,2) = name;
    clear name;
    clear line;
    clear f;
    clear error;
end

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/check_normalisation/first';
save results results;

% sets the threshold
thresh = 2.5;

% generates a histogram and the key stats/thresholds for the whole dataset
figure(1000);histogram(results(:,1));
title('Distribution of Total Deviation');
xlabel('Number of outlying voxels');
ylabel('Number of participants');
j = figure(1000);

hb = figure(1001);boxplot(results(:,1));
title('Distribution of Total Deviation');
ylabel('Number of outlying voxels');
jjj = figure(1001);

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/check_normalisation/first';
saveas(j,'Number_of_outlying_voxels_hist.jpg');
saveas(jjj,'Number_of_outlying_voxels_box.jpg');

med_results = median(results(:,1));
mean_results = mean(results(:,1));
std_results = std(results(:,1));
thresh_max = mean_results + (thresh.*std_results);
thresh_max2 = med_results + (thresh.*std_results);
% thresh_min = mean_results - (thresh.*std_results);

% loops through each subject
for sub = 1:length(a);
    % if the subject value exceeds the threshold in either positive or
    % negative direction, adds a 1 to the outlier folder
    if results(sub,1) > thresh_max;
        outliers(sub,1) = 1;
%     else if results(sub,1) < thresh_max;
%             outliers(sub,1) = 1;
    else outliers(sub,1) = 0;
    end
    % adds the subject number to the outlier file
    line = a{sub};
    name1 = line(71:76);
    name = str2num(name1)
    outliers(sub,2) = name;
end

% sorts the st column in ascending order to identify the outliers easily
outliers2 = sortrows(outliers,1);

% saves the relevant files
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/checks/check_normalisation/first';
save outliers outliers;
save outliers2 outliers2;
save mean_results mean_results;
save thresh_max thresh_max;
end
