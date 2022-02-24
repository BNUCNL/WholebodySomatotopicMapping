%% Set subject id
subjectID = 'your_subejct_id';

%% motor fmri before field mapping
fmri_motor(subjectID, 1); % motor task run 1
fmri_motor(subjectID, 2);% motor task run 2
fmri_motor(subjectID, 3);% motor task run 3

%% field mapping
mri_anatomy(subjectID,4,'field')

%% motor fmri after field mapping
fmri_motor(subjectID, 5); % motor task run 4
fmri_motor(subjectID, 6); % motor task run 5
fmri_motor(subjectID, 7); % motor task run 6

%% t1 mapping
mri_anatomy(subjectID,8,'t1')
