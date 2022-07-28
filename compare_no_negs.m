cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/all_voxels';

hrfc = importdata('GM_HRFc_v2.mat');
hrftd = importdata('GM_HRFtd_v2.mat');
fourier = importdata('GM_fourier_2_v2.mat');

% takes the coordiantes
grand = hrfc(:,265:267);
% takes the pos vs neg demarcation
grand(:,4) = hrfc(:,269);

clear n
for n = 1:length(grand(:,1));
    clear a
    % looks for a case in the HRFtd file where the coordnate match, and if
    % found, we put the pos vs neg demarcation in the 6th column.
    try
        a = find(hrftd(:,265) == grand(n,1) & hrftd(:,266) == grand(n,2) & hrftd(:,267) == grand(n,3));
        grand(n,6) = hrftd(a,271);
    catch
        grand(n,6) = 999;
    end
    % adds the HRFc and fleible pos neg demarcations, so we have +2 or -2
    % when they agree
    grand(n,7) = grand(n,4) + grand(n,6);
    % differentiates a -1 to 1 versus 1 to -1 difference, 3 means HRFc was
    % pos, 4 means the flexible model was pos.
    if grand(n,4) == 1 & grand(n,6) == -1;
        grand(n,7) = 3;
    else if grand(n,6) == 1 & grand(n,4) == -1;
            grand(n,7) = 4;
        end
    end
    clear a
    % repeats things with fourier
    try
        a = find(fourier(:,152) == grand(n,1) & fourier(:,153) == grand(n,2) & fourier(:,154) == grand(n,3));
        grand(n,9) = fourier(a,162);
    catch
        grand(n,9) = 999;
    end
    % sets it so -2 and 2 show same values in both
    grand(n,10) = grand(n,4) + grand(n,9);
    % differentiates a -1 to 1 versus 1 to -1 difference, 3 means HRFc was
    % pos, 4 means the flexible model was pos.
    if grand(n,4) == 1 & grand(n,9) == -1;
        grand(n,10) = 3;
    else if grand(n,9) == 1 & grand(n,4) == -1;
            grand(n,10) = 4;
        end
    end
end
        
hrftd_both_neg = length(find(grand(:,7) == -2));    
hrftd_both_pos = length(find(grand(:,7) == 2));    
hrftd_neg = length(find(grand(:,7) == 3));    
hrftd_pos = length(find(grand(:,7) == 4)); 
no_hrftd_hrfcpos = length(find(grand(:,6) == 999 & grand(:,4) == 1));
no_hrftd_hrfcneg = length(find(grand(:,6) == 999 & grand(:,4) == -1));
fourier_both_neg = length(find(grand(:,10) == -2));    
fourier_both_pos = length(find(grand(:,10) == 2));    
fourier_neg = length(find(grand(:,10) == 3));    
fourier_pos = length(find(grand(:,10) == 4));
no_fourier_hrfcpos = length(find(grand(:,9) == 999 & grand(:,4) == 1));
no_fourier_hrfcneg = length(find(grand(:,9) == 999 & grand(:,4) == -1));

hrf_neg = length(find(hrfc(:,269) == -1));
hrf_pos = length(find(hrfc(:,269) == 1));

% calculate percentage of shared HRFc positive voxels which are negative in
% flexi models
hrftd_false_neg = (hrftd_neg ./ (hrf_pos - no_hrftd_hrfcpos)) .* 100;
fourier_false_neg = (fourier_neg ./ (hrf_pos - no_fourier_hrfcpos)) .* 100;

hrftd_false_pos = (hrftd_pos ./ (hrf_neg - no_hrftd_hrfcneg)) .* 100;
fourier_false_pos = (fourier_pos ./ (hrf_neg - no_fourier_hrfcneg)) .* 100;

