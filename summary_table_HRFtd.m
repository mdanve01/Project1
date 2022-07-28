% load the signals we are trying to model
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';

HRFs = importdata('short_pos.mat');
HRFl = importdata('long_pos.mat');
HRFf = importdata('short_fwhm.mat');
HRFc = importdata('HRFc.mat');
HRFsl = importdata('sublong.mat');
bfs = importdata('HRFtd.mat');

% weight the functions by the reuslts
% short
short(:,1) = bfs(:,1) .* 11.016;     
short(:,2) = bfs(:,2) .* 59.671;    
short(:,3) = bfs(:,3) .* -37.135;    
short(:,4) = .008;
new_short = sum(short');

% short fwhm
sfwhm(:,1) = bfs(:,1) .* 22.375;     
sfwhm(:,2) = bfs(:,2) .* 4.686;    
sfwhm(:,3) = bfs(:,3) .* 35.842;    
sfwhm(:,4) = .025;
new_sfwhm = sum(sfwhm');

% can
can(:,1) = bfs(:,1) .* 38.593;     
can(:,2) = bfs(:,2) .* 0;    
can(:,3) = bfs(:,3) .* 0;    
can(:,4) = 0;
new_can = sum(can');

% sublong
sublong(:,1) = bfs(:,1) .* 33.366;     
sublong(:,2) = bfs(:,2) .* -71.269;    
sublong(:,3) = bfs(:,3) .* -37.642;           
sublong(:,4) = .046;
new_sl = sum(sublong');

% long
long(:,1) = bfs(:,1) .* 12.944;     
long(:,2) = bfs(:,2) .* -77.457;    
long(:,3) = bfs(:,3) .* -45.145;    
long(:,4) = .213;
new_long = sum(long');

window = 32;
sec = 260 ./ window;

figure(99)
subplot(5,4,1);
plot(new_short,'Color','#D95319','LineWidth',2.5);
% plot(new_short,'k','LineWidth',2.5);
hold on
plot(HRFs,'Color','#0072BD','LineWidth',2.5);
% plot(HRFs,'-.k','LineWidth',2);
title('HRFtd: 0.5 x Peak Latency & Dispersion');
legend('HRFtd','0.5 x HRFc');
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

subplot(5,4,2);
scatter(new_short,HRFs,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,5);
plot(new_sfwhm,'Color','#D95319','LineWidth',2.5);
hold on
plot(HRFf,'Color','#0072BD','LineWidth',2);
title('HRFtd: 0.5 x Dispersion');
legend('HRFtd','0.5 x HRFc Dispersion');
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

subplot(5,4,6);
scatter(new_sfwhm,HRFf,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,9);
plot(new_can,'Color','#D95319','LineWidth',2.5);
hold on
plot(HRFc,'Color','#0072BD','LineWidth',2);
title('HRFtd: Canonical');
legend('HRFtd','HRFc');
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

subplot(5,4,10);
scatter(new_can,HRFc,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,13);
plot(new_sl,'Color','#D95319','LineWidth',2.5);
hold on
plot(HRFsl,'Color','#0072BD','LineWidth',2);
title('HRFtd: 1.5 x Peak Latency & Dispersion');
legend('HRFtd','1.5 x HRFc');
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

subplot(5,4,14);
scatter(new_sl,HRFsl,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,17);
plot(new_long,'Color','#D95319','LineWidth',2.5);
hold on
plot(HRFl,'Color','#0072BD','LineWidth',2);
title('HRFtd: 2 x Peak Latency & Dispersion');
legend('HRFtd','2 x HRFc');
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

subplot(5,4,18);
scatter(new_long,HRFl,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

sum_all = [new_can; new_sfwhm; new_short; new_sl; new_long; HRFc; HRFf; HRFs; HRFsl; HRFl];

for n = 1: length(sum_all(:,1));

    clear t1
    clear thresh2
    clear thresh1
    t1(1) = max(sum_all(n,:));
    t1(2) = max(-sum_all(n,:));
    thresh2 = max(t1);
    thresh1 = thresh2 .* 0.25;

    clear PKS
    clear LOCS
    clear widths
    if t1(1) > t1(2);
        try
        % find the peak latency, peak amplitude and fwhm.
        % Look for the max peak with a prominence eceeding
        % the threshold. Use this as peak amp
        [PKS,LOCS,widths] = findpeaks(sum_all(n,:),'MinPeakProminence',thresh1,'WidthReference','halfheight');
        clear max_peak
        max_peak = max(PKS);
        clear loc_max
        loc_max = find(PKS == max_peak);
        total_run(n,1) = LOCS(loc_max)./sec;
        total_run(n,2) = widths(loc_max)./sec;
        total_run(n,3) = PKS(loc_max);
        total_run(n,4) = length(PKS);
        total_run(n,5) = 1;
        catch

        total_run(n,1:4) = 999;
        total_run(n,5) = 0;
        end
    else if t1(2) > t1(1);
            try
                clear PKS
                clear LOCS
                clear widths
                [PKS,LOCS,widths] = findpeaks(-sum_all(n,:),'MinPeakProminence',thresh1,'WidthReference','halfheight');
                clear max_peak
                max_peak = max(PKS);
                clear loc_max
                loc_max = find(PKS == max_peak);
                total_run(n,1) = LOCS(loc_max)./sec;
                total_run(n,2) = widths(loc_max)./sec;
                total_run(n,3) = PKS(loc_max);
                total_run(n,4) = length(PKS);
                total_run(n,5) = -1;
            catch
                total_run(n,1:4) = 999;
                total_run(n,5) = 0;
            end
        end
    end
end

% calculate the difference score for PL and FWHM
for m = 1:5;
    total_run(m,6) = total_run(m,1) - total_run(m+5,1);
    total_run(m,7) = total_run(m,2) - total_run(m+5,2);
end

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation/lin_reg';

% convert to a labelled table
table = array2table(total_run,'VariableNames',{'Peak_Latency','FWHM','Peak_Amplitude','Num_Peaks','PBR_or_NBR','Peak_Latency_Difference','FWHM_Difference'},'RowNames',{'Canonical_Model','Shortfwhm_Model','Short_Model','Sublong_Model','Long_Model','Canonical_Original','Shortfwhm_Original','Short_Original','Sublong_Original','Long_Original'});

save HRFtd_table table