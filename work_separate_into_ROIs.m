cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/ROIs';

load('all_fourier.mat');

% M1
region.m1 = total_run2(find(total_run2(:,163) == 1),:);
list.m1 = region.m1(:,148:149);
list.m1(:,3) = region.m1(:,163);

figure(1);
subplot(3,2,1);
hist(region.m1(:,148));
title('M1');
xlabel('Peak Latency (secs)');
ylabel('Frequency');

figure(2);
subplot(3,2,1);
hist(region.m1(:,149));
title('M1');
xlabel('FWHM (secs)');
ylabel('Frequency');

clear n
for n = 1:length(region.m1(:,1));
    if region.m1(n,162) > 0;
        list.m1(n,4) = 1;
    elseif region.m1(n,162) < 0;
        list.m1(n,4) = -1;
    end
end

% A1
region.a1 = total_run2(find(total_run2(:,163) == 2),:);
list.a1 = region.a1(:,148:149);
list.a1(:,3) = region.a1(:,163);
clear n
for n = 1:length(region.a1(:,1));
    if region.a1(n,162) > 0;
        list.a1(n,4) = 1;
    elseif region.a1(n,162) < 0;
        list.a1(n,4) = -1;
    end
end
figure(1)
subplot(3,2,2);
hist(region.a1(:,148));
title('A1');
xlabel('Peak Latency (secs)');
ylabel('Frequency');

figure(2);
subplot(3,2,2);
hist(region.a1(:,149));
title('A1');
xlabel('FWHM (secs)');
ylabel('Frequency');

% V1
region.v1 = total_run2(find(total_run2(:,163) == 3),:);
list.v1 = region.v1(:,148:149);
list.v1(:,3) = region.v1(:,163);
clear n
for n = 1:length(region.v1(:,1));
    if region.v1(n,162) > 0;
        list.v1(n,4) = 1;
    elseif region.v1(n,162) < 0;
        list.v1(n,4) = -1;
    end
end
figure(1)
subplot(3,2,3);
hist(region.v1(:,148));
title('V1');
xlabel('Peak Latency (secs)');
ylabel('Frequency');

figure(2);
subplot(3,2,3);
hist(region.v1(:,149));
title('V1');
xlabel('FWHM (secs)');
ylabel('Frequency');

% cer
region.cer = total_run2(find(total_run2(:,163) == 4),:);
list.cer = region.cer(:,148:149);
list.cer(:,3) = region.cer(:,163);
clear n
for n = 1:length(region.cer(:,1));
    if region.cer(n,162) > 0;
        list.cer(n,4) = 1;
    elseif region.cer(n,162) < 0;
        list.cer(n,4) = -1;
    end
end
figure(1)
subplot(3,2,4);
hist(region.cer(:,148));
title('Cerebellum');
xlabel('Peak Latency (secs)');
ylabel('Frequency');

figure(2);
subplot(3,2,4);
hist(region.cer(:,149));
title('Cerebellum');
xlabel('FWHM (secs)');
ylabel('Frequency');

% pfc
region.pfc = total_run2(find(total_run2(:,163) == 5),:);
list.pfc = region.pfc(:,148:149);
list.pfc(:,3) = region.pfc(:,163);
clear n
for n = 1:length(region.pfc(:,1));
    if region.pfc(n,162) > 0;
        list.pfc(n,4) = 1;
    elseif region.pfc(n,162) < 0;
        list.pfc(n,4) = -1;
    end
end

figure(1)
subplot(3,2,5);
hist(region.pfc(:,148));
title('aPFC');
xlabel('Peak Latency (secs)');
ylabel('Frequency');

figure(2);
subplot(3,2,5);
hist(region.pfc(:,149));
title('aPFC');
xlabel('FWHM (secs)');
ylabel('Frequency');


all = [list.m1; list.a1; list.v1; list.cer; list.pfc];

save ROI_list all

