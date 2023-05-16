# Project1
Investigating modelling of the haemodynamic response
Study 1 & 2 CAMCAN
__________________________________________________________________________________
E:/Study_1_and_2 > CAMCAN > full_run
1st_level
This contains a folder for each of the analyses but with the suffix 1 which indicates just a single participant is saved here (for modelling purposes):
Hrf (canonical model)
Hrf_td (canonical with derivative)
Fourier (fourier set)
Hrf_td_fourier (canonical with derivative controlling for fourier set)
Fourier_hrf_td (fourier set controlling for canonical with derivatives)
There is also a subfolder called ‘1st_level’ in which the same structure is found, only these are the full set of participants, and have been compressed to save space. Due to the sample size the sample split into four separate compressed files (first_140, second_140, third_140, fourth_140).
2nd_level
Under the subfolder ‘conimages’ there is all data pertaining to the second level analysis. Within this there are five subfolders pertaining to each of the analyses with the suffix ‘conimages’ (such as ‘hrf_conimages’ for the canonical model). This saved con images across each age group with relevant subfolders, but critically has a subfolder ‘1_con’ which contains the output from the main second level analysis for study 2, looking across age groups. Within ‘1_con’ there are beta, con, and SPM files for the analysis, with one factor of age and seven levels, however for flexible models there is a second factor of basis_function with 3 or 7 levels. There is also a subfolder ‘baseline’ which contains a basic 2nd level analysis used to ascertain mean baseline signal across participants within each age group.
2nd_level_group
This contains data from the 2nd level analysis but for study 1, looking at all participants as one group irrespective of age. There is again a sub folder for each model, and within these there is also a mean baseline signal analysis.
Note on Percentage Signal Change
SPM automatically sets the mean signal over the brain to be 100. So when we have an amplitude of e.g. 0.2, this means both 0.2% of the mean signal, and an absolute value of 0.2. This is percentage change in signal, percentage of the mean signal. However GM has a higher signal than elsewhere, and so we need to ascertain local mean signal to adjust our percentage. To do this we take the final column in the design matrix which is mean signal. If this is 250, all we need to do is take our absolute signal 0.2, which is also 0.2%, divide by 250 and multiply by 100. What we are essentially doing is downscaling this % signal change by 2.5 as the baseline is 2.5 times higher than actually anticipated. To form this third column I run a 2nd level analysis just on the final beta values from the 1st level analysis. This is fine as the con image is the summation of all relevant betas, and I have only one beta.
__________________________________________________________________________________
Preprocessing and analysis scripts in order of application
Field map/realign/unwarp/coregistration
Field mapping, realignment and unwarping, co-registering to T1 and segmentation was carried out in a single script:
/CAMCAN/full_run/aFM_realign_coreg_coreg_segment_V2.mat
The jobfile is located in:
/CAMCAN/full_run/batch/Up_to_seg_13May_V2_job.m

Realignment outliers
The realignment parameters are then checked, the file located in:
/CAMCAN/full_run/pathways/rp_pathways_raw.txt
The script to do this is located in:
/CAMCAN/full_run/b_check_rp_files_V2.m

QA
Next the signal is analysed for quality assurance:
/CAMCAN/full_run/c1_check_nifti_outliers.m
Participant data is taken from:
/CAMCAN/full_run/pathways/epi_files.txt
Files are saved in:
/CAMCAN/full_run/checks/QA/range
Outputs include:
Results (key data)
a plot for each participant
stack_rand (a list of all outliers and an equal number of randomly selected included participants, the order of which are randomised)
grand_out (included ps)
grand_in (outliers)

QA continued
The randomised list of outliers with included ps is carried forward via:
/CAMCAN/full_run/c2_check_nifti_outlier_vs_control.m
The outputs are saved in:
/CAMCAN/full_run/checks/QA/range/outliers
And include:
Results (key parameters)
A plot for each participant

Outlier removal
Final outliers are removed via:
/CAMCAN/full_run/d_remove_outliers.txt
An outliers folder is made in the raw data directories, and the relevant data shifted across

