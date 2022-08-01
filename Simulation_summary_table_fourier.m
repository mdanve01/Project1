% load the signals we are trying to model
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation';

HRFs = importdata('short_pos.mat');
HRFl = importdata('long_pos.mat');
HRFf = importdata('short_fwhm.mat');
HRFc = importdata('HRFc.mat');
HRFsl = importdata('sublong.mat');
bfs = importdata('Fourier.mat');

bfs(148:260,:) = 0;

% weight the functions by the reuslts
% short
short(:,1) = bfs(:,1) .* .051;     
short(:,2) = bfs(:,2) .* .19;    
short(:,3) = bfs(:,3) .* .760;    
short(:,4) = bfs(:,4) .* .525;     
short(:,5) = bfs(:,5) .* .677;    
short(:,6) = bfs(:,6) .* .498;    
short(:,7) = bfs(:,7) .* .333;
short(:,8) = -.001;
new_short = sum(short');

% short fwhm
sfwhm(:,1) = bfs(:,1) .* .210;     
sfwhm(:,2) = bfs(:,2) .* .588;    
sfwhm(:,3) = bfs(:,3) .* .565; 
sfwhm(:,4) = bfs(:,4) .* .132;     
sfwhm(:,5) = bfs(:,5) .* -.485;    
sfwhm(:,6) = bfs(:,6) .* -.298;
sfwhm(:,7) = bfs(:,7) .* -.191;     
sfwhm(:,8) = .006;
new_sfwhm = sum(sfwhm');

% can
can(:,1) = bfs(:,1) .* .542;     
can(:,2) = bfs(:,2) .* .793;    
can(:,3) = bfs(:,3) .* .537;    
can(:,4) = bfs(:,4) .* .335;     
can(:,5) = bfs(:,5) .* -.102;    
can(:,6) = bfs(:,6) .* .073;    
can(:,7) = bfs(:,7) .* -.112;        
can(:,8) = -.024;
new_can = sum(can');

% sublong
sublong(:,1) = bfs(:,1) .* .992;     
sublong(:,2) = bfs(:,2) .* .247;    
sublong(:,3) = bfs(:,3) .* .031;    
sublong(:,4) = bfs(:,4) .* -.073;     
sublong(:,5) = bfs(:,5) .* -.001;    
sublong(:,6) = bfs(:,6) .* -.061;    
sublong(:,7) = bfs(:,7) .* .047;        
sublong(:,8) = -.054;
new_sl = sum(sublong');

% long
long(:,1) = bfs(:,1) .* .935;     
long(:,2) = bfs(:,2) .* -.39;    
long(:,3) = bfs(:,3) .* .136;    
long(:,4) = bfs(:,4) .* -.323;     
long(:,5) = bfs(:,5) .* .172;    
long(:,6) = bfs(:,6) .* -.231;    
long(:,7) = bfs(:,7) .* .141;        
long(:,8) = .048;
new_long = sum(long');

window = 18;
sec = 147 ./ window;


figure(99)
subplot(5,4,3);
plot(new_short,'Color','#EDB120','LineWidth',2.5);
hold on
plot(HRFs,'Color','#0072BD','LineWidth',2);
title('Fourier: 0.5 x Peak Latency & Dispersion');
legend('Fourier','0.5 x HRFc');
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

subplot(5,4,4);
scatter(new_short,HRFs,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,7);
plot(new_sfwhm,'Color','#EDB120','LineWidth',2.5);
hold on
plot(HRFf,'Color','#0072BD','LineWidth',2);
title('Fourier: 0.5 x Dispersion');
legend('Fourier','0.5 x HRFc Dispersion');
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

subplot(5,4,8);
scatter(new_sfwhm,HRFf,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,11);
plot(new_can,'Color','#EDB120','LineWidth',2.5);
hold on
plot(HRFc,'Color','#0072BD','LineWidth',2);
title('Fourier: Canonical');
legend('Fourier','HRFc');
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

subplot(5,4,12);
scatter(new_can,HRFc,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,15);
plot(new_sl,'Color','#EDB120','LineWidth',2.5);
hold on
plot(HRFsl,'Color','#0072BD','LineWidth',2);
title('Fourier: 1.5 x Peak Latency & Dispersion');
legend('Fourier','1.5 x HRFc');
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

subplot(5,4,16);
scatter(new_sl,HRFsl,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

subplot(5,4,19);
plot(new_long,'Color','#EDB120','LineWidth',2.5);
hold on
plot(HRFl,'Color','#0072BD','LineWidth',2);
title('Fourier: 2 x Peak Latency & Dispersion');
legend('Fourier','2 x HRFc');
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

subplot(5,4,20);
scatter(new_long,HRFl,8,'filled');
xlabel('Estimated Amplitude');
ylabel('BOLD Amplitude');
title('Line of Best Fit');
lsline

% new_can2 = new_can;
% new_can2(148:260) = 0;
% new_short2 = new_short;
% new_short2(148:260) = 0;
% new_long2 = new_long;
% new_long2(148:260) = 0;
% new_sl2 = new_sl;
% new_sl2(148:260) = 0;
% new_sfwhm2 = new_sfwhm;
% new_sfwhm2(148:260) = 0;

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

save four_table table
