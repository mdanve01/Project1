cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';
fourier = importdata('GM_fourier_v6.mat');
hrftd = importdata('GM_HRFtd_v6.mat');

% pull out key data for all uni and multimodal PBRs
clear a
% find all positive functions
a = find(fourier(:,162) > 0);

results.f_pl_pos(:,1) = fourier(a,148);
results.f_pl_pos(:,2) = fourier(a,162);
results.f_pl_pos(:,3) = 5.14;
results.f_fwhm_pos(:,1) = fourier(a,149);
results.f_fwhm_pos(:,2) = fourier(a,162);
results.f_fwhm_pos(:,3) = 5.23;
subplot(4,2,1); histogram(results.f_pl_pos(:,1));
subplot(4,2,2); histogram(results.f_fwhm_pos(:,1));

% pull out key data for all fourier unimodal NBRs
clear b
% find all negative functions
b = find(fourier(:,162) < 0);
results.f_pl_neg(:,1) = fourier(b,148);
results.f_pl_neg(:,2) = fourier(b,162);
results.f_pl_neg(:,3) = 5.14;
results.f_fwhm_neg(:,1) = fourier(b,149);
results.f_fwhm_neg(:,2) = fourier(b,162);
results.f_fwhm_neg(:,3) = 5.23;
subplot(4,2,3); histogram(results.f_pl_neg(:,1));
subplot(4,2,4); histogram(results.f_fwhm_neg(:,1));

% pull out key data
clear a
% find all positive uni and multimodal functions
a = find(hrftd(:,271) > 0);
results.h_pl_pos(:,1) = hrftd(a,261);
results.h_pl_pos(:,2) = hrftd(a,271);
results.h_pl_pos(:,3) = 5.17;
results.h_fwhm_pos(:,1) = hrftd(a,262);
results.h_fwhm_pos(:,2) = hrftd(a,271);
results.h_fwhm_pos(:,3) = 5.26;
subplot(4,2,5); histogram(results.h_pl_pos(:,1));
subplot(4,2,6); histogram(results.h_fwhm_pos(:,1));

% pull out key data from just unimodal HRFtd NBRs
clear a
% find all negative functions
a = find(hrftd(:,271) < 0);
results.h_pl_neg(:,1) = hrftd(a,261);
results.h_pl_neg(:,2) = hrftd(a,271);
results.h_pl_neg(:,3) = 5.17;
results.h_fwhm_neg(:,1) = hrftd(a,262);
results.h_fwhm_neg(:,2) = hrftd(a,271);
results.h_fwhm_neg(:,3) = 5.26;
subplot(4,2,7); histogram(results.h_pl_neg(:,1));
subplot(4,2,8); histogram(results.h_fwhm_neg(:,1));

figure(102);
subplot(4,2,1);boxplot(results.f_pl_pos(:,1));
xlabel('Peak Latency (secs)');
title('Fourier Positive');
subplot(4,2,2);boxplot(results.f_fwhm_pos(:,1));
xlabel('FWHM (secs)');
title('Fourier Positive');
subplot(4,2,3);boxplot(results.f_pl_neg(:,1));
xlabel('Peak Latency (secs)');
title('Fourier Negative');
subplot(4,2,4);boxplot(results.f_fwhm_neg(:,1));
xlabel('FWHM (secs)');
title('Fourier Negative');
subplot(4,2,5);boxplot(results.h_pl_pos(:,1));
xlabel('Peak Latency (secs)');
title('HRFtd Positive');
subplot(4,2,6);boxplot(results.h_fwhm_pos(:,1));
xlabel('FWHM (secs)');
title('HRFtd Positive');
subplot(4,2,7);boxplot(results.h_pl_neg(:,1));
xlabel('Peak Latency (secs)');
title('HRFtd Negative');
subplot(4,2,8);boxplot(results.h_fwhm_neg(:,1));
xlabel('FWHM (secs)');
title('HRFtd Negative');

