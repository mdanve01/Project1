cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways';
%%%%%% edit at source if need a different function
a = importdata('con_files_list.txt');
for n = 1:length(a);
    clear line;
    clear name;
    clear name2
    line = a{n};
    name = line(71:76);
    name2 = str2num(name);
    clear b
    clear c
   cd(a{n});
try
   b = niftiread('mask.nii');
   c = find(b);
   d = length(c);
   results(n,1) = d;
catch no_sig(n,1) = name2
end
end

stats(1,1) = min(results);
stats(1,2) = max(results);
stats(1,3) = mean(results);
stats(1,4) = median(results);
stats(1,5) = std(results);
stats(1,6) = max(results) - min(results);

colNames = {'min','max','mean','median','standard_dev','range'};
results_table = array2table(stats,'VariableNames',colNames)

hist(results,500)

thresh = 2.5;

thresh1 = mean(results) + (std(results).*thresh);
thresh2 = mean(results) - (std(results).*thresh);

for x = 1:length(a);
    clear line;
    clear name;
    clear name2;
    line = a{x};
    %%%% edit if changing the function, as this changes the length of the
    %%%% file path
    name = line(71:76);
    name2 = str2num(name);
    if results(x,1) > thresh1;
    elseif results(x,1) < thresh2;
        outlier(x,1) = name2;
        else outlier(x,1) = 999999;
    end
end

no_signal = sortrows(no_sig,1)
outliers = sortrows(outlier,1)
total_outlier = [no_signal; outliers]
