% speech recognition program
% speak number 0-9 to recognize
% speak command 'open canlendar' to open canlendar ?for MacOS only?
% speak command 'open calculater' to open calculater?for MacOS only?
% speak command 'over' to end this program

clear all;
close all;

load ref_fun

Fs = 8000;
frameInterval = 80;
mic = dsp.AudioRecorder('SampleRate', Fs, 'SamplesPerFrame', 200);

tic

initialThreeBlock = zeros(3000,1);
inputArray = initialThreeBlock;
flag = 0;
i = 0;
fprintf('Speak please ...\n');
while i < 60,           % run for 180 second
    % Get signal from microphone
    fprintf('.\n.\n.\n');
    while toc < 3,
        inputBlock = step(mic);
        inputBlock = inputBlock(:,1);
        inputArray = [inputArray; inputBlock];
        if toc > 0.1,       % Dynamic ploting
            figure(1)
            plot(inputBlock);
            ylim([-1 1])
            drawnow
        end
    end
    % Recognizaiton
    if sum(abs(inputArray)) > 60,
        fprintf('Recognizing ...');
        result(i+1) = sr_real_time_fun(inputArray,ref);
        if result(i+1) == 10,
            fprintf('    Result is "Over."\n\nThis program is ended.\n\n')
            break;
        elseif result(i+1) == 11,
            fprintf('    Open Calendar\n')
            system('open /Applications/Calendar.app');
        elseif result(i+1) == 12,
            fprintf('    Open Calculator\n')
            system('open /Applications/Calculator.app');
        else
            fprintf('    Result is %d\n',result(i+1));
        end
    else
        fprintf('Say something or speak louder.\n');
        flag = 1;
    end 
    % Draw valid fragment
    if flag~=1,
        figure(2)
        [startFrame,endFrame] = find_fragment(inputArray);
        plot(inputArray);
        drawnow
        xlim([startFrame*frameInterval endFrame*frameInterval])
    end
    flag = 0;
    pause(0.5)
    tic              % Reset timer
    i = i+1;
    inputArray = initialThreeBlock;
end 