% % enter the name of the matlab script below, followed by (subject_number)
function j_1st_Level_Gamma(subject_number);

    disp('inside the main matlab function');
    disp('Processing Subject');
    disp(subject_number)

% Template batch script for SPM
% N.Ramnani, December 2013 modified by M.Danvers 2020 to be applied to the
% cluster's worker nodes
% 
% Originally by N.Ramnani, 18th November 2004.
% Generates spm models for multiple subjects, estimates them and sets
% contrasts
%===========================================================================
% Load user-specified variables
%---------------------------------------------------------------------------
    
% clear all;
    cwd =  '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/';
    cd(cwd); 
    addpath /usr/local/apps/psycapps/spm/spm12-r7487;
    addpath /MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/;
    
    spm('defaults','FMRI')
    spm_get_defaults;
    %defaults.analyze.flip     = 1; % <<= Very important.  Relates to L/R
    defaults.stats.maxmem   = 2^30;
    cwd =  '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/';
    cd(cwd);


% load the matrices containing onset times - held within each subject's
% folder
a = strcat('/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/raw_data/epi_smt/fourth_140/sub-',subject_number,'/epi_smt');
cd(a);
load audonly.mat
load vidonly.mat
load audvid300.mat
load audvid600.mat
load audvid1200.mat


%==========================================================================
% Specify design
    
    %===========================================================================
    % number of scans and session
    %---------------------------------------------------------------------------
    SPM.nscan       =   [261];    %724
  

    % basis functions and timing parameters
    %---------------------------------------------------------------------------
    % OPTIONS:'hrf'
    %         'hrf (with time derivative)'
    %         'hrf (with time and dispersion derivatives)'
    %         'Fourier set'
    %         'Fourier set (Hanning)'
    %         'Gamma functions'
    %         'Finite Impulse Response'
    %---------------------------------------------------------------------------
   SPM.xBF.name       = 'hrf';
    SPM.xBF.length     = 32.0125;                % length in seconds NB modified this to match the manual output
    SPM.xBF.order      = 1;                 % order of basis set				
    SPM.xBF.T          = 16;                % number of time bins per scan (leave it as it is)
    SPM.xBF.T0         = 8;                 % first time bin (see slice timing, leave it as it is) NB modified this to match the manual output
    SPM.xBF.UNITS      = 'secs';            % OPTIONS: 'scans'|'secs' for onsets
    SPM.xBF.Volterra   = 1;                 % OPTIONS: 1|2 = order of convolution; 2 creates regressors by multiplying the original one
    SPM.xBF.dt         = 0.1231;            % TR ./ number of time bins
    
    % Trial specification: Onsets, duration (UNITS) and parameters for modulation
    %---------------------------------------------------------------------------
     %for session 1    
%      param_x=[1:(1180*2)];
%      param=exp(0.0001*-param_x);
%      param_norm=param*(max(param)-min(param));
     

     
        SPM.Sess(1).U(1).name      = {'audvid300'};
        SPM.Sess(1).U(1).ons       = audvid300(1,:);
        SPM.Sess(1).U(1).dur       = 0;
        SPM.Sess(1).U(1).P(1).name = 'none';    % 'none', 'time' or 'other'
%         SPM.Sess(1).U(1).P(1).P    = param_norm(round(SPM.Sess(1).U(1).ons(:))) % comment out if 'none' above
%         SPM.Sess(1).U(1). P(1).h   = 1;   % comment out if 'none' above

        SPM.Sess(1).U(2).name      = {'audvid600'};
        SPM.Sess(1).U(2).ons       = audvid600(1,:);
        SPM.Sess(1).U(2).dur       = 0;
        SPM.Sess(1).U(2).P(1).name = 'none';    % 'none', 'time' or 'other'
%         SPM.Sess(1).U(1).P(1).P    = param_norm(round(SPM.Sess(1).U(1).ons(:))) % comment out if 'none' above
%         SPM.Sess(1).U(1). P(1).h   = 1;   % comment out if 'none' above

        SPM.Sess(1).U(3).name      = {'audvid1200'};
        SPM.Sess(1).U(3).ons       = audvid1200(1,:);
        SPM.Sess(1).U(3).dur       = 0;
        SPM.Sess(1).U(3).P(1).name = 'none';    % 'none', 'time' or 'other'
%         SPM.Sess(1).U(1).P(1).P    = param_norm(round(SPM.Sess(1).U(1).ons(:))) % comment out if 'none' above
%         SPM.Sess(1).U(1). P(1).h   = 1;   % comment out if 'none' above
        
        SPM.Sess(1).U(4).name      = {'audonly'};
        SPM.Sess(1).U(4).ons       = audonly(1,:);
        SPM.Sess(1).U(4).dur       = 0;
        SPM.Sess(1).U(4).P(1).name = 'none';    % 'none', 'time' or 'other'
%         SPM.Sess(1).U(2).P(1).P    =  param_norm(round(SPM.Sess(1).U(2).ons(:))); % comment out if 'none' above
%         SPM.Sess(1).U(2). P(1).h   = 1;   % comment out if 'none' above
  
        SPM.Sess(1).U(5).name      = {'vidonly'};
        SPM.Sess(1).U(5).ons       = vidonly(1,:);
        SPM.Sess(1).U(5).dur       = 0;
        SPM.Sess(1).U(5).P(1).name = 'none';    % 'none', 'time' or 'other'
%         SPM.Sess(1).U(3).P(1).P    =  param_norm(round(SPM.Sess(1).U(3).ons(:))); % comment out if 'none' above
%         SPM.Sess(1).U(3). P(1).h   = 1;   % comment out if 'none' above
        
 
    
        % parametric
