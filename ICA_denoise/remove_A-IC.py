"""
Remove noise ICs from preprocessed data using fsl_regfilt 
(https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/MELODIC#fsl_regfilt_command-line_program).

@author: Sai Ma
"""

import os, subprocess
import pandas as pd

# input
projectdir = '/nfs/z1/zhenlab/MotorMap'
subject_list = pd.read_csv('/nfs/z1/userhome/MaSai/workingdir/code/motor/subject_list.csv',header=None)[0].to_list()
session= 'ses-1'
run_list = ['run-1', 'run-2', 'run-3', 'run-4', 'run-5', 'run-6']
# /nfs/z1/zhenlab/MotorMap/data/bold/derivatives/melodic/sub-01/ses-1/sub-01_ses-1_task-motor_run-1.ica/series_original/
for subject in subject_list:
    for run in run_list:
        # read noise ICs number from results.txt
        ica_dir = os.path.join(projectdir, 'data', 'bold', 'derivatives', 'melodic', subject, session, subject+'_'+session+'_task-motor_'+run+'.ica')
        error_run = []
        with open(os.path.join(ica_dir, 'results_suggest.txt')) as results:
            noise_id = results.readlines()[-1].replace('[','').replace(']','').replace(' ','')

        # run fsl_regfilt
        input_file = os.path.join(projectdir, 'data', 'bold', 'derivatives', 'fmriprep', subject, session, 'func', subject + '_' + session + '_' + 'task-motor' + '_' + run + '_space-T1w_desc-preproc_bold.nii.gz')
        output_file = os.path.join(projectdir, 'data', 'bold', 'derivatives', 'fmriprep', subject, session, 'func', subject + '_' + session + '_' + 'task-motor' + '_' + run + '_space-T1w_desc-preproc_bold_denoised.nii.gz')
        mix_file = os.path.join(ica_dir, 'series_original', 'melodic_mix')
        fsl_regfilt_command = ' '.join(['fsl_regfilt',
                                        '-i', input_file,
                                        '-o', output_file,
                                        '-d', mix_file,
                                        '-f', '"{}"'.format(noise_id)
                                        ])
        print('RUN CMD: ' + fsl_regfilt_command)
        try:
            subprocess.check_call(fsl_regfilt_command, shell=True)
        except:
            error_run.append(run)
print()