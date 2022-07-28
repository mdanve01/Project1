cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';

hrftd = importdata('GM_HRFtd_v6.mat');

% find all instances of negative canonical HRFtd and positive canonical
% HRFc
for n = 1:length(hrftd(:,1));
    if hrftd(n,268) < 0 & hrftd(n,271) > 0;
        hrftd(n,273) = 1;
    else
        hrftd(n,273) = 0;
    end
end

% create matri of just these discrepancies
clear x
x = find(hrftd(:,273) == 1);
hrftd_error = hrftd(x,:);

% create a vector of 50 random cases and plot
clear x
x = rand(1,50);
x = round(x .* length(hrftd_error(:,1)));
shared = hrftd_error(x,:);

clear n
for n = 1:length(shared(:,1));
    figure(99);
    subplot(1,2,1);
    plot(shared(n,1:260));
    hold on
end
xlim([0 260]);
window = 32.0125;
sec = 260./ window;
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Amplitude');
title('Canonical with Derivatives');
hold off

fourier = importdata('GM_fourier_v6.mat');

clear n
for n = 1:length(shared(:,1));
    try
        clear x
        x = find(shared(n,265) == fourier(:,152) & shared(n,266) == fourier(:,153) & shared(n,267) == fourier(:,154));
        shared(n,301:447) = fourier(x,1:147);
    end
end

clear n
for n = 1:length(shared(:,1));
    figure(99);
    subplot(1,2,2);
    plot(shared(n,301:447));
    hold on
end
xlim([0 147]);
window = 18;
sec = 147./ window;
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
xlabel('Time (secs)');
ylabel('Amplitude');
title('Fourier');