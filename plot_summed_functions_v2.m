cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';
window = 32.0125;
sec = 260./ window;
num = 100;

total = importdata('GM_HRFtd_v6.mat');
try
outlier(:,1) = find(total(:,271) == -1);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,1);
for n = 1:num;
    total(outlier(n),1:260) = total(outlier(n),1:260) ./ max(abs(total(outlier(n),1:260)));
    plot(total(outlier(n),1:260));
    hold on
end
xlim([0,260]);
title('GM HRFtd Unimodal NBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier

total = importdata('GM_HRFtd_v6.mat');
try
outlier(:,1) = find(total(:,271) == 1);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,3);
for n = 1:num;
    total(outlier(n),1:260) = total(outlier(n),1:260) ./ max(abs(total(outlier(n),1:260)));
    plot(total(outlier(n),1:260));
    hold on
end
xlim([0,260]);
title('GM HRFtd Unimodal PBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier

total = importdata('GM_HRFtd_v6.mat');
try
outlier(:,1) = find(total(:,271) == -2);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,5);
for n = 1:num;
    total(outlier(n),1:260) = total(outlier(n),1:260) ./ max(abs(total(outlier(n),1:260)));
    plot(total(outlier(n),1:260));
    hold on
end
xlim([0,260]);
title('GM HRFtd Multimodal NBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier





window = 18;
sec = 147./ window;

total = importdata('GM_fourier_v6.mat');
try
outlier(:,1) = find(total(:,162) == -1);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,2);
for n = 1:num;
    total(outlier(n),1:147) = total(outlier(n),1:147) ./ max(abs(total(outlier(n),1:147)));
    plot(total(outlier(n),1:147));
    hold on
end
title('GM Fourier Unimodal NBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier

total = importdata('GM_fourier_v6.mat');
try
outlier(:,1) = find(total(:,162) == 1);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,4);
for n = 1:num;
    total(outlier(n),1:147) = total(outlier(n),1:147) ./ max(abs(total(outlier(n),1:147)));
    plot(total(outlier(n),1:147));
    hold on
end
title('GM Fourier Unimodal PBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier


total = importdata('GM_fourier_v6.mat');
try
outlier(:,1) = find(total(:,162) == -2);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,6);
for n = 1:num;
    total(outlier(n),1:147) = total(outlier(n),1:147) ./ max(abs(total(outlier(n),1:147)));
    plot(total(outlier(n),1:147));
    hold on
end
title('GM Fourier Multimodal NBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier


total = importdata('GM_fourier_v6.mat');
try
outlier(:,1) = find(total(:,162) == 2);
outlier(:,2) = rand(length(outlier(:,1)),1);
outlier = sortrows(outlier,2);
figure(100);
subplot(4,2,8);
for n = 1:num;
    total(outlier(n),1:147) = total(outlier(n),1:147) ./ max(abs(total(outlier(n),1:147)));
    plot(total(outlier(n),1:147));
    hold on
end
title('GM Fourier Multimodal PBR');
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Standardised Amplitude');
ylim([-1.1 1.1]);
hold off
end
clear total
clear outlier



