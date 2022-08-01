s = settings;
s.matlab.general.matfile.SaveFormat.TemporaryValue = 'v7.3';
addpath /usr/local/apps/psycapps/spm/spm12-r7487;


% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf_td/CC110033_hrf_td_test';
first_spm = load('SPM.mat');

% load the 3 functions
bfs = first_spm.SPM.xBF.bf;

% load the HRFc and then standardise the y axis to be max = 1
HRF1 = bfs(:,1);

HRFc = HRF1 ./ max(HRF1);

for n = 1: 130;
    short(n) = HRFc(n.*2);
end
short(131:260) = 0;

clear n
for n = 1:260
    long(n.*2) = HRFc(n);
end
clear m
for m = 1:520;
    if m > 1 & m < 520;
        if long(m) == 0;
            long(m) = mean([long(m+1) long(m-1)]);
        end
    end
end

long2 = long(1:260);

% find parameters
thresh1 = (max(long2)) .* 0.5;
sec = 260 ./ 32;
[PKS,LOCS,widths] = findpeaks(long2,'MinPeakProminence',thresh1);
table(1,1) = PKS ./ sec;
table(2,1) = LOCS ./ sec;
table(3,1) = widths ./ sec;
clear PKS
clear LOCS
clear widths
[PKS,LOCS,widths] = findpeaks(short,'MinPeakProminence',thresh1);
table(1,2) = PKS ./ sec;
table(2,2) = LOCS ./ sec;
table(3,2) = widths ./ sec;