Create Dartel Template
The following folder creates a pathway for each included participant, in preparation for creation of the Dartel template:
/CAMCAN/full_run/e_Create_rc_paths.m
This uses:
/CAMCAN/full_run/pathways/t1_files_out.txt
The resulting data is then copied and pasted into:
/CAMCAN/full_run/e_load_rc1_2_job.m
Then the Dartel template is created using:
/CAMCAN/full_run/f_create_dartel_template_noloop.m

Dartel Normalisation
Dartel normalisation then takes place via:
/CAMCAN/full_run/ga_dartel_norm.m
Using the batch script:
/CAMCAN/full_run/batch/part2_dartel_FM_job.m
Mask check (no. voxels)
The 1st level analysis was then run preliminarily, after which the resulting masks were checked for the number of voxels containing signal:
/CAMCAN/full_run/gb_check_mask.m
Using participant data from:
/CAMCAN/full_run/con_files_list_old.txt
Standardised mask check
An additional check was run looking at how well each participant meets a standardised mask:
/CAMCAN/full_run/gc_check_norm_via_mask_V3.m
Outputs were saved to:
/CAMCAN/full_run/checks/check_normalisation/first
Then upon second run they were saved to:
/CAMCAN/full_run/checks/check_normalisation

Manual co-reg check
To run manual checks on random slices the following script was used to speed the process:
/CAMCAN/full_run/gcd_check_reg.m

Fourier window
The length of the fourier basis set window was established via:
/CAMCAN/full_run/ab_cross_correlations.m
The necessary files were generated first iteratively via:
/CAMCAN/full_run/checks/check_cross_correlations/basic_fourier_script.m
Outputs to:
/CAMCAN/full_run/checks/check_cross_correlations

1st level
Next all 1st level analyses were run:
/CAMCAN/full_run/h_1st_Level_GammaTD.m
/CAMCAN/full_run/i_1st_Level_fourier.m
/CAMCAN/full_run/j_1st_Level_Gamma.m
/CAMCAN/full_run/k_1st_Level_GammaTD_fourier.m
/CAMCAN/full_run/l_1st_Level_fourier_hrfTD.m

Move/rename con files
For the 2nd level analysis we moved and rename con files via the following 4 scripts:
/CAMCAN/full_run/m_RenameConFiles_for_2ndAnalysis_1st
/CAMCAN/full_run/m_RenameConFiles_for_2ndAnalysis_2nd
/CAMCAN/full_run/m_RenameConFiles_for_2ndAnalysis_3rd
/CAMCAN/full_run/m_RenameConFiles_for_2ndAnalysis_4th

Sort by age
These are then split into their respective age groups:
/CAMCAN/full_run/n_split_cons_into_age_groups
Outputting to each mHRF within:
/CAMCAN/full_run/2nd_level/conimages

Final list
The final N list with some additional participant data was located in:
/CAMCAN/full_run/pathways/demo_finalN.mat

2nd level – study 2
For the 2nd level analysis looking at each age group separately the files are located in:
/CAMCAN/full_run/2nd_level/conimages/hrf_conimages/1_con
/CAMCAN/full_run/2nd_level/conimages/hrf_td_conimages/1_con
/CAMCAN/full_run/2nd_level/conimages/fourier_conimages/1_con
/CAMCAN/full_run/2nd_level/conimages/fourier_hrftd_conimages/1_con
/CAMCAN/full_run/2nd_level/conimages/hrftd_fourier_conimages/1_con

2nd level – study 1
For the 2nd level analysis looking at all the age groups together, the scripts are located at:
/CAMCAN/full_run/2nd_level_group/hrfc.m
/CAMCAN/full_run/2nd_level_group /hrftd.m
/CAMCAN/full_run/2nd_level_group /fourier.m
/CAMCAN/full_run/2nd_level_group /fourier_hrftd.m
/CAMCAN/full_run/2nd_level_group /hrftd_fourier.m

