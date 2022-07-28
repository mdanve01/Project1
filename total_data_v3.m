cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';

%four
clear total_run2
load('GM_fourier_v6.mat');
results(3,1) = length(find(total_run2(:,162) == -1));
results(3,2) = length(find(total_run2(:,162) == 1));
results(3,3) = length(find(total_run2(:,162) == -2));
results(3,4) = length(find(total_run2(:,162) == 2));
results(3,5) = length(total_run2(:,1));
try
    results(3,6) = length(find(total_run2(:,162) == 0));
catch
    results(3,6) = 0;
end
results(3,7) = length(find(total_run2(:,151) > 1));
results(3,8) = (results(3,1) + results(3,3)) / results(3,5);

%hrftd
clear total_run2
load('GM_HRFtd_v6.mat');
results(2,1) = length(find(total_run2(:,271) == -1));
results(2,2) = length(find(total_run2(:,271) == 1));
results(2,3) = length(find(total_run2(:,271) == -2));
results(2,4) = length(find(total_run2(:,271) == 2));
results(2,5) = length(total_run2(:,1));
try
    results(2,6) = length(find(total_run2(:,271) == 0));
catch
    results(2,6) = 0;
end
results(2,7) = length(find(total_run2(:,264) > 1));
results(2,8) = (results(2,1) + results(2,3)) / results(2,5);

%hrfc
clear total_run2
load('GM_HRFc_v6.mat');
results(1,1) = length(find(total_run2(:,269) == -1));
results(1,2) = length(find(total_run2(:,269) == 1));
results(1,5) = length(total_run2(:,1));
try
    results(1,6) = length(find(total_run2(:,269) == 0));
catch
    results(1,6) = 0;
end
results(1,7) = length(find(total_run2(:,264) > 1));
results(1,8) = (results(1,1) + results(1,3)) / results(1,5);


cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';

save Appendix_R results
