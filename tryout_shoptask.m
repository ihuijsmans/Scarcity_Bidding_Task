ppnr = 2;



%Change working dir
cd 'M:\Scarcity\Main Experiment\';

%WD for Dot Comparison
stimuli_dir_DComp = [cd '\Scarcity Stimuli\Dot Comparison\'];
%WD for Shape Matching
stimuli_dir_SMatch = [cd '\Scarcity Stimuli\Shape Matching\'];
%WD for General images
stimuli_dir_general = [cd '\Scarcity Stimuli\General\'];

%Results
results_dir = [cd '\Results\'];

%Read token reminding images
c.reminder = cell(1,2);
c.reminder{1} = imread([stimuli_dir_general 'zerotoken.jpg']);
c.reminder{2} = imread([stimuli_dir_general 'ninetoken.jpg']);

%Load all vars
vars = ShopTaskPrep(ppnr);
vars.reminder = c.reminder;


%% Scanerstuff

SCANNER = {'Skyra','Dummy','Debugging','Keyboard','buttonbox'}; SCANNER = SCANNER{4};

% setup bitsi stuff for button responses
setup_bits;
if strcmp(SCANNER,'Debugging')
    onset_dummy_pulses = wait_for_scanner_start(3,bitsiboxScanner,scannertrigger,true);
    onset_first_pulse =  wait_for_scanner_start(1 ,bitsiboxScanner,scannertrigger,false);
elseif strcmp(SCANNER,'Keyboard')
    % do nothing
    % still, do get some timestamps so we don't need to worry about that case further down...
    onset_dummy_pulses = GetSecs;
    onset_first_pulse = GetSecs;
else % some kind of scanner -- wait for it
    onset_dummy_pulses = wait_for_scanner_start(30,bitsiboxScanner,scannertrigger,true);% this might be change to 31
    onset_first_pulse =  wait_for_scanner_start(1 ,bitsiboxScanner,scannertrigger,false);
end

%% Screen stuff

%Skips the 'Welcome to psychtoolbox message' 
olddebuglevel=Screen('Preference', 'VisualDebuglevel', 1);

%At the beginning of each script matlab does synctests. Level 1 and 2
%prevent those tests. What does 0 do?
Screen('Preference', 'SkipSyncTests', 0);

% Get the screen numbers
screens = Screen('Screens');

% Draw to the external screen if avaliable
screenNumber = max(screens);

% Define black and white
white = 255;
black = 0;
yellow=[255 255 0];
green = [0 255 0];
red = [255 0 0];

% Open an on screen window
[window, windowRect] = Screen('OpenWindow',screenNumber,black);
HideCursor;

% Get the size of the on screen window
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

%Other applications compete with windows for resources. These lines make
%sure matlab wins.
prioritylevel=MaxPriority(window); 
Priority(prioritylevel);

% Get the centre coordinate of the window
[xCenter, yCenter] = RectCenter(windowRect);
[wth, hth] = Screen('WindowSize', window);

%Textstuff
penWidthPixels = 4;
[oldFontName,oldFontNumber]=Screen('TextFont', window, 'Calibri');
Screen('TextSize', window, 16);
Screen('TextStyle', window, 0); 
KbName('UnifyKeyNames');

%Prep saving
filename = [results_dir,  sprintf('CD_ppnr_%i_time_%s_data.txt', ppnr, 'blaaaaaaaat123132132132')];
fid_newtask = fopen(filename,'a+t');
fprintf(fid_newtask, '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n', 'ppnr','block', 'condition_S/A', 'totaltrial','trial','screenId', 'presenttime', 'lastFlipTimestamp', 'flip_stamp', 'bid_round', 'bid', 'computerprice', 'gotit','RT', 'condition', 'brand', 'product', 'filename', 'retailprice');

%Prep saving
filename = [results_dir,  sprintf('CD_ppnr_%i_time_%s_slider.txt', ppnr, 'blaaaaaaaat123132132132')];
fid_slider = fopen(filename,'a+t');
fprintf(fid_slider, '%s\t%s\t%s\t%s\t%s\t%s\n', 'trial', 'flip', 'handle_x','response', 'tmp_bid','RT');

BEH_ShopTask_12_16(window, vars, 2, ppnr, tic, c.reminder{1}, 1, fid_newtask, fid_slider, SCANNER);