The baseline analyses were run via:
/MRIWork/MRIWork06/nr/matthew_danvers/CAMCAN/full_run/2nd_level_group /hrfc/baseline/baseline.m
/MRIWork/MRIWork06/nr/matthew_danvers/CAMCAN/full_run/2nd_level_group /hrftd/baseline/baseline.m
/MRIWork/MRIWork06/nr/matthew_danvers/CAMCAN/full_run/2nd_level_group /fourier/baseline/baseline.m
__________________________________________________________________________________
Results for study 1
Definition of GM and WM
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/GM_vs_WM/check_GM_WM_values.m
This allows us to check how much overlap there is between GM and WM depending upon the threshold we set.	

Table 1
Binarised ROI masks were in the following locations:
/CAMCAN/full_run/2nd_level/conimages/M1_left_bin.nii
/CAMCAN/full_run/2nd_level/conimages/A1_bin.nii
/CAMCAN/full_run/2nd_level/conimages/V1_bin.nii
/CAMCAN/full_run/2nd_level/conimages/cer_bin.nii
/CAMCAN/full_run/2nd_level/conimages/Fp1_bin.nii

Binarised F maps were in the following locations:
/CAMCAN/full_run/2nd_level_group/hrfc
/CAMCAN/full_run/2nd_level_group/hrftd 
/CAMCAN/full_run/2nd_level_group/fourier 
/CAMCAN/full_run/2nd_level_group/fourier_hrftd 
/CAMCAN/full_run/2nd_level_group/hrftd_fourier 
They were called the following with prefixes of ‘h_’, ‘htd_’, ‘f_’, ‘fh_’, or ‘hf_’ depending on the model:
m1_bin.nii
a1_bin.nii
v1_bin.nii
cer_bin.nii
fp1_bin.nii

mHRF	ROI	F_vol	ROI_vol	%
HRFc	M1	6118.875	10040	60.94
 	A1	6969.375	7059	98.73
 	V1	25029	32662	76.63
 	Cer	64418.63	180343	35.72
	Fp1	4357.125	28001	15.56
	all	891594		
HRFtd	M1	9470.25	10040	94.33
 	A1	6969.375	7059	98.73
 	V1	25180.88	32662	77.10
 	Cer	82042.88	180343	45.49
	Fp1	5076	28001	18.13
	all	1329993		
Fourier	M1	9470.25	10040	94.33
 	A1	6969.375	7059	98.73
 	V1	25180.88	32662	77.10
 	Cer	82650.38	180343	45.83
	Fp1	5089.5	28001	18.18
	All	1324603		
Fourier(H)	M1	5862.375	10040	58.39
 	A1	5929.875	7059	84.00
 	V1	18511.88	32662	56.68
 	Cer	18461.25	180343	10.24
	Fp1	283.5	28001	1.01
	All	488473.9		
HRFtd(F)	M1	7462.125	10040	74.32
 	A1	6969.375	7059	98.73
 	V1	23331.38	32662	71.43
 	Cer	30634.88	180343	16.99
	Fp1	0	28001	0.00
	All	602734.5	 	

These comparisons worked by volume as they overlapped in MNI space, although the voxels do not match as ROI masks had 1mm voxels (151 x 188 x 154) and F masks had 1.5mm voxels (121 x 145 x 121). Therefore these comparisons only worked in FSLstats, and would not work in Matlab.

Table 1 cont
The five relevant scripts are in:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/gm_wm_other
The outputs are with the scripts, containing the list of how many voxels resided within GM, WM or other. 
F masks were in:
/CAMCAN/full_run/2nd_level_group /hrfc/h_all.nii
/CAMCAN/full_run/2nd_level_group /hrftd/htd_all.nii
/CAMCAN/full_run/2nd_level_group /fourier/f_all.nii
/CAMCAN/full_run/2nd_level_group /fourier_hrftd/fh_all.nii
/CAMCAN/full_run/2nd_level_group /hrftd_fourier/hf_all.nii
The GM and WM templates matched the number of voxels in the F masks (121 x 145 x 121) but had smaller voxels (1mm vs 1.5mm). Therefore these could be compared voxel for voxel within matlab, but not volume for volume.

