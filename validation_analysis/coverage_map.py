#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Probabilistic coverage map of 62 subjects

@author: Sai Ma
"""

import os
import nibabel as nib
import numpy as np
import pandas as pd

subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
anat_temp = np.zeros((91,109,91))
for sub in subject_list:
    print(sub)
    brain_mask = nib.load(os.path.join('/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify', sub, 'MNINonLinear/brainmask_fs.nii.gz')).get_fdata()
    anat_temp += brain_mask
anat_prob = anat_temp / len(subject_list)
save_affine = nib.load('/nfs/z1/zhenlab/MotorMap/data/bold/derivatives/ciftify/sub-01/MNINonLinear/brainmask_fs.nii.gz').affine
nib.save(nib.Nifti2Image(anat_prob, save_affine), '/nfs/z1/userhome/MaSai/workingdir/coverage_prob.nii.gz')
