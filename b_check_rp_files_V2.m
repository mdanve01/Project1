% load the rp text file
rp = importdata('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways/rp_pathways_raw.txt');

% movement threshold
move_thresh_max_tran = 2.5;
move_thresh_max_rot = 1;
% sets the maxmimum single shift between scans
shift_thresh_max_tran = 1.5;
shift_thresh_max_rot = 0.5;
    
% set number of participants
nrun = 645;
for n = 1:nrun;
    %imports realignment data
    sub = importdata(rp{n});
    sub_sqr = sub.^2;
    sub_pos = sqrt(sub_sqr);
    sub_tran = sub_pos(:,1:3);
    sub_rot = sub_pos(:,4:6);
    % specify subject ID in the 1st column of the matrix
    line = rp{n};
    name = line(67:74);
    result{n,1} = name;
    % specifies the max movement in each column (separating translations
    % and rotations)
    max1t = max(sub_tran);
    max1r = max(sub_rot);
    % specifies the max movement overall
    max2t = max(max1t);
    max2r = max(max1r);
    % adds to the result matrix with whether the max motion excedded
    % threshold, and gives the max motion
    if max2t > move_thresh_max_tran;
        result{n,2} = 'translation too large';
        result{n,3} = max2t;
    else
        result{n,2} = 'good';
        result{n,3} = max2t;
    end
    
     if max2r > move_thresh_max_rot;
        result{n,4} = 'rotation too large';
        result{n,5} = max2r;
    else
        result{n,4} = 'good';
        result{n,5} = max2r;
    end
    
    
    % looks at the first column, and calculates the difference between nth
    % row relative to nth + 1, looking for large, sudden shifts. adds this
    % to the first column of the mat file. The next column is then looked
    % at (adding to the mat file in the second column and so on).
    a = sub_pos(:,1);
    for m = 1:260;
        mp = m+1;
        mat(m,1) = a(mp)-a(m);
    end
    
    b = sub_pos(:,2);
    for m = 1:260;
        mp = m+1;
        mat(m,2) = b(mp)-b(m);
    end
    
    c = sub_pos(:,3);
    for m = 1:260;
        mp = m+1;
        mat(m,3) = c(mp)-c(m);
    end
    
    d = sub_pos(:,4);
    for m = 1:260;
        mp = m+1;
        mat(m,4) = d(mp)-d(m);
    end
    
    e = sub_pos(:,5);
    for m = 1:260;
        mp = m+1;
        mat(m,5) = e(mp)-e(m);
    end
    
    f = sub_pos(:,6);
    for m = 1:260;
        mp = m+1;
        mat(m,6) = f(mp)-f(m);
    end
    
    % squares and square routes to turn all values positive
    mat_pos1 = mat;
    mat_pos2 = mat_pos1.^2;
    mat_pos3 = sqrt(mat_pos2);
    % calculates the maximum single shift between scans, splitting between
    % translations and rotations
    max_shift = max(mat_pos3);
    t = max_shift(1:3);
    r = max_shift(4:6);
    max_shiftt = max(t);
    max_shiftr = max(r);
     
    % adds to the results file with shift info
    if max_shiftt > shift_thresh_max_tran;
        result{n,6} = 'trans shift too large';
        result{n,7} = max_shiftt;
    else
        result{n,6} = 'good';
        result{n,7} = max_shiftt;
    end
    
    % adds to the results file with shift info
    if max_shiftr > shift_thresh_max_rot;
        result{n,8} = 'rot shift too large';
        result{n,9} = max_shiftr;
    else
        result{n,8} = 'good';
        result{n,9} = max_shiftr;
    end
end        
        
    
    