%         for s = 1:15
%         SPM.Sess(s).U(1).P(1).P    = [param_norm(round(SPM.Sess(s).U(1).ons(:)))]';
%         SPM.Sess(s).U(2).P(1).P    = [param_norm(round(SPM.Sess(s).U(2).ons(:)))]';
%         SPM.Sess(s).U(3).P(1).P    = [param_norm(round(SPM.Sess(s).U(3).ons(:)))]';
%         SPM.Sess(s).U(4).P(1).P    = [param_norm(round(SPM.Sess(s).U(4).ons(:)))]';    
%         end;
    % global normalization: OPTIONS:'Scaling'|'None'
    %---------------------------------------------------------------------------
    SPM.xGX.iGXcalc    = 'None';
    
    
    % low frequency confound: high-pass cutoff (secs) [Inf = no filtering]
    %---------------------------------------------------------------------------
    SPM.xX.K.HParam    = 128;  
    
    
    % intrinsic autocorrelations: OPTIONS: 'none'|'AR(1) + w' (do use AR
    % correction)
    %-----------------------------------------------------------------------
    SPM.xVi.form       = 'AR(1) + w';
    
    
    % specify data: matrix of filenames and TR (tell him where to get
    % smoothed files for each suject)
    %===========================================================================
    cd(a);
    
    files = spm_select('ExtFPList',{a},'swu*');
   
    SPM.xY.P        = [files];
    
% it is possible that if the path length string below (datadir{1} = etc.) are not of equal length then this fails (e.g. if one is srf and the other is swrf then swrf is one character longer)    
    
    SPM.xY.RT       = 1.97;                              % specify TR in seconds

   % design (user specified covariates: e.g. movement parameters)
   %---------------------------------------------------------------------------
    
% realignment parameters

rnam = {'X','Y','Z','x','y','z'};


fn = [];

    clear fn;
    % takes us to the location of the rp file
    cd(a);
    rps = strcat('rp_sub-',subject_number,'_epi_smt.txt');
    fn = importdata(rps);
    %this is where we can get stuck, if there is a different order e.g.
    %structural done last,this will vary and so enter the new file name in,
    %that suits.
	SPM.Sess.C.C = fn;
	SPM.Sess.C.name = rnam;

    
    %specify destination directories, this creates them
        new_name = strcat(subject_number,'_hrf_test');
        dest = new_name;
  


   
    ORIGspm=SPM;
    
   % configure subject-specific design matrices
        
        SPM.Sess  = ORIGspm.Sess;  % update session/subject information
        SPM.nscan = ORIGspm.nscan; % update number of scans
        SPM.xY.P  = files;         % update scan directory paths
        
        % Create and cd subject-specific results directory - ADJUST THE
        % DESTINATION DIRECTORY HERE ALSO NEEDS ADJUSTING AT THE NEXT ELVEL
        % OF ANALYSIS
        
        route = '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level'
        cd(route)
        mkdir 'hrf'
        dir_route = '/MRIWork/MRIWork06/nr/matthew_danvers/camCAN/full_run/1st_level/hrf';
        cd(dir_route)
        mkdir(dest);
        cd(dest); 
        pwd;
        SPM.swd=pwd; % tell SPM that this is the current analysis working directory
        
        % Configure design matrix
        % ====================================================================
        SPM = spm_fmri_spm_ui(SPM);
            
        % Estimate parameters
        % ====================================================================
        SPM = spm_spm(SPM);
    
        % Contrasts
        % ====================================================================
        
        % Set contrasts
        % Length of contrast must exactly match the number of columns in
        % design matrix
        % 5 basis functions, one contrast image generated per basis
        % function to take to second level
        %
        % contrast space, 3+3+6+1=13 columns

% not including time, with temporal and dispersion derivatives

cons{1}    = [1 0 0 0 0 0 0 0 0 0 0 0]; 
cons{2}    = [0 1 0 0 0 0 0 0 0 0 0 0];       
cons{3}    = [0 0 1 0 0 0 0 0 0 0 0 0];       
cons{4}    = [0 0 0 1 0 0 0 0 0 0 0 0];
cons{5}    = [0 0 0 0 1 0 0 0 0 0 0 0];
cons{6}    = [0 0 0 0 0 0 0 0 0 0 0 1];





cname{1}  = '1';
cname{2}  = '2';
cname{3}  = '3';
cname{4}  = '4';
cname{5}  = '5';
cname{6}  = '6';



        for i = 1:length(cons)
            
           if length(SPM.xCon)==0
        
              SPM.xCon = struct('name',{{'init'}},'STAT',[1],'c',[1],'X0',[1],'iX0',{{'init'}},'X1o',[1],'eidf',[],'Vcon',[],'Vspm',[]);
              SPM.xCon = spm_FcUtil('Set',cname{i},'T','c',cons{i}',SPM.xX.xKXs);
        
           else

        SPM.xCon(end+1) = spm_FcUtil('Set',cname{i},'T','c',cons{i}',SPM.xX.xKXs);
        
            end
        end

    % Evaluate contrasts
     spm_contrasts(SPM)  
     
    
    save SPM.mat
    
 
  

    
%      
% end

       
    SPM.Sess = []	 
% 
%     cd(dir_route);
%     clear SPM.mat
%     % go to the subject's directory
%     cd(dest)
%     % append to the type of analysis
%     new_h = strcat('hrf',subject_number,'_hrf_dervs')
%     load('SPM.mat'); 
%     clear hrf_dervs
%     % create a variable containing the derivatives
%     hrf_dervs = SPM.xX.X(:,1:5);
%     save (new_h, 'hrf_dervs');
%     % save again in subject's directory
%     cd(a)
%     save (new_h, 'hrf_dervs');
   
end

