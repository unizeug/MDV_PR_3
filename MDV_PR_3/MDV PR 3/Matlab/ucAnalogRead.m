function [samples] = ucAnalogRead(port, SampleRate, NumSamples, TriggerMode,TriggerLevel)
% function [samples] = ucAnalogRead(port, SampleRate, NumSamples,TriggerMode,TriggerLevel)
% ---------------------------------------------------
% filename: ucAnalogRead
% author: Jürgen Funck
% organisation: TU Berlin
% project: MDV PR
% date: 2010-03-23
% ---------------------------------------------------
% description: read analog data from an avr-microcontroller
% input: 
%   port:   name of the COM-port that the microcontroller is connected to
%           e.g. 'COM2'
%   SampleRate: requested sampling rate [Samples/s] (max. 16 kSamples/s)
%   NumSamples: number of samples to be recorded (max. 2048)
%   TriggerMode: trigger mode:
%                   'NONE' - trigger is disabled
%                   'RISING' - trigger at rising edge
%                   'FALLING' - trigger at falling edge
%   TriggerLevel: trigger level in quantization steps (-512...511)
% 
% output: [samples]: recorded samples
% ---------------------------------------------------

% Constants and Maximum values SummerSchool-Board
MAX_NUM_SAMPLES = 4096; % 
MAX_SAMPLE_RATE = 15e3; % Samples/s
Fcpu            = 14745600; % Hz

% Constants and Maximum values Preon8
%MAX_NUM_SAMPLES = 2048; % 
%MAX_SAMPLE_RATE = 15e3; % Samples/s
%Fcpu = 7372800; % Hz

% check whether requestet sampling rate is in range
if(SampleRate > MAX_SAMPLE_RATE)
    error(['sampling-rate out of range!\n',...
        'maximum sampling-rate: %i Samples/s\t requested %i Samples/s'],...
        MAX_SAMPLE_RATE, SampleRate);
end

% check whether number of samples is in range
if(NumSamples > MAX_NUM_SAMPLES)
    error(['number of samples out of range!\n',...
        'maximum number of samples: %i \t requested %i'],...
        MAX_NUM_SAMPLES, NumSamples);
end

% check whether trigger mode is valid
if(strcmp(TriggerMode, 'NONE'))
    tMode = 0;
elseif(strcmp(TriggerMode, 'RISING'))
    tMode = 1;
elseif(strcmp(TriggerMode, 'FALLING'))
    tMode = 2;
else
  error(['invalid trigger-mode: %s\n',...
            'Valid trigger-modes are: NONE, RISISNG, FALLING'],TriggerMode)
end

% calculate sampling code
sCode = round((Fcpu/SampleRate)-1);

% calculate resulting sampling-rate and display rate-error
realSampleRate = Fcpu/(sCode+1);
absErr = realSampleRate-SampleRate;
relErr = 100*(absErr)/realSampleRate;
disp(sprintf(['true sample rate: %f Samples/s\n',...
    'Error:\t%f Samples/s\n\t\t%f %%'], realSampleRate, absErr, relErr));

% set parameters of com-port
s = serial(port);
set(s,'BaudRate',115200);
BufferSize = max(256,2*NumSamples);
set(s,'InputBufferSize',2*BufferSize);
fopen(s);

% empty buffer of com-port
if(s.BytesAvailable > 0)
    fread(s, s.BytesAvailable);
end

% request measurement
str = sprintf('ANA %i %i %i %i',sCode,NumSamples,tMode,TriggerLevel);
fprintf(s,str);
disp(sprintf(str));

% receive samples
samples = fread(s,NumSamples,'int16');

if(s.BytesAvailable > 0)
    rest = fread(s, s.BytesAvailable);
else
    rest = [];
end

% close com-port
fclose(s);

% display message
message = sprintf('%i Samples empfangen',length(samples)+length(rest));
disp(message);

end