#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Activation pattern of finger-wrist and upper-lower.

@author: Sai Ma
"""

import os
import numpy as np
import pandas as pd
import nibabel as nib

# path and input
cifti_dir = '/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify/'
save_header = nib.load('/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify/sub-01/MNINonLinear/Results/ses-1_task-motor/ses-1_task-motor_hp200_s4_level2.feat/sub-01_ses-1_task-motor_level2_zstat_Tongue-Avg_hp200_s4.dscalar.nii').header
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
run_list = ['run-1', 'run-2', 'run-3', 'run-4', 'run-5', 'run-6']
central_sulcus_gyrus_mask = nib.load('/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/HCP_atlas/central_sulcus_gyrus_mask.dscalar.nii').get_fdata()

# finger-wrist / upper-lower
fw = np.zeros((1, 91282))
ul = np.zeros((1, 91282))
for subject in subject_list:
    print(subject)
    fw = fw + nib.load(os.path.join(cifti_dir, 
                                    subject, 
                                    'MNINonLinear', 
                                    'Results', 
                                    'ses-1_task-motor', 
                                    'ses-1_task-motor_hp200_s4_level2.feat', 
                                    subject+'_ses-1_task-motor_level2_zstat_Finger-Wrist_hp200_s4.dscalar.nii')).get_fdata()
    ul = ul + nib.load(os.path.join(cifti_dir, 
                                    subject, 
                                    'MNINonLinear', 
                                    'Results', 
                                    'ses-1_task-motor', 
                                    'ses-1_task-motor_hp200_s4_level2.feat', 
                                    subject+'_ses-1_task-motor_level2_zstat_Upper-Lower_hp200_s4.dscalar.nii')).get_fdata()
fw = fw / len(subject_list)
ul = ul / len(subject_list)
fw = fw * central_sulcus_gyrus_mask.astype(int)
ul = ul * central_sulcus_gyrus_mask.astype(int)

   
    

    
    
    




