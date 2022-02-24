function fmri_resting(subjectID,runID,runDur,tr,SubjResp)
% fMRI_resting(subjectID,runID,runDur,tr,SubjResp)
% SubjResp: true or false. if SubjResp is true, subject presses 3# or 4$ key 
% to indicate she/he is ready.Then, the scanner or experimenter presses S key 
% to begin the experiment.
% if SubjResp = false. don't need subejct to press any key. the program
% will run automatically run to the point to wait the the scanner or experimenter 
% presses S key to begin the experiment.

% Zonglei Zhen @ 2019.05

%% Arguments
if nargin < 5, SubjResp = false; end
if nargin < 4, tr = 2; end
if nargin < 3, runDur = 8; end 

% scan time for each run
runTotalTime = runDur*60;

%% Print test information
fprintf('Runing resting fMRI\n');
fprintf('Subject ID: %s\n',subjectID);
fprintf('Run ID: %d\n',runID);
fprintf('fMRI TR: %d\n',tr);
fprintf('Total duration for one run: %.2f min, %.2f volume \n',...
    runTotalTime/60, runTotalTime/tr);

%% preprare the screen
sca; % close all screen
Screen('Preference', 'SkipSyncTests', 1);% skip sync tests
HideCursor;

% Setup PTB with some default values
PsychDefaultSetup(2);
% Set the screen number to the secondary monitor
screenNumber = max(Screen('Screens'));
% Define black, white and grey
% white = WhiteIndex(screenNumber);
% grey = white / 2;
black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect]= PsychImaging('OpenWindow', screenNumber, black);
% Flip to clear
Screen('Flip', window);

% % Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);
Screen('TextSize', window, 400);

%% Make texture for auxiliary instruction
stimDir = fullfile('stimuli','stimuli_no_pace');
beginInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'resting_begin.JPG')));
endInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'resting_end.JPG')));


%% Set keys
startKey = KbName('s');
escKey = KbName('ESCAPE');
respondKey3 = KbName('3#');
respondKey4 = KbName('4$');
cueDur = 1;% Cue duration

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
            sca;
            return
        end
    end
    Screen('Flip', window);
else
    WaitSecs(5)
    for i = 5:-1:1
        Screen('DrawTexture', window, beginInst);
        DrawFormattedText(window, num2str(i),'center', 'center', [1 1 1]);
        tnum = Screen('Flip', window);
        while GetSecs - tnum < cueDur, end
    end
end
Screen('DrawDots', window, [xCenter, yCenter], 40, [1 1 1], [], 2);
tBegin = Screen('Flip', window);
fprintf('*****--- The subject is READY, Please RUN MRI ---*****\n');

%% Wait trigger to begin the (MRI)experiment
while KbCheck(); end
while true
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && keyCode(startKey)
        break
    elseif keyIsDown && keyCode(escKey)
        Screen('CloseAll'); ShowCursor;
        disp('ESC is pressed to abort the program.');
        return;
    end
end
fprintf('*****---The MRI is running ---*****\n');

%% Run resting fMRI experiment 
while GetSecs - tBegin < runTotalTime
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && keyCode(escKey)
        sca; return;
    end
end

% Disp ending instruction
Screen('DrawTexture', window, endInst);
tEnd = Screen('Flip', window);
while GetSecs - tEnd < cueDur,  end
sca;

%% Save data
date =  strrep(strrep(datestr(clock),':','-'),' ','-');
outFile = fullfile('data',sprintf('%s-resting-run%d-%s.mat',subjectID,runID,date));
fprintf('Data were saved to: %s\n',outFile);
save(outFile);


