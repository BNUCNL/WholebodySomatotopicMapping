# WholebodySomatotopicMapping <br>
The code related to fMRI dataset 'WholebodySomatotopicMapping' (https://openneuro.org/datasets/ds004044) are provided here, including experimental programs for collecting data, batch commands for preprocessing, and scripts for analyzing data.

## Experimental programs
+ **Stimuli**
  + /MRI_EXP/stimuli
+ **Structural MRI scan**
  + /MRI_EXP/mri_anatomy.m
+ **Functional MRI scan**
  + /MRI_EXP/fmri_motor.m

## Preprocessing & Denoising
We processed the original data, including the following five steps: 
+ **Preprocessing**
  + Discription: Preprocessing for functional nifti data.
  + Software: fMRIPrep
  + Command: `fmriprep-docker <nifti-path> <derivatives-path> participant -w <workdir-path> --participant_label <subject> --output-space T1w fsnative --skip-bids-validation --fs-license-file <fs-license-path>`
  + Batch script: /preprocess/fmriprep_script.py
+ **ICA decomposition**
  + Discription: Independent component analysis (ICA) to decompose a single or multiple 4D data sets into different spatial and temporal components.
  + Software: FSL MELODIC
  + Command: `melodic -i <func-data> -o <output-path> -v --nobet --bgthreshold=1 --tr=<TR> -d 0 --mmthresh=0.5 --report`
  + Batch script: /preprocess/ICA.py
+ **IC classification**
  + Discription: Classification of ICs was done manually.
  + Software: FSL Melview
+ **Artifacts removal**
  + Discription: Remove chosen components (normally obvious scanner-related or physiological artefacts) from original data.
  + Software: FSL Regfilt
  + Command: `fsl_regfilt -i <func-data> -o <denoised-data> -d melodic_mix -f <artifact-IC>`
  + Batch script: /preprocess/remove_A-IC.py
+ **Ciftify**
  + Discription: Will convert a nifti functional / freeserfer output directory into an HCP output directory.
  + Software: Ciftify
  + Command: `ciftify_subject_fmri --ciftify-work-dir <workdir-path> <func-data> <subject-id> <run-id>`
  + Batch script: /preprocess/ciftify_script.py

## General linear model
Run GLM analyses on HCP-style data (after ciftify) by HCPpipelines (https://github.com/Washington-University/HCPpipelines).
+ Batch script: /GLM/task_analysis.py

## Technical validation
Additionally, the technical quality of the datasets was validated in 5 aspects, temporal signal-to-noise ratio (tSNR), framewise displacement (FD), mean representational dissimilarities (MRD), task activation and coverage map. <br>
+ **Temporal signal-to-noise ratio (tSNR)** 
  + Discription: the temporal signal-to-noise ratio within somatotopic cortices. 
  + Code: /validation/tSNR.py 
+ **Framewise displacement (FD)** 
  + Discription: the distribution of head motion magnitude measured by frame-wise displacement. 
  + Code: /validation/FD.py 
+ **Mean representational dissimilarities (MRD)** 
  + Discription: the mean representational dissimilarities(MRD) across all pairs of conditions calculated on each individual. 
  + Code: /validation/MRD.py 
+ **Task activation** 
  + Discription: the activation maps from example contrasts. 
  + Code: /validation/activation_pattern.py 
+ **Coverage map** 
  + Discription: a voxel-wise description for the brain coverage. 
  + Code: /validation/coverage_map.py 




