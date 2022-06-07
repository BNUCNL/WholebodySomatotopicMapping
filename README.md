# WholebodySomatotopicMapping
Scripts here are related to fMRI dataset 'WholebodySomatotopicMapping' (https://openneuro.org/datasets/ds001769](https://openneuro.org/datasets/ds004044)).

# Preprocess and denoise procedure
In the 'WholebodySomatotopicMapping', we processed a dataset for whole-body somatotopic mapping in humans following a five-step procedure including 1.preprocessing, 2.ICA decomposition, 3.IC classification, 4.artifacts removal and 5.ciftify.

1. Preprocessing  
Discription: performed with fMRIPrep version 20.2.1
Code: /preprocessing/preprocess.py

2. ICA decomposition  
Discription: performed with a probabilistic ICA algorithm implemented in the FSL’s MELODIC version 3.15 (https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC).  
Code: /ICA_denoise/ICA.py

3. IC classification  
Discription: Classification of ICs was done manually using Melview (http://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Melview).

4. Artifacts removal  
Discription: performed with FSL’s MELODIC version 3.15  
Code: /ICA_denoise/remove_A-IC.py

5. Ciftify
Discription: performed with Ciftify version 
Code: 

6. GLM
Discription: performed with HCPPipeline version
Code: 

# Technical validation


