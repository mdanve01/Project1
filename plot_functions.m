cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/SVA/fourier';
func_f = importdata('functions.mat');
total_f = importdata('total_four.mat');

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/SVA/hrftd';
func_htd = importdata('functions.mat');
total_htd = importdata('total_hrftd.mat');

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/SVA/hrfc';
func_h = importdata('functions.mat');
total_h = importdata('total_hrfc.mat');

window = 32.0125;
sec = length(func_h(:,1)) ./ window;

figure(98)
subplot(3,2,1);plot(func_h(1:147,1),'Color','#0072BD','LineWidth',2);
hold on
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
plot(func_htd(1:147,1),'Color','#D95319','LineWidth',2);
plot(func_f(:,1),'g','Color','#EDB120','LineWidth',2);
xline(total_h(1,1).*sec,'Color','#0072BD','LineWidth',1.5);
xline(total_htd(1,1).*sec,'Color','#D95319','LineWidth',1.5);
xline(total_f(1,1).*sec,'Color','#EDB120','LineWidth',1.5);
ylim([-0.02 0.05]);
xlabel('Time (seconds)');
ylabel('Signal Change (%)');
title('M1');
legend({'HRFc:    PL = 5.17 FWHM = 5.26','HRFtd:  PL = 4.31 FWHM = 3.30','Fourier: PL = 4.53 FWHM = 3.40'});
hold off


subplot(3,2,2);plot(func_h(1:147,2),'Color','#0072BD','LineWidth',2);
hold on
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
plot(func_htd(1:147,2),'Color','#D95319','LineWidth',2);
plot(func_f(:,2),'g','Color','#EDB120','LineWidth',2);
xline(total_h(2,1).*sec,'Color','#0072BD','LineWidth',1.5);
xline(total_htd(2,1).*sec,'Color','#D95319','LineWidth',1.5);
xline(total_f(2,1).*sec,'Color','#EDB120','LineWidth',1.5);
ylim([-0.02 0.08]);
xlabel('Time (seconds)');
ylabel('Signal Change (%)');
title('A1');
legend({'HRFc:    PL = 5.17 FWHM = 5.26','HRFtd:  PL = 4.06 FWHM = 3.33','Fourier: PL = 4.29 FWHM = 3.59'});
hold off

subplot(3,2,3);;plot(func_h(1:147,3),'Color','#0072BD','LineWidth',2);
hold on
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
plot(func_htd(1:147,3),'Color','#D95319','LineWidth',2);
plot(func_f(:,3),'g','Color','#EDB120','LineWidth',2);
xline(total_h(3,1).*sec,'Color','#0072BD','LineWidth',1.5);
xline(total_htd(3,1).*sec,'Color','#D95319','LineWidth',1.5);
xline(total_f(3,1).*sec,'Color','#EDB120','LineWidth',1.5);
ylim([-0.02 0.05]);
xlabel('Time (seconds)');
ylabel('Signal Change (%)');
title('V1');
legend({'HRFc:    PL = 5.17 FWHM = 5.26','HRFtd:  PL = 4.19 FWHM = 3.38','Fourier: PL = 4.41 FWHM = 3.57'});
hold off

subplot(3,2,4);;plot(func_h(1:147,4),'Color','#0072BD','LineWidth',2);
hold on
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
plot(func_htd(1:147,4),'Color','#D95319','LineWidth',2);
plot(func_f(:,4),'g','Color','#EDB120','LineWidth',2);
xline(total_h(4,1).*sec,'Color','#0072BD','LineWidth',1.5);
xline(total_htd(4,1).*sec,'Color','#D95319','LineWidth',1.5);
xline(total_f(4,1).*sec,'Color','#EDB120','LineWidth',1.5);
ylim([-0.01 0.04]);
xlabel('Time (seconds)');
ylabel('Signal Change (%)');
title('Cerebellum');
legend({'HRFc:    PL = 5.17 FWHM = 5.26','HRFtd:  PL = 4.31 FWHM = 3.67','Fourier: PL = 4.53 FWHM = 3.71'});
hold off

subplot(3,2,5);;plot(func_h(1:147,5),'Color','#0072BD','LineWidth',2);
hold on
xbins = 0: (2*sec): (sec*window);
set(gca, 'xtick', xbins);
xt = get(gca, 'XTick');                                 
set(gca, 'XTick', xt, 'XTickLabel', round(xt/sec,2));
plot(func_htd(1:147,5),'Color','#D95319','LineWidth',2);
plot(func_f(:,5),'g','Color','#EDB120','LineWidth',2);
xline(total_h(5,1).*sec,'Color','#0072BD','LineWidth',1.5);
xline(total_htd(5,1).*sec,'Color','#D95319','LineWidth',1.5);
xline(total_f(5,1).*sec,'Color','#EDB120','LineWidth',1.5);
% ylim([-0.19 0.1]);
xlabel('Time (seconds)');
ylabel('Signal Change (%)');
title('aPFC');
legend({'HRFc:    PL = 5.17 FWHM = 5.26','HRFtd:  PL = 7.14 FWHM = 6.79','Fourier: PL = 7.59 FWHM = 9.63'},'Location','southeast');
hold off