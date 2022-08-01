cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/ROIs_HRFc';

m1 = importdata('GM_HRFc_M1.mat');
a1 = importdata('GM_HRFc_A1.mat');
v1 = importdata('GM_HRFc_V1.mat');
ce = importdata('GM_HRFc_Cer.mat');
ap = importdata('GM_HRFc_aPFC.mat');

total(1,1) = length(find(m1(:,269) == -1));
total(1,2) = length(find(m1(:,269) == 1));
total(2,1) = length(find(a1(:,269) == -1));
total(2,2) = length(find(a1(:,269) == 1));
total(3,1) = length(find(v1(:,269) == -1));
total(3,2) = length(find(v1(:,269) == 1));
total(4,1) = length(find(ce(:,269) == -1));
total(4,2) = length(find(ce(:,269) == 1));
total(5,1) = length(find(ap(:,269) == -1));
total(5,2) = length(find(ap(:,269) == 1));

save table total
