function mri_anatomy(subjectID,runID,modality,SubjResp)
% mri_anatomy(subjectID,runID,runDur,modality,SubjResp)
% modality: field, t1, t2, dwi
% SubjResp: true or false. if SubjResp is true, subject presses 3# or 4$ key 
% to indicate she/he is ready.Then, the scanner or experimenter presses S key
% to begin the experiment.
% if SubjResp = false. don't need subejct to press any key. the program 
% will run automatically run to the point to wait the the scanner or experimenter 
% presses S key to begin the experiment.

% Zonglei Zhen @ 2019.05

if nargin < 4, SubjResp = false; end

%% run total time in sec unit 
if strcmp(modality,'field')
    runTotalTime = 2*60 + 27;
elseif  strcmp(modality,'t1')
    runTotalTime = 6*60 + 3;
elseif  strcmp(modality,'t2')
    runTotalTime = 5*60 + 18;
elseif  strcmp(modality,'dwi')
    runTotalTime = 14*60 + 19;
end

%% Print test information
fprintf('Runing %s\n',modality);
fprintf('Subject ID: %s\n',subjectID);
fprintf('Run ID: %d\n',runID);
fprintf('Total duration for one run: %.2f min\n',runTotalTime/60);

%% preprare the screen
sca; % close all screen
Screen('Preference', 'SkipSyncTests', 1);% skip sync tests
HideCursor;
PsychDefaultSetup(2);% Setup PTB with some default values
screenNumber = max(Screen('Screens'));% Set the screen number to the secondary monitor
black = BlackIndex(screenNumber);
[window, windowRect]= PsychImaging('OpenWindow', screenNumber, black);% Open the screen
Screen('Flip', window);% Flip to clear
[xCenter, yCenter] = RectCenter(windowRect);% Get the centre coordinate of the window in pixels
Screen('TextSize', window, 400);
f
%% Make texture for auxiliary instruction
stimDir = fullfile('stimuli','stimuli_no_pace');
beginInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'mri_begin.JPG')));
endInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'mri_end.JPG')));
fixation = Screen('MakeTexture', window, imread(fullfile(stimDir,'white_dot.JPG')));

% cue duration 
cueDur = 1;

%% Set keys
startKey = KbName('s');
escKey = KbName('ESCAPE');
respondKey3 = KbName('3#');
respondKey4 = KbName('4$');

%% Present the begining instruction
Screen('DrawTexture', window, beginInst);
Screen('Flip', window);
% Check ready for subject
if SubjResp
    while KbCheck(); end
    while true
        [keyIsDown, ~, keyCode] = KbCheck();
        responseKey = keyCode(respondKey3) | keyCode(respondKey4);
        if keyIsDown && responseKey
            break;
        elseif keyIsDown && keyCode(escKey)
            sca; return
        end
    end
    Screen('Flip', window);
else
    WaitSecs(4);
    for i = 3:-1:1
        Screen('DrawTexture', window, beginInst);
        DrawFormattedText(window, num2str(i),'center', 'center', [1 1 1]);
        tnum = Screen('Flip', window);
        while GetSecs - tnum < cueDur, end
    end
end
% Screen('DrawDots', window, [xCenter, yCenter], 40, [1 1 1], [], 2);
Screen('DrawTexture', window, fixation);
tBegin = Screen('Flip', window);
fprintf('***** The subject is READY. Please RUN MRI *****\n');

%% Wait trigger to begin the (MRI)experiment
while KbCheck(); end
while true
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && keyCode(startKey)
        break;
    elseif keyIsDown && keyCode(escKey)
        Screen('CloseAll'); ShowCursor;
        disp('ESC is pressed to abort the program.');
        return;
    end
end
fprintf('*****---The MRI is running ---*****\n');

%% Run anatomy MRI experiment 
while GetSecs - tBegin < runTotalTime
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && keyCode(escKey), sca; return; end
end

% Disp ending instruction
Screen('DrawTexture', window, endInst);
tEnd = Screen('Flip', window);
while GetSecs - tEnd < cueDur,  end
sca;

%% Save data
date =  strrep(strrep(datestr(clock),':','-'),' ','-');
outFile = fullfile('data',sprintf('%s-%s-run%d-%s.mat',subjectID,modality,runID,date));
fprintf('Data were saved to: %s\n',outFile);
save(outFile);



