% Here we call some default settings for setting up Psychtoolbox
PsychDefaultSetup(2);

% Get screen number. Default = 0
screens = Screen('Screens');

% Set colors
black = BlackIndex(screens);
white = WhiteIndex(screens);
red = [1 0 0];
green = [0 1 0];

% Open a black screen, 
[window, windowRect] = PsychImaging('OpenWindow', screens, black);

% Screen size
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% Text settings 
Screen('TextFont', window, 'Calibri');

%cd M:\Scarcity\Pre-test\;
cd

%Definition direcotry
defdir = [cd '\Definitions\'];
question = 'Jeroens rating of this function:';
handle_x = (screenXpixels/2);
likert_draw(window, [0,7], 'blabalbla', 'horrible', 'good job', white);
Screen('Flip', window)
WaitSecs(1)


Screen('CloseAll')
return
%Release keys
[keyIsDown, ~, ~, ~] = KbCheck;
while keyIsDown
    [keyIsDown, ~, ~, ~] = KbCheck;
end

confirm = 1;
while confirm
    [~, ~, keyCode, ~] = KbCheck;
    answer = lower(KbName(keyCode));
    if answer
        switch answer
            case 'leftarrow'
                move = -2;
            case 'rightarrow'
                move = 2;
            case 'return'
                confirm = 0;
            case 'escape'
                Screen('CloseAll')
                break
            otherwise
                move = 0;
                continue
        end
    else
        continue
    end

    [handle_x, line_start_x, line_end_x] = likert_draw(window, question,[1,10],'horrible', 'good job', white, handle_x, move);
    Screen('Flip', window);
end

WaitSecs(5 )
Screen('CloseAll')