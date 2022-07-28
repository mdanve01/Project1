cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';
j = 0;
hrftd = importdata('GM_HRFtd_v6.mat');

for n = 1:length(hrftd(:,1));
    if hrftd(n,268) < 0 & hrftd(n,271) > 0;
        figure(99); plot(hrftd(n,1:260));
        hold on
        j = j + 1;
    else if hrftd(n,268) > 0 & hrftd(n,271) < 0;
            figure(100); plot(hrftd(n,1:260));
            hold on
        end
    end
end