Table 1 cont
The binned F masks over the whole brain are located below:
/CAMCAN/full_run/2nd_level_group /hrfc/h_all_bin.nii
/CAMCAN/full_run/2nd_level_group /hrftd/htd_all_bin.nii
/CAMCAN/full_run/2nd_level_group /fourier/f_all_bin.nii
/CAMCAN/full_run/2nd_level_group /fourier_hrftd/fh_all_bin.nii
/CAMCAN/full_run/2nd_level_group /hrftd_fourier/hf_all_bin.nii
F masks were 121 x 145 x 121 (1.5mm)

SVA/RA (single voxel analysis/regional analysis)
Here there is an hrfc, hrftd and fourier folder within:
/CAMCAN/full_run/2nd_level/conimages/SVA
In each there is a find_peaks.m script to be run independently, then in the SVA file there is a plot_functions.m script. Saved as figure1.jpg
The beta values are taken from the alternative 2nd level analysis.
	HRFc	HRFtd	Fourier
	PL	FWHM	PL	FWHM	PL	FWHM
M1	5.17	5.26	4.31	3.30	4.53	3.40
A1	5.17	5.26	4.06	3.33	4.29	3.59
V1	5.17	5.26	4.19	3.38	4.41	3.57
Cer	5.17	5.26	4.31	3.67	4.53	3.71
pfc	5.17	5.26	7.14	6.79	7.59	9.63

Next the analysis across ROIs is located in:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/ROIs
The script is called:
a_plot_all_Voxels_fourier.m
Then run:
Separate_into_ROIs.mat producing ROI_list.mat
This is then saved as ROI_analysis and ROI_analysis_out (outliers removed) within:
Study_1_and_2/Study_1/SPSS

Whole GM Analysis
The following 3 scripts were used to analyse all significant voxels that fell within grey matter, across the 3 mHRFs, everything done at the alternative 2nd level of analysis:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/a_plot_all_Voxels_hrfc_TPM_v3
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/a_plot_all_Voxels_hrftd_TPM_v3
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/a_plot_all_Voxels_fourier_TPM_v3
The results of these are found in the files:
GM_fourier_v6.mat
GM_HRFtd_v6.mat
GM_HRFc_v6.mat

Figure 2 is then plotted using:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/plot_histograms_GM_v3.m

Next the flexible models are compared to the canonical, using:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/compare_to_canonical_NO_OUTREM_all_bimodal.m
This outputs 3 files, c2c_results_NO_REM_all, c2c_range_NO_REM_all and saved in the c2c folder, results.
Then we compare the flexible models to one another:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/ create_ANOVA_data_NO_OUTREM_all_bimodal.m
This outputs multiple files:
GM_pos_NOREM_all: positive only data
GM_neg_NOREM_all: negative only data
Fourier_NOREM_all: all fourier data
Hrftd_NOREM_all: all HRFtd data
GM_results_four_hrftd_comparison_NOREM_all: initial information about final results
All of this was done using the alternative second level analyses.
We then plot the WMPSR tests Group_plot_NOREM_all_bimodal.m and save in /CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/GM_comparisons/create_ANOVA as all_differences.jpg
We run general comparisons to canonical plot_histograms_GM_v3
	Htd pl+	F pl+	Htd pl-	F pl-	Htd f2+	F fw+	Htd fw-	F fw-
Z	260.47	260.40	171.72	171.49	259.99	259.99	171.68	171.46


Simulation
This is located in:
/CAMCAN/full_run/2nd_level/conimages/simulation
There are 5 functions to be modelled: HRFc.mat, short_pos.mat, long_pos.mat, sublong.mat and short_fwhm.mat
The first three were created using Create_data.m, short_fwhm using Create_more_data.m, and sublong using Create_sublong.m
Also the basis functions are saved here as HFtd.mat and fourier.mat
I then run the tests in:
/CAMCAN/full_run/2nd_level/conimages/simulation/lin_reg
This contains summary_table_four.m, summary_table_HRFtd.m and summary_table_HRFc.m. 
I then call all this information for HRFtd and Fourier independently using the scripts, and this creates figure 3 as well as bringing forward all key data under the variable names four_table.mat and HRFtd_table.mat.
The actual analyses are saved under: 
Study_1_and_2/Study_1/SPSS
The data in the folder simulation is Fourier_simulation and HRFtd_simulation and Fourier_simulation_noHanning, with outputs in HRFc_sim_out, HRFtd_sim_out, fourier_noHan_output and fourier_sim_output
There is also final check using a run which is based on the actual timing of the study events
The script is called longer_run.m, and then SPSS files fourier_full, fourier_full_output, hrftd_full, and hrftd_full_output.

