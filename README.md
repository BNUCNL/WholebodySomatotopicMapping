# WholebodySomatotopicMapping <br>
Scripts here are related to fMRI dataset 'WholebodySomatotopicMapping' (https://openneuro.org/datasets/ds004044). <br>

# Experiment procedure <br>
1. Acqusition parameter: /MRI_EXP/acq_para/acqusition_parameter.pdf <br>
2. Stimuli: /MRI_EXP/stimuli <br>
3. Experiment procedure for anatomy: /MRI_EXP/mri_anatomy.m <br>
4. Experiment procedure for motor task: /MRI_EXP/fmri_motor.m <br>

# Preprocess procedure <br>
In the 'WholebodySomatotopicMapping', we processed a dataset for whole-body somatotopic mapping in humans following a five-step procedure including 1.preprocessing, 2.ICA decomposition, 3.IC classification, 4.artifacts removal and 5.ciftify. <br>

1. Preprocessing <br>
Discription: performed with fMRIPrep version 20.2.1 (https://www.fmriprep.org) <br>
Code: /preprocess/fmriprep_script.py <br>

2. ICA decomposition <br>
Discription: performed with a probabilistic ICA algorithm implemented in the FSL’s MELODIC version 3.15 (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC). <br>
Code: /preprocess/ICA.py <br>

3. IC classification <br>
Discription: Classification of ICs was done manually using Melview (http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Melview). <br>

4. Artifacts removal <br>
Discription: performed with FSL’s MELODIC version 3.15 (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC) <br>
Code: /preprocess/remove_A-IC.py <br>

5. Ciftify <br>
Discription: performed with Ciftify (https://github.com/edickie/ciftify) <br>
Code: /preprocess/ciftify_script.py <br>

# General linear model <br>
Discription: Run GLM timeseries analysis on single scan run and combine lower-level analyses to compute subject-level activity estimates using HCP pipelines TaskfMRIAnalysis (https://github.com/Washington-University/HCPpipelines) <br>
Code: /GLM/task_analysis.py <br>

# Technical validation <br>
Additionally, the technical quality of the datasets was validated in 5 aspects, temporal signal-to-noise ratio (tSNR), framewise displacement (FD), mean representational dissimilarities (MRD), task activation and coverage map. <br>

1. temporal signal-to-noise ratio (tSNR) <br>
Discription: the temporal signal-to-noise ratio within somatotopic cortices. <br>
Code: /validation/tSNR.py <br>

2. framewise displacement (FD) <br>
Discription: the distribution of head motion magnitude measured by frame-wise displacement. <br>
Code: /validation/FD.py <br>

3. mean representational dissimilarities (MRD) <br>
Discription: the mean representational dissimilarities(MRD) across all pairs of conditions calculated on each individual. <br>
Code: /validation/MRD.py <br>

4. task activation <br>
Discription: the activation maps from example contrasts. <br>
Code: /validation/activation_pattern.py <br>

5. coverage map <br>
Discription: a voxel-wise description for the brain coverage. <br>
Code: /validation/coverage_map.py <br>

