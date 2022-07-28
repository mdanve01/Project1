cd '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/pathways'
 t1 = importdata('t1_files_out.txt')
 
 %%%%%%% !!!!!!! %%%%%%%

 nrun = 558 % enter the number of subjects here

for xxx = 1:nrun
    clear gen
    clear sub_name
    clear route
    clear rc1
    clear rc2
    
    gen = t1{xxx} % establishes the relevant path  
    route = gen(1:77)
    sub_name = gen(64:71)
    rc1 = strcat(route,'rc1sub-',sub_name,'_T1w.nii,1')
    rc2 = strcat(route,'rc2sub-',sub_name,'_T1w.nii,1')
    mat_rc1{xxx} = rc1
    mat_rc2{xxx} = rc2

  
end    


clear inputs
clear jobfile
clear jobs

ccc = vertcat(mat_rc1{:})
ddd = vertcat(mat_rc2{:})
