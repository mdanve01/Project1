% load the signals we are trying to model
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';

HRFs = importdata('short_pos.mat');
HRFl = importdata('long_pos.mat');
HRFf = importdata('short_fwhm.mat');
HRFc = importdata('HRFc.mat');
HRFsl = importdata('sublong.mat');

window = 32;
sec = 260 ./ window;


figure(99)
plot(HRFs,'LineWidth',2);
hold on
plot(HRFf,'LineWidth',2);
plot(HRFc,'LineWidth',2);
plot(HRFsl,'LineWidth',2);
plot(HRFl,'LineWidth',2);
title('Artifical BOLD Signals');
legend('0.5 x Canonical','0.5 x FWHM','Canonical','1.5 x Canonical','2 x Canonical');
xlabel('Time (seconds)');
ylabel('Amplitude');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
% set the x axis to seconds, and round up to the nearest second (2 decimal
% places)
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
ylim([-0.2 1.1]);
xlim([0 260]);