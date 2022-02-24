#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Visualize the FD (Framewise displacement) of subjects at each time point and different tasks.

@author: Sai Ma
"""

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

# path and input
fmriprep_dir = '/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/fmriprep'
nifti_dir = '/nfs/z1/zhenlab/MotorMap/data/bold/nifti'
res_dir = '/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/FD'
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
run_list = ['run-1', 'run-2', 'run-3', 'run-4', 'run-5', 'run-6']

# FD -- subjects
fd_subs = np.array([])
for subject in subject_list:
    print(subject)
    for run in run_list:
        print(run)
        confound_df = pd.read_csv(os.path.join(fmriprep_dir, subject, 
                                                'ses-1/func/'+subject+'_ses-1_task-motor_'+run+'_desc-confounds_timeseries.tsv'), 
                                  sep='\t', engine='python')
        fd_subs = np.append(fd_subs, confound_df['framewise_displacement'].iloc[1:].values)
plt.hist(fd_subs, bins=50, range=(0, 1.2), rwidth=0.5)
plt.xlim((0, 1.2))
plt.tick_params(labelsize=8)
plt.xlabel('Framewise Displacement (mm)')
plt.ylabel('Quantity')
plt.gca().spines['right'].set_color('none')
plt.gca().spines['top'].set_color('none')

# FD -- tasks
task_labels = ['Toe', 'Ankle', 'LeftLeg', 'RightLeg', 'Forearm', 'Upperarm', 'Wrist', 'Finger', 'Eye', 'Jaw', 'Lip', 'Tongue']
task_fd_list = list()
for task in range(1, 13):
    print(task_labels[task-1])
    fd_array = np.array([])
    for subject in subject_list:
        print(subject)
        for run in run_list:
            print(run)
            ev_df = pd.read_csv(os.path.join(nifti_dir, subject, 
                                              'ses-1/func/'+subject+'_ses-1_task-motor_'+run.replace('run-', 'run-0')+'_events.tsv'), sep='\t', engine='python')
            confound_df = pd.read_csv(os.path.join(fmriprep_dir, subject, 
                                                    'ses-1/func/'+subject+'_ses-1_task-motor_'+run+'_desc-confounds_timeseries.tsv'), sep='\t', engine='python')
            task_onset = ev_df[ev_df['trial_type']==task]['onset'].values // 2
            task1 = (confound_df['framewise_displacement'].iloc[task_onset[0]:task_onset[0]+8]).values
            task2 = (confound_df['framewise_displacement'].iloc[task_onset[1]:task_onset[1]+8]).values
            fd_array = np.append(fd_array, np.append(task1, task2))
    task_fd_list.append(fd_array)
positions = np.arange(1, len(task_labels)+1)
plt.violinplot(task_fd_list, positions, showextrema=False)
plt.boxplot(task_fd_list, widths=0.07, showfliers=False, 
            patch_artist = True, boxprops={'color':'crimson', 'facecolor':'white'},
            medianprops={'color':'crimson'})
plt.xticks(positions, task_labels)
plt.ylim(0, 1.4)
plt.tick_params(labelsize=15)
plt.xlabel('Task Names', fontsize=15)
plt.ylabel('Framewise Displacement (mm)', fontsize=15)
plt.gca().spines['right'].set_color('none')
plt.gca().spines['top'].set_color('none')

        
        