Logistic Regression
This data is held within:
Study_1_and_2/Study_1/SPSS
With a script logistic_regression and output file logistic_regression_output

Appendices
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/plot_summed_functions_v2.m
Save the output as Appendix_A.jpg
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/total_data_v3.m
This outputs AppendixN_v3.mat
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/cerebellar_and_aPFC_coordinates
The script is called aPFC_check_FH.m and the output is total_pfc_FH.mat
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/cerebellar_and_aPFC_coordinates
The script is called cerebellar_aPFC_check.m and the outputs are called appendix.jpg, cerebellum.mat and aPFC.mat

Peak Latency and FWHM via fourier
The script is called:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/create_fourier_mask.m
This saves two files:
pl.nii and fwhm.nii

Not included in the paper
I ran through all coordinates in which the Fourier basis set finds significance and HRFc does not (within grey matter), then plot a random selection:
/CAMCAN/full_run/2nd_level/conimages/all_voxels/version_3/visualisation/fourier_only.m
Output of the raw file saved as:
Total.mat

Results for study 2
This script found all the voxels which were significant across all age groups. Did not have to be in GM
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/parameter_analysis_accAGE3.m
The output files end with accAGE and are saved in:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/check
I then create Figure 1 using:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/create_data_GM.m
This script also totals the peak latency and FWHM data for Figure 4 a and b, with and without outliers:
data_GM.mat
data_GM_plOUT.mat
data_GM_fwOUT.mat
I then run a separate script for the undershoot (Figure 4c), as this may have had some zero values (where an undershoot could not be found):
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/create_data_GM_undershoot.m
This outputs:
data_GM_US.mat
data_GM_usOUT2.mat

Age x NBR
First level coordinates were checked to establish the prevalence of NBRs in each age group
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/1st_level/investigate_just_age3.m
This outputted:
Age_data_all.mat
Age_correlations_all.mat

Undershoot investigation
The canonical function percentage beta weighting was calculated using the following script on lines 706-723:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/create_data_GM_undershoot.m
This is seen in the output file data_GM_US.mat in columns 25-27 (original betas are in 22-24). The percentage beta values are reassigned their positive or negative weighting once the percentage is calculated, but this does not affect the canonical as all values were positive.
The distributions of beta weightings can be found:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/plot_beta_age_comparison.m

Number of Voxels
The number of voxels within GM were investigated for each age group, within each model. The script is found in:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/number_of_voxel/number_of_voxel_masks.m
Outputs are in .mat and .nii formats, one for each age, within each model. These could then be analysed via fslstats.

Visualisations
Run using:
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/visualisation/visualisation.m
This calculated the voxels that showed significance within grey matter, across age groups. The file is saved as image.nii and is modified in SPM to align with the MNI brain.
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/visualisation/visualisation_agediff.m
This calculated the mean peak latency and FWHM of the 3 oldest age groups, and 3 youngest, for the GM coordinates. It then subtracts young from old to make a difference mask, outputting peak_lat.nii and fwhm.nii
/CAMCAN/full_run/2nd_level/conimages/age_effects/parameter_analysis/GM/visualisation/visualisation_agediff_US.m
This does the same for the undershoot coordinates, outputting undershoot.nii


For the graphs and analysis in SPSS
Study_1_and_2/Study_2/SPSS
This location houses the data for can_weight, PL_FW_wholedata, US_wholedata and an outlier version for each.
Study_1_and_2/Study_2/SPSS/extra
This location houses matlab files and the outputs, as well as the data in an excel spreadsheet

L:/archive/matthew_danvers/camCAN/raw_data
This folder contains all the pre-processed data for:
epi_smt: EPI scans within this folder, broken down into four batches of participants
Anat.tar.gz: anatomical scans
Fmap_smt.tar.gz: field maps
