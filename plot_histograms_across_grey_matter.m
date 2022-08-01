s = settings;
s.matlab.general.matfile.SaveFormat.TemporaryValue = 'v7.3';

%%%% IMPORTANT NOTE, THERE IS NO CORRECTION HERE TO REMOVED 999 OUTLIERS,
%%%% AS NONE WERE FOUND. BUT IF THINGS GET CHANGED ENSURE THERE ARE NO 999S
%%%% %%%%%%

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';

clear all

% plot GM PL

% positive HRFtd
clear total_run
clear total_run1
clear total_run2
total_run = importdata('GM_HRFtd_v6.mat');
clear locs
locs = find(total_run(:,271) > 0);
total_run1 = total_run(locs,261);
tpos = median(total_run1);

figure(101);
subplot(2,1,1);histogram(total_run1,'BinWidth',0.13,'facecolor','#D95319','facealpha',.3);
hold on
clear total_run
clear total_run2



% positive fourier
total_run = importdata('GM_fourier_v6.mat');
clear locs
locs = find(total_run(:,162) > 0);
total_run2 = total_run(locs,148);
fpos = median(total_run2);

histogram(total_run2,'BinWidth',0.12,'facecolor','#77AC30','facealpha',.3);
clear total_run
clear total_run3



% negative HRFtd
total_run = importdata('GM_HRFtd_v6.mat');
clear locs
locs = find(total_run(:,271) < 0);
total_run3 = total_run(locs,261);
tneg = median(total_run3);

figure(101);
subplot(2,1,1);histogram(total_run3,'BinWidth',0.12,'facecolor','#EDB120','facealpha',.3);
hold on
clear total_run
clear total_run4



% negative fourier
total_run = importdata('GM_fourier_v6.mat');
clear locs
locs = find(total_run(:,162) < 0);
total_run4 = total_run(locs,148);
fneg = median(total_run4);

histogram(total_run4,'BinWidth',0.12,'facecolor','#0072BD','facealpha',.3);
% details
xlim([1.5,11]);
title('GM Peak Latency');
xlabel('Peak Latency (seconds)');
ylabel('Number of voxels');
xline(tpos,'Color','#D95319','LineWidth',2);
xline(fpos,'Color','#77AC30','LineWidth',2);
xline(tneg,'Color','#EDB120','LineWidth',2);
xline(fneg,'Color','#0072BD','LineWidth',2);
xline(5.17,'k','LineWidth',2);
legend('HRFtd+ N=92297 (z=263.618, p<.05)','Fourier+ N=92297 (z=263.549, p<.05)','HRFtd- N=37830 (z=168.485, p<.05)','Fourier- N=37727 (z=168.231, p<.05)','location','northeast');
hold off

clear all
% GM FWHM
figure(101);
clear total_run
clear total_run1
clear total_run2


% positive HRFtd
total_run = importdata('GM_HRFtd_v6.mat');
clear locs
locs = find(total_run(:,271) > 0);
total_run1 = total_run(locs,262);
tpos = median(total_run1);

subplot(2,1,2);histogram(total_run1,'BinWidth',0.05,'facecolor','#D95319','facealpha',.3);
hold on
clear total_run



% positive fourier
total_run = importdata('GM_fourier_v6.mat');
clear locs
locs = find(total_run(:,162) > 0);
total_run2 = total_run(locs,149);
fpos = median(total_run2)

histogram(total_run2,'BinWidth',0.05,'facecolor','#77AC30','facealpha',.3);
clear total_run
clear total_run3



% positive HRFtd
total_run = importdata('GM_HRFtd_v6.mat');
clear locs
locs = find(total_run(:,271) < 0);
total_run3 = total_run(locs,262);
tneg = median(total_run3);

histogram(total_run3,'BinWidth',0.05,'facecolor','#EDB120','facealpha',.3);
hold on
clear total_run
clear total_run4



% positive fourier
total_run = importdata('GM_fourier_v6.mat');
clear locs
locs = find(total_run(:,162) < 0);
total_run4 = total_run(locs,149);
fneg = median(total_run4);

histogram(total_run4,'BinWidth',0.05,'facecolor','#0072BD','facealpha',.3);
% details
xlim([1.5,11]);
title('GM FWHM');
xlabel('FWHM (seconds)');
ylabel('Number of voxels');
xline(tpos,'Color','#D95319','LineWidth',2);
xline(fpos,'Color','#77AC30','LineWidth',2);
xline(tneg,'Color','#EDB120','LineWidth',2);
xline(fneg,'Color','#0072BD','LineWidth',2);
xline(5.26,'k','LineWidth',2);
legend('HRFtd+ N=92297 (z=263.103, p<.05)','Fourier+ N=92297 (z=263.103, p<.05)','HRFtd- N=37830 (z=168.443, p<.05)','Fourier- N=37727 (z=168.213, p<.05)','location','northeast');
hold off
