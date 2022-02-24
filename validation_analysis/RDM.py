#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Denoise effect: RDM between denised and original data.

@author: Sai Ma
"""

import os
import numpy as np
import pandas as pd
import nibabel as nib
from seaborn import heatmap
import matplotlib.pyplot as plt
from scipy.spatial.distance import cdist

# path and input
beta_dir = '/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/beta/cope_allsub'
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
task_labels = ['Toe', 'Ankle', 'LeftLeg', 'RightLeg', 'Forearm', 'Upperarm', 'Wrist', 'Finger', 'Eye', 'Jaw', 'Lip', 'Tongue']
save_header = nib.load('/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify/sub-01/MNINonLinear/Results/ses-1_task-motor/ses-1_task-motor_hp200_s4_level2.feat/sub-01_ses-1_task-motor_level2_zstat_Tongue-Avg_hp200_s4.dscalar.nii').header
central_sulcus_gyrus_mask = nib.load('/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/HCP_atlas/central_sulcus_gyrus_mask.dscalar.nii').get_fdata().astype(bool)

# RDM
pre_dict = dict()
post_dict = dict()
for task in task_labels:
    print(task)
    pre_dict[task] = nib.load(os.path.join(beta_dir, 'pre_'+task+'_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
    post_dict[task] = nib.load(os.path.join(beta_dir, 'post_'+task+'_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
pre_corr = np.zeros((12,12,62))
post_corr = np.zeros((12,12,62))
for sid, subject in enumerate(subject_list):
    print(subject)
    pre_task_mat = np.zeros((12, 5391))
    post_task_mat = np.zeros((12, 5391))
    for i, task in enumerate(task_labels):
        pre_task_mat[i,:] = pre_dict[task][sid,:]
        post_task_mat[i,:] = post_dict[task][sid,:]
    pre = cdist(pre_task_mat, pre_task_mat, metric='correlation')
    post = cdist(post_task_mat, post_task_mat, metric='correlation')
    row, col = np.diag_indices_from(post)
    pre[row,col] = np.nan
    post[row,col] = np.nan
    pre_corr[:,:,sid] = pre
    post_corr[:,:,sid] = post
pre_corr_mean = np.nanmean(pre_corr, axis=-1)
post_corr_mean = np.nanmean(post_corr, axis=-1)



# heatmap
rdm_merge = np.load('rdm_merge.npy')
rdm_merge[rdm_merge==0] = np.nan
task_labels = ['Toe', 'Ankle', 'Left leg', 'Right leg', 'Forearm', 'Upperarm', 'Wrist', 'Finger', 'Eye', 'Jaw', 'Lip', 'Tongue']
hm = heatmap(rdm_merge, square=True, xticklabels=task_labels, yticklabels=task_labels, vmin=0, vmax=1.2, cmap='rainbow', cbar=True, cbar_kws={"shrink": 0.8})
hm.set_xticklabels(task_labels, rotation=-45)
hm.set_yticklabels(task_labels, rotation=45)
# scatter
plt.scatter(pre_corr_mean, post_corr_mean)
plt.plot([0.25, 1.5], [0.25, 1.5], label='y = x', color='crimson')
plt.xlim((0.25, 1.5))
plt.ylim((0.25, 1.5))
plt.xlabel('pre_denoised')
plt.ylabel('post_denoised')
plt.gca().spines['right'].set_color('none')
plt.gca().spines['top'].set_color('none')
plt.legend()


