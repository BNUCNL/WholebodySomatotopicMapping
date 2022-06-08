#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Convert non-HCP datasets to HCP style

@author: masai
"""

import os, subprocess

projectdir = '/nfs/z1/zhenlab/MotorMap'
subject_list = ['sub-04', 'sub-23', 'sub-27', 'sub-46']
run_list = ['run-1', 'run-2', 'run-3', 'run-4', 'run-5', 'run-6']

error_run = []

for subject in subject_list:
    for run in run_list:
        func = os.path.join(projectdir, 'data', 'bold', 'derivatives', 'fmriprep', 
                            subject, 'ses-1', 'func', 
                            subject+'_ses-1_task-motor_'+run+'_space-T1w_desc-preproc_bold_denoised.nii.gz')
        cmd = ' '.join([
            'ciftify_subject_fmri', 
            '--ciftify-work-dir', os.path.join(projectdir, 'data', 'bold', 'derivatives', 'ciftify'),
            func,
            subject,
            'ses-1_task-motor_' + run
            ])
        print(cmd)
        try:
            subprocess.check_call(cmd, shell=True)
        except:
            error_run.append(func)
        print(func+' Done!!!')
        
print('##### error run #####')        
print(error_run)