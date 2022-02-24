# -*- coding: utf-8 -*-
"""
Created on Wed Feb 16 16:33:32 2022

@author: 马赛
"""

import os
import numpy as np
import pandas as pd


# path and input
fmriprep_dir = '/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/fmriprep'
nifti_dir = '/nfs/z1/zhenlab/MotorMap/data/bold/nifti'
res_dir = '/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/FD'
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
run_list = ['run-1', 'run-2', 'run-3', 'run-4', 'run-5', 'run-6']

# FD -- 99%
fd_subs = np.array([])
for subject in subject_list:
    print(subject)
    for run in run_list:
        print(run)
        confound_df = pd.read_csv(os.path.join(fmriprep_dir, subject, 
                                                'ses-1/func/'+subject+'_ses-1_task-motor_'+run+'_desc-confounds_timeseries.tsv'), 
                                  sep='\t', engine='python')
        fd_subs = np.append(fd_subs, confound_df['framewise_displacement'].iloc[1:].values)
np.percentile(fd_subs, 99)