function fmri_motor_with_single_pace(subjectID,runID,blockDur,tr,SubjResp)
% fmri_motor_with_single_pace(subjectID,runID,blockDur,tr,SubjResp)
% Subject presses 1! or 2@ or 3# or 4$ key to indicate she/he is ready.
% Then,  the scanner or experimenter presses S key to begin the experiment.
% SubjResp: false or true. If you need subejct respond, set SubjResp to True
% Zonglei Zhen @ 2019.03

%% Arguments
if nargin < 5, SubjResp = false; end
if nargin < 4, tr = 2; end
if nargin < 3, blockDur = 8; end

%% Print test information
fprintf('Runing fMRI Motor Mapping\n');
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

% Setup PTB with some default values
PsychDefaultSetup(2);
% Set the screen number to the secondary monitor
screenNumber = max(Screen('Screens'));
% Define black, white and grey
white = WhiteIndex(screenNumber);
% grey = white / 2;
% black = BlackIndex(screenNumber);

% Open the screen
[window, windowRect]= PsychImaging('OpenWindow', screenNumber, white);
% Flip to clear
Screen('Flip', window);

% % Get the centre coordinate of the window in pixels
[xCenter, yCenter] = RectCenter(windowRect);

%% Make texture for auxiliary instruction
stimDir = fullfile('stimuli','stimuli_with_pace');
beginInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'task_begin.JPG')));
restInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'rest.JPG')));
endInst = Screen('MakeTexture', window, imread(fullfile(stimDir,'task_end.JPG')));

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
size(design);

%% set cue duration
cueDur = 1; endDur = 3;

%% Set keys
startKey = KbName('s');
escKey = KbName('ESCAPE');
respondKey3 = KbName('3#');
respondKey4 = KbName('4$');

%% present the begining instruction
Screen('DrawTexture', window, beginInst);
Screen('Flip', window);
% Check ready for subject
if SubjResp
    while KbCheck; end
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
end
fprintf('*****--- The subject is READY, Please RUN MRI ---*****\n');

%% Wait trigger to begin the (MRI)experiment
while KbCheck; end
while true
    [keyIsDown,~,keyCode] = KbCheck;
    if keyIsDown && keyCode(startKey)
        break
    elseif keyIsDown && keyCode(escKey),
        Screen('CloseAll'); ShowCursor;
        disp('ESC is pressed to abort the program.');
        return;
    end
end



%% pace dots
dotArray = [xCenter,yCenter];

%% Run fMRI experiment
%Iterate for block sets
for s = 1:nSet
    blocks = blockSet(:,s);
    fprintf('BlockSet %d:',s);
    
    % begining baseline
    Screen('DrawTexture', window, restInst);
    Screen('DrawDots', window, dotArray, 40, [0.5 0.5 0.5], [], 2);
    tBegin = Screen('Flip', window);
    while GetSecs - tBegin < blockDur - cueDur,
        [keyIsDown,~,keyCode] = KbCheck;
        if keyIsDown && keyCode(escKey)
            sca; return;
        end
    end
    Screen('DrawDots', window, [xCenter, yCenter], 40, [1 0 0], [], 2);
    Screen('Flip', window);
    while GetSecs - tBegin < blockDur,end
   
    % Iterate for block within a block sets
    for b = 1:nBlock
        fprintf(' %s,',task{blocks(b)});
        tCue = GetSecs;
        while GetSecs - tCue < blockDur - cueDur,
            Screen('DrawTexture', window, stimTexture(blocks(b)));
            Screen('DrawDots', window, dotArray, 40, [0 0 0], [], 2);
            tbDot = Screen('Flip', window);
            while GetSecs - tbDot < 1,
                if  GetSecs - tCue > blockDur - cueDur, break; end
            end
            Screen('DrawTexture', window, stimTexture(blocks(b)));
            %Screen('DrawDots', window, dotArray, 40, [0.5 0.5 0.5], [], 2);
            twDot = Screen('Flip', window);
            while GetSecs - twDot < 1
                if  GetSecs - tCue > blockDur - cueDur, break; end
            end
            
            % Check ESC key
            [keyIsDown,~,keyCode] = KbCheck;
            if keyIsDown && keyCode(escKey)
                sca; return;
            end
        end
        
        % show red dot to indicate task switch
        while GetSecs - tCue < blockDur,
            Screen('DrawDots', window, [xCenter, yCenter], 40, [1 0 0], [], 2);
            Screen('Flip', window);
        end
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


