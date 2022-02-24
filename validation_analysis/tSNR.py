#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 30 19:58:44 2021

@author: Sai Ma
"""

import os
import numpy as np
import pandas as pd
import nibabel as nib
import matplotlib.pyplot as plt

def tSNR(data):
    """
    calculate the temporal signal-to-noise ratio (tSNR) for each vertex
    Parameters
    ----------          
 
        data: used to calculate tSNR, 
            shape = [n_vertice, m_timepoints].
    
    Returns
    -------
        data_tSNR: the tSNR of data, shape = [n_vertice, ].
    """
    data_mean = np.mean(data, axis=0)
    data_std = np.std(data, axis=0)
    data_tSNR = np.nan_to_num(data_mean / data_std)
    return data_tSNR

def cohen_d(pre, post):
    """
    calculate the cohen's d effect size of pre- and post-denoising fMRI data 
    Parameters
    ----------         
        pre: value of a certain measurement of pre-denoising fMRI data, 
            shape = [n_vertice, ].
 
        post: value of a certain measurement of post-denoising fMRI data, 
            shape = [n_vertice, ].
   
    Returns
    -------
        d: the cohen's d of pre and post, 
            shape = [n_vertice, ].
    """
    npre = np.shape(pre)[-1]
    npost = np.shape(post)[-1]
    dof = npost + npre - 2
    d = ((post.mean(-1) - pre.mean(-1)) /
          np.sqrt(((npost - 1) * np.var(post, axis=-1, ddof=1) +
                  (npre - 1) * np.var(pre, axis=-1, ddof=1)) / dof))
    d = np.nan_to_num(d)
    return d

# path and input
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
save_header = nib.load('/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify/sub-01/MNINonLinear/Results/ses-1_task-motor/ses-1_task-motor_hp200_s4_level2.feat/sub-01_ses-1_task-motor_level2_zstat_Tongue-Avg_hp200_s4.dscalar.nii').header
central_sulcus_gyrus_mask = nib.load('/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/HCP_atlas/central_sulcus_gyrus_mask.dscalar.nii').get_fdata().astype(bool)
res_dir = '/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/tSNR'

# plot
pre_tsnr = nib.load(os.path.join(res_dir, 'pre_tSNR_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
post_tsnr = nib.load(os.path.join(res_dir, 'post_tSNR_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
plt.hist([pre_tsnr.reshape(-1), post_tsnr.reshape(-1)], bins=100, range=(0, 250), rwidth=0.8, label=['Pre-denoised', 'Post-denoised'])
plt.xlim((0, 250))
plt.tick_params(labelsize=15)
plt.xlabel('tSNR', fontsize=15)
plt.ylabel('Number of vertices', fontsize=15)
plt.gca().spines['right'].set_color('none')
plt.gca().spines['top'].set_color('none')
plt.legend()

# cohen's d
pre_tsnr = nib.load(os.path.join(res_dir, 'pre_tSNR_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
post_tsnr = nib.load(os.path.join(res_dir, 'post_tSNR_allsub.dscalar.nii')).get_fdata()[:,central_sulcus_gyrus_mask[0,:]]
d = np.zeros((np.sum(central_sulcus_gyrus_mask),))
for i in range(np.sum(central_sulcus_gyrus_mask)):
    print(i)
    d[i] = cohen_d(pre_tsnr[:, i], post_tsnr[:, i])
d_map = np.zeros((1,91282))
d_map[central_sulcus_gyrus_mask] = d
nib.save(nib.Cifti2Image(d_map, save_header), '/nfs/z1/userhome/MaSai/workingdir/Motor_project/data/tSNR/tSNR_cohen-d_roi.dscalar.nii')









