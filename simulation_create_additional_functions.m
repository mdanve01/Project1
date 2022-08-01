cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation'

load('short_pos.mat');

sec = 260 ./ 32;

% as the short function has a peak latency approximately 2.585 seconds
% earlier, this means I need an extra 21 datapoints before the function.
short_fwhm(1:260) = 0;
short_fwhm(22:260) = short(1:239);
[PKS,LOCS,widths] = findpeaks(short_fwhm);
peak_latency = LOCS ./ sec;

save short_fwhm short_fwhm
