cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3';

load('GM_fourier_v6.mat');

mask.pl(1:121,1:145,1:121) = 0;
mask.fwhm(1:121,1:145,1:121) = 0;

for n = 1:length(total_run2(:,1));
    mask.pl(total_run2(n,152),total_run2(n,153),total_run2(n,154)) = total_run2(n,148);
    mask.fwhm(total_run2(n,152),total_run2(n,153),total_run2(n,154)) = total_run2(n,149);
end

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation';

niftiwrite(mask.pl, 'pl.nii');
niftiwrite(mask.fwhm, 'fwhm.nii');