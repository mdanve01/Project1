cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf_td/CC110033_hrf_td_test';
first_spm = load('SPM.mat');
bfs = first_spm.SPM.xBF.bf;

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';
HRFs = importdata('short_pos.mat')';
HRFf = importdata('short_fwhm.mat')';
HRFc = importdata('HRFc.mat')';
HRFsl = importdata('sublong.mat');
HRFe = importdata('long_pos.mat')';

short = bfs(:,1) .* 9.665;
fwhm = bfs(:,1) .* 24.434;
can = bfs(:,1) .* 38.593;
long = bfs(:,1) .* 9.484;
sublong = bfs(:,1) .* 30.4;
window = 32;
sec = 260 ./ window;

subplot(5,2,1);
plot(short,'LineWidth',2);
hold on
plot(HRFs,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.4 1.2]);
xlim([0 260]);
legend('Best Fitting Canonical','BOLD Signal');
title('Halved Peak Latency & Dispersion');

subplot(5,2,2);
scatter(short,HRFs,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,2,3);
plot(fwhm,'LineWidth',2);
hold on
plot(HRFf,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.4 1.2]);
xlim([0 260]);
legend('Best Fitting Canonical','BOLD Signal');
title('Halved Dispersion');

subplot(5,2,4);
scatter(fwhm,HRFf,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,2,5);
plot(can,'LineWidth',2);
hold on
plot(HRFc,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.4 1.2]);
xlim([0 260]);
legend('Best Fitting Canonical','BOLD Signal');
title('Canonical');

subplot(5,2,6);
scatter(can,HRFc,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,2,7);
plot(sublong,'LineWidth',2);
hold on
plot(HRFsl,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.4 1.2]);
xlim([0 260]);
legend('Best Fitting Canonical','BOLD Signal');
title('1.5 x Peak Latency and Dispersion');

subplot(5,2,8);
scatter(sublong,HRFsl,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,2,9);
plot(long,'LineWidth',2);
hold on
plot(HRFe,'LineWidth',2);
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.4 1.2]);
xlim([0 260]);
legend('Best Fitting Canonical','BOLD Signal');
title('Doubled Peak Latency & Dispersion');

subplot(5,2,10);
scatter(long,HRFe,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

amplitudes(1) = max(short);
amplitudes(2) = max(fwhm);
amplitudes(3) = max(can);
amplitudes(4) = max(sublong);
amplitudes(5) = max(long);
