cd '/usr/local/apps/psycapps/spm/spm12-r7487/tpm';
tpm = niftiread('TPM.nii');

gm = tpm(:,:,:,1);
wm = tpm(:,:,:,2);

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier_hrftd';

fh = niftiread('fh_all.nii');

list_gm = 0;
list_wm = 0;
list_other = 0;

% goes through each of the coordinates, if the mask says there is a
% significant voxel it works out where this is. If there is greater than
% 0.5 probability in GM then says GM, if greater than 0.5 probability of WM
% says WM, if not says other.
for first = 1:length(fh(1,1,:));
    for second = 1:length(fh(1,:,1));
        for third = 1:length(fh(:,1,1));
            if fh(first,second,third) > 0;
                if gm(first,second,third) > 0.5;
                    list_gm = list_gm + 1;
                else if wm(first,second,third) > 0.5;
                        list_wm = list_wm + 1;
                    else
                        list_other = list_other + 1;
                    end
                end
            end
        end
    end
end

total_num = list_gm + list_wm + list_other;

gm_rat = list_gm ./ total_num;
wm_rat = list_wm ./ total_num;
other_rat = list_other ./ total_num;

total = [gm_rat; wm_rat; other_rat];

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels/gm_wm_other';

save tpm_fourier_hrftd total;
                        