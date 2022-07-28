addpath /usr/local/apps/psycapps/spm/spm12-r7487;

% go to the first participant at the first level, and load the SPM file
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/fourier1/CC110033_fourier_test';
first_spm = load('SPM.mat');

% load the 7 functions
bfs = first_spm.SPM.xBF.bf;

%%% SET WINDOW LENGTH %%%%
window = first_spm.SPM.xBF.length;
% calculates how many indices equate to 1 second
sec = length(bfs) ./ window;

% go to the second level and load the file containing all coordinates, and
% create a beta file (e.g. a) containing all beta values in a 3d matrix
cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier';

m1_b(1) = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(1) = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(1) = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(1) = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(1) = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(2) = spm_summarise('beta_0002.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(2) = spm_summarise('beta_0002.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(2) = spm_summarise('beta_0002.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(2) = spm_summarise('beta_0002.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(2) = spm_summarise('beta_0002.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(3) = spm_summarise('beta_0003.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(3) = spm_summarise('beta_0003.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(3) = spm_summarise('beta_0003.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(3) = spm_summarise('beta_0003.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(3) = spm_summarise('beta_0003.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(4) = spm_summarise('beta_0004.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(4) = spm_summarise('beta_0004.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(4) = spm_summarise('beta_0004.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(4) = spm_summarise('beta_0004.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(4) = spm_summarise('beta_0004.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(5) = spm_summarise('beta_0005.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(5) = spm_summarise('beta_0005.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(5) = spm_summarise('beta_0005.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(5) = spm_summarise('beta_0005.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(5) = spm_summarise('beta_0005.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(6) = spm_summarise('beta_0006.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(6) = spm_summarise('beta_0006.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(6) = spm_summarise('beta_0006.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(6) = spm_summarise('beta_0006.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(6) = spm_summarise('beta_0006.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

m1_b(7) = spm_summarise('beta_0007.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_b(7) = spm_summarise('beta_0007.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_b(7) = spm_summarise('beta_0007.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_b(7) = spm_summarise('beta_0007.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_b(7) = spm_summarise('beta_0007.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level_group/fourier/baseline';

m1_base = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-36 -21 52.5]'));
a1_base = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-51 -21 7.5]'));
v1_base = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[12 -88.5 1.5]'));
cer_base = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[24 -54 -21]'));
pfc_base = spm_summarise('beta_0001.nii',struct('def','sphere', 'spec',1, 'xyz',[-3 64.5 13.5]'));

am1 = bfs(:,1) .* m1_b(1);
aa1 = bfs(:,1) .* a1_b(1);
av1 = bfs(:,1) .* v1_b(1);
acer = bfs(:,1) .* cer_b(1);
apfc = bfs(:,1) .* pfc_b(1);

bm1 = bfs(:,2) .* m1_b(2);
ba1 = bfs(:,2) .* a1_b(2);
bv1 = bfs(:,2) .* v1_b(2);
bcer = bfs(:,2) .* cer_b(2);
bpfc = bfs(:,2) .* pfc_b(2);

cm1 = bfs(:,3) .* m1_b(3);
ca1 = bfs(:,3) .* a1_b(3);
cv1 = bfs(:,3) .* v1_b(3);
ccer = bfs(:,3) .* cer_b(3);
cpfc = bfs(:,3) .* pfc_b(3);

dm1 = bfs(:,4) .* m1_b(4);
da1 = bfs(:,4) .* a1_b(4);
dv1 = bfs(:,4) .* v1_b(4);
dcer = bfs(:,4) .* cer_b(4);
dpfc = bfs(:,4) .* pfc_b(4);

em1 = bfs(:,5) .* m1_b(5);
ea1 = bfs(:,5) .* a1_b(5);
ev1 = bfs(:,5) .* v1_b(5);
ecer = bfs(:,5) .* cer_b(5);
epfc = bfs(:,5) .* pfc_b(5);

fm1 = bfs(:,6) .* m1_b(6);
fa1 = bfs(:,6) .* a1_b(6);
fv1 = bfs(:,6) .* v1_b(6);
fcer = bfs(:,6) .* cer_b(6);
fpfc = bfs(:,6) .* pfc_b(6);

gm1 = bfs(:,7) .* m1_b(7);
ga1 = bfs(:,7) .* a1_b(7);
gv1 = bfs(:,7) .* v1_b(7);
gcer = bfs(:,7) .* cer_b(7);
gpfc = bfs(:,7) .* pfc_b(7);

sum_m1a = am1 + bm1 + cm1 + dm1 + em1 + fm1 + gm1;
sum_a1a = aa1 + ba1 + ca1 + da1 + ea1 + fa1 + ga1;
sum_v1a = av1 + bv1 + cv1 + dv1 + ev1 + fv1 + gv1;
sum_cera = acer + bcer + ccer + dcer + ecer + fcer + gcer;
sum_pfca = apfc + bpfc + cpfc + dpfc + epfc + fpfc + gpfc;

sum_m1 = (sum_m1a ./ m1_base) * 100;
sum_a1 = (sum_a1a ./ a1_base) * 100;
sum_v1 = (sum_v1a ./ v1_base) * 100;
sum_cer = (sum_cera ./ cer_base) * 100;
sum_pfc = (sum_pfca ./ pfc_base) * 100;

functions = [sum_m1 sum_a1 sum_v1 sum_cer sum_pfc];

t1(1) = max(sum_m1);
t1(2) = max(-sum_m1);
thresh2 = max(t1);
thresh1 = thresh2 .* 0.25;
[PKS,LOCS,widths] = findpeaks(sum_m1,'MinPeakProminence',thresh1,'WidthReference','halfheight');
total(1,1) = LOCS(find(PKS == max(PKS)))./sec;
total(1,2) = widths(find(PKS == max(PKS)))./sec;

clear thresh2
clear thresh1
clear PKS
clear LOCS
clear widths

t1(1) = max(sum_a1);
t1(2) = max(-sum_a1);
thresh2 = max(t1);
thresh1 = thresh2 .* 0.25;
[PKS,LOCS,widths] = findpeaks(sum_a1,'MinPeakProminence',thresh1,'WidthReference','halfheight');
total(2,1) = LOCS(find(PKS == max(PKS)))./sec;
total(2,2) = widths(find(PKS == max(PKS)))./sec;

clear thresh2
clear thresh1
clear PKS
clear LOCS
clear widths

t1(1) = max(sum_v1);
t1(2) = max(-sum_v1);
thresh2 = max(t1);
thresh1 = thresh2 .* 0.25;
[PKS,LOCS,widths] = findpeaks(sum_v1,'MinPeakProminence',thresh1,'WidthReference','halfheight');
total(3,1) = LOCS(find(PKS == max(PKS)))./sec;
total(3,2) = widths(find(PKS == max(PKS)))./sec;

clear thresh2
clear thresh1
clear PKS
clear LOCS
clear widths

t1(1) = max(sum_cer);
t1(2) = max(-sum_cer);
thresh2 = max(t1);
thresh1 = thresh2 .* 0.25;
[PKS,LOCS,widths] = findpeaks(sum_cer,'MinPeakProminence',thresh1,'WidthReference','halfheight');
total(4,1) = LOCS(find(PKS == max(PKS)))./sec;
total(4,2) = widths(find(PKS == max(PKS)))./sec;

clear thresh2
clear thresh1
clear PKS
clear LOCS
clear widths

t1(1) = max(sum_pfc);
t1(2) = max(-sum_pfc);
thresh2 = max(t1);
thresh1 = thresh2 .* 0.25;
[PKS,LOCS,widths] = findpeaks(-sum_pfc,'MinPeakProminence',thresh1,'WidthReference','halfheight');
total(5,1) = LOCS(find(PKS == max(PKS)))./sec;
total(5,2) = widths(find(PKS == max(PKS)))./sec;

clear thresh2
clear thresh1
clear PKS
clear LOCS
clear widths

cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/SVA/fourier';

save total_four total
save functions functions
