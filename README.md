# WholebodySomatotopicMapping
Scripts here are related to fMRI dataset 'WholebodySomatotopicMapping' (https://openneuro.org/datasets/ds001769](https://openneuro.org/datasets/ds004044)).

# Experiment procedure
1. Acqusition parameter: /MRI_EXP/acq_para/acqusition_parameter.pdf
2. Stimuli: /MRI_EXP/stimuli
3. Experiment procedure for anatomy: /MRI_EXP/mri_anatomy.m
4. Experiment procedure for motor task: /MRI_EXP/fmri_motor.m

# Preprocess procedure
In the 'WholebodySomatotopicMapping', we processed a dataset for whole-body somatotopic mapping in humans following a five-step procedure including 1.preprocessing, 2.ICA decomposition, 3.IC classification, 4.artifacts removal and 5.ciftify.

1. Preprocessing  
Discription: performed with fMRIPrep version 20.2.1 (https://www.fmriprep.org)
Code: /preprocess/fmriprep_script.py

2. ICA decomposition  
Discription: performed with a probabilistic ICA algorithm implemented in the FSL’s MELODIC version 3.15 (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC).  
Code: /preprocess/ICA.py

3. IC classification  
Discription: Classification of ICs was done manually using Melview (http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Melview).

4. Artifacts removal  
Discription: performed with FSL’s MELODIC version 3.15 (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC)
Code: /preprocess/remove_A-IC.py

5. Ciftify
Discription: performed with Ciftify (https://github.com/edickie/ciftify)
Code: /preprocess/ciftify_script.py

# General linear model
Run GLM timeseries analysis on single scan run and combine lower-level analyses to compute subject-level activity estimates using HCP pipelines TaskfMRIAnalysis (https://github.com/Washington-University/HCPpipelines)
Discription: performed with HCPPipeline version
Code: /GLM/task_analysis.py

# Technical validation
Additionally, the technical quality of the datasets was validated in 5 aspects, temporal signal-to-noise ratio (tSNR), framewise displacement (FD), mean representational dissimilarities (MRD), task activation and coverage map.

1. temporal signal-to-noise ratio (tSNR)
Discription: the temporal signal-to-noise ratio within somatotopic cortices.
Code: /validation/tSNR.py

2. framewise displacement (FD)
Discription: the distribution of head motion magnitude measured by frame-wise displacement.
Code: /validation/FD.py

3. mean representational dissimilarities (MRD)
Discription: the mean representational dissimilarities(MRD) across all pairs of conditions calculated on each individual.
Code: /validation/MRD.py

4. task activation
Discription: the activation maps from example contrasts.
Code: /validation/activation_pattern.py

5. coverage map
Discription: a voxel-wise description for the brain coverage.
Code: /validation/coverage_map.py

