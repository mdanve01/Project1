cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/2nd_level/conimages/simulation'
short = importdata('short_pos.mat');
long = importdata('long_pos.mat');
can = importdata('HRFc.mat');

z = 1
for n = 1:260;
    try
        clear x
        clear y
        clear yy
        x = find(can(z:260) == short(n),1);
        y = (x + (z - 1)) - n;
        yy = (x + (z - 1)) + y;
        z = x;
        diff(yy) = short(n);
    end
end

for n = 1:length(diff) ./ 3;
    try
        if diff(n .* 3) > diff((n .* 3) - 3);
            diff((n .* 3) - 2) = diff((n .* 3) - 3) + (abs(diff(n .* 3) - diff((n .* 3) - 3)) .* 0.333);
            diff((n .* 3) - 1) = diff((n .* 3) - 3) + (abs(diff(n .* 3) - diff((n .* 3) - 3)) .* 0.667);
        elseif diff(n .* 3) < diff((n .* 3) - 3);
            diff((n .* 3) - 2) = diff((n .* 3) - 3) - (abs(diff(n .* 3) - diff((n .* 3) - 3)) .* 0.333);
            diff((n .* 3) - 1) = diff((n .* 3) - 3) - (abs(diff(n .* 3) - diff((n .* 3) - 3)) .* 0.667);
        end
    catch
        diff((n .* 3) - 2) = diff(n .* 3) .* 0.333;
        diff((n .* 3) - 1) = diff(n .* 3) .* 0.667;
    end
end

diff2 = diff(1:260);

plot(diff2);    

thresh1 = (max(diff2)) .* 0.5;
sec = 260 ./ 32;
[PKS,LOCS,widths] = findpeaks(diff2,'MinPeakProminence',thresh1);
table(1,1) = PKS ./ sec;
table(2,1) = LOCS ./ sec;
table(3,1) = widths ./ sec;

save sublong diff2
