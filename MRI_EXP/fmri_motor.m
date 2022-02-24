function fmri_motor(subjectID,runID,blockDur,tr,SubjResp)
% fmri_motor(subjectID,runID,blockDur,tr,SubjResp)
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
if nargin < 3, blockDur = 16; end

%% Print test information
fprintf('Runing fMRI Somatotopy Mapping\n');
fprintf('Subject ID: %s\n',subjectID);
fprintf('Run ID: %d\n',runID);
fprintf('fMRI TR: %d\n',tr);
fprintf('Block duration: %.2f\n',blockDur);
runTotalTime = blockDur*(7*4+1);
fprintf('Total duration for one run: %.2f min, %.2f volume \n',...
    runTotalTime/60, runTotalTime/tr);

%% preprare the screen
sca; % close all screen
Screen('Preference', 'SkipSyncTests', 1);% skip sync tests
HideCursor;
PsychDefaultSetup(2);% Setup PTB with some default values
screenNumber = max(Screen('Screens'));% Set the screen number to the secondary monitor
grey = [166,166,166]/255;
[window, windowRect]= PsychImaging('OpenWindow', screenNumber, grey);% Open the screen
Screen('Flip', window);% Flip to clear
[xCenter, yCenter] = RectCenter(windowRect);% % Get the centre coordinate of the window in pixels
Screen('TextSize', window, 400);

%% Make texture for auxiliary instruction
stimDir = fullfile('stimuli','stimuli_no_pace');
beginInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'task_begin.JPG')));
restInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'rest.JPG')));
endInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'task_end.JPG')));
fixation = Screen('MakeTexture', window, imread(fullfile(stimDir,'black_dot.JPG')));
%% Make texture for motor task
task = {'toe','ankle','leftleg','rightleg','forearm','upperarm',...
    'wrist','finger','eye','jaw','lip','tongue'};
nTask = length(task);
stimTexture = zeros(nTask,1);
for i = 1:nTask
    img = imread(fullfile(stimDir,[task{i},'.JPG']));
    stimTexture(i) = Screen('MakeTexture', window,img);
end

%% Design
% Group ten motor task into two sets
taskSet = [1:2:nTask;2:2:nTask]';
nBlock = size(taskSet,1);

% The order of blocks(set)
order = randperm(2);
setOrder = [order,order(end:-1:1)];
nSet = length(setOrder);
% task id for each blockset
blockSet = zeros(nBlock,nSet);
for i = 1:2
    blockSet(:,i) = taskSet(randperm(nBlock),setOrder(i));
end
blockSet(:,3) = blockSet(end:-1:1,2);
blockSet(:,4) = blockSet(end:-1:1,1);


%% Assemble block inforamtion into design for fmri data analysis
totalBlock = 4*7+1;
design = nan(totalBlock,3);
for s = 1:nSet
    si = (s-1)*7+1;
    design(si,:) = [(s-1)*7*blockDur,0,blockDur];
    for b = 1:nBlock
        bi = si + b;
        design(bi,:) = [((s-1)*7+b)*blockDur,blockSet(b,s),blockDur];
    end
end
design(end,:) = [(totalBlock-1)*blockDur,0,blockDur];

%% Set keys
startKey = KbName('s');
escKey = KbName('ESCAPE');
respondKey3 = KbName('3#');
respondKey4 = KbName('4$');

%% set cue duration
cueDur = 1; endDur = 2;

%% present the begining instruction
Screen('DrawTexture', window, beginInst);
Screen('Flip', window);
if SubjResp % Check ready for subject
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
else % Do not check, but count down
    WaitSecs(4);
    for i = 3:-1:1
        Screen('DrawTexture', window, beginInst);
        DrawFormattedText(window, num2str(i),'center', 'center', [0 0 0]);
        tnum = Screen('Flip', window);
        while GetSecs - tnum < cueDur, end
    end
end
Screen('DrawTexture', window, restInst);
Screen('Flip', window);
fprintf('*****--- The subject is READY, Please RUN MRI ---*****\n');

%% Wait trigger to begin the (MRI)experiment
while KbCheck(); end
while true
    [keyIsDown,~,keyCode] = KbCheck();
    if keyIsDown && keyCode(startKey)
        break
    elseif keyIsDown && keyCode(escKey)
        Screen('CloseAll');
        disp('ESC is pressed to abort the program.');
        return;
    end
end
fprintf('*****---The MRI is running ---*****\n');

%% Run fMRI experiment
taskDur =  blockDur - cueDur;
for s = 1:nSet
    % begining baseline
    Screen('DrawTexture', window, restInst);
    tBegin = Screen('Flip', window);
    while GetSecs - tBegin < taskDur
        [keyIsDown,~,keyCode] = KbCheck();
        if keyIsDown && keyCode(escKey), sca; return; end
    end
    % Screen('DrawDots', window, [xCenter, yCenter], 40, [0 0 0], [], 2);
    Screen('DrawTexture', window, fixation);
    Screen('Flip', window);
    while GetSecs - tBegin < blockDur,   end
    
    % Iterate for block within a block sets
    blocks = blockSet(:,s);
    fprintf('BlockSet %d:',s);
    for b = 1:nBlock
        fprintf(' %s,',task{blocks(b)});
        Screen('DrawTexture', window,  stimTexture(blocks(b)));
        tCue = Screen('Flip', window);
        while GetSecs -tCue < taskDur
            [keyIsDown,~,keyCode] = KbCheck();
            if keyIsDown && keyCode(escKey), sca; return; end
        end
        % Screen('DrawDots', window, [xCenter, yCenter], 40, [0 0 0], [], 2);
        Screen('DrawTexture', window, fixation);
        Screen('Flip', window);
        while GetSecs - tCue < blockDur, end
    end
    fprintf('\n');
end

% Ending baseline
Screen('DrawTexture', window, restInst);
tEnd = Screen('Flip', window);
while GetSecs - tEnd < blockDur,  end

% Disp ending instruction
Screen('DrawTexture', window, endInst);
tEnd = Screen('Flip', window);
while GetSecs - tEnd < endDur,  end
sca;

%% Save data
date =  strrep(strrep(datestr(clock),':','-'),' ','-');
outFile = fullfile('data',sprintf('%s-motor-run%d-%s.mat',subjectID,runID,date));
fprintf('Data were saved to: %s\n',outFile);
save(outFile);