% generate difference scores
results.f_pl_pos(:,5) = results.f_pl_pos(:,3) - results.f_pl_pos(:,1);
results.f_fwhm_pos(:,5) = results.f_fwhm_pos(:,3) - results.f_fwhm_pos(:,1);
results.f_pl_neg(:,5) = results.f_pl_neg(:,3) - results.f_pl_neg(:,1);
results.f_fwhm_neg(:,5) = results.f_fwhm_neg(:,3) - results.f_fwhm_neg(:,1);
results.h_pl_pos(:,5) = results.h_pl_pos(:,3) - results.h_pl_pos(:,1);
results.h_fwhm_pos(:,5) = results.h_fwhm_pos(:,3) - results.h_fwhm_pos(:,1);
results.h_pl_neg(:,5) = results.h_pl_neg(:,3) - results.h_pl_neg(:,1);
results.h_fwhm_neg(:,5) = results.h_fwhm_neg(:,3) - results.h_fwhm_neg(:,1);

figure(300);
subplot(2,2,1);histogram(results.f_pl_pos(:,5));
xlabel('Peak Latency (secs)');
title('Fourier Positive');
subplot(2,2,2);histogram(results.f_pl_neg(:,5));
xlabel('Peak Latency (secs)');
title('Fourier Negative');
subplot(2,2,3);histogram(results.f_fwhm_pos(:,5));
xlabel('FWHM (secs)');
title('Fourier Positive');
subplot(2,2,4);histogram(results.f_fwhm_neg(:,5));
xlabel('Fourier (secs)');
title('Diff Negative');

figure(301);
subplot(2,2,1);histogram(results.h_pl_pos(:,5));
xlabel('Peak Latency (secs)');
title('HRFtd Positive');
subplot(2,2,2);histogram(results.h_pl_neg(:,5));
xlabel('Peak Latency (secs)');
title('HRFtd Negative');
subplot(2,2,3);histogram(results.h_fwhm_pos(:,5));
xlabel('FWHM (secs)');
title('HRFtd Positive');
subplot(2,2,4);histogram(results.h_fwhm_neg(:,5));
xlabel('Fourier (secs)');
title('HRFtd Negative');

thresh = 0.05 ./ 12;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.f_pl_pos(:,1),results.f_pl_pos(:,4),'alpha',thresh);
total(1,2) = median(results.f_pl_pos(:,5));;
total(2,2) = h;
total(3,2) = p;
total(4,2) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.f_fwhm_pos(:,1),results.f_fwhm_pos(:,4),'alpha',thresh);
total(1,6) = median(results.f_fwhm_pos(:,5));;
total(2,6) = h;
total(3,6) = p;
total(4,6) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.f_pl_neg(:,1),results.f_pl_neg(:,4),'alpha',thresh);
total(1,4) = median(results.f_pl_neg(:,5));;
total(2,4) = h;
total(3,4) = p;
total(4,4) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.f_fwhm_neg(:,1),results.f_fwhm_neg(:,4),'alpha',thresh);
total(1,8) = median(results.f_fwhm_neg(:,5));;
total(2,8) = h;
total(3,8) = p;
total(4,8) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.h_pl_pos(:,1),results.h_pl_pos(:,4),'alpha',thresh);
total(1,1) = median(results.h_pl_pos(:,5));;
total(2,1) = h;
total(3,1) = p;
total(4,1) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.h_fwhm_pos(:,1),results.h_fwhm_pos(:,4),'alpha',thresh);
total(1,5) = median(results.h_fwhm_pos(:,5));;
total(2,5) = h;
total(3,5) = p;
total(4,5) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.h_pl_neg(:,1),results.h_pl_neg(:,4),'alpha',thresh);
total(1,3) = median(results.h_pl_neg(:,5));;
total(2,3) = h;
total(3,3) = p;
total(4,3) = STATS.zval;

clear p
clear h
clear STATS
[p,h,STATS] = signrank(results.h_fwhm_neg(:,1),results.h_fwhm_neg(:,4),'alpha',thresh);
total(1,7) = median(results.h_fwhm_neg(:,5));;
total(2,7) = h;
total(3,7) = p;
total(4,7) = STATS.zval;

ranges(1) = range(results.h_pl_pos(:,1));
ranges(2) = range(results.f_pl_pos(:,1));
ranges(3) = range(results.h_pl_neg(:,1));
ranges(4) = range(results.f_pl_neg(:,1));
ranges(5) = range(results.h_fwhm_pos(:,1));
ranges(6) = range(results.f_fwhm_pos(:,1));
ranges(7) = range(results.h_fwhm_neg(:,1));
ranges(8) = range(results.f_fwhm_neg(:,1));

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons';

save c2c_results_NO_REM_all total
save c2c_range_NO_REM_all ranges

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/c2c';
save results results

