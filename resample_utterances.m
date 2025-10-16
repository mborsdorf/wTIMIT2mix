% resample_utterances.m
%
% Resample speech data to 8 kHz
% 
% This script is based on the create_wav_2speakers.m script, which has been
% published under the following licensing:
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Copyright (C) 2016 Mitsubishi Electric Research Labs 
%                          (Jonathan Le Roux, John R. Hershey, Zhuo Chen)
%   Apache 2.0  (http://www.apache.org/licenses/LICENSE-2.0) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Modifications copyright (C) 2024 Marvin Borsdorf
% Machine Listening Lab, University of Bremen, Germany
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

% Please define PATH1 for the wTIMIT raw data that has been merged into the
% structure .../data/...
% Please define PATH2 to determine where to store the downsampled version

wTIMITroot='PATH1/wTIMIT/data'; 
output_dir8k='PATH2/wTIMIT8k';

useaudioread = 0;
if exist('audioread','file')
    useaudioread = 1;
end

TaskFile = 'target_reference_list.txt';
fid=fopen(TaskFile,'r');
C=textscan(fid,'%s');
match = ["/tr", "/cv", "/open_set_tt", "/closed_set_tt"];
num_files = length(C{1});
fs8k=8000;


for i = 1:num_files
    % get input wavs
    if useaudioread
        [s1, fs] = audioread([wTIMITroot erase(C{1}{i}, match)]);
    else                
        [s1, fs] = wavread([wTIMITroot erase(C{1}{i}, match)]); %#ok<*DWVRD>
    end

    % resample to 8 kHz file
    s1_8k=resample(s1,fs8k,fs);
    
    [filepath8k,name,ext] = fileparts([output_dir8k C{1}{i}]);
    if ~exist(filepath8k,'dir')
        mkdir(filepath8k);
    end
    
    if useaudioread                          
        s1_8k = int16(round((2^15)*s1_8k));
        audiowrite([output_dir8k C{1}{i}],s1_8k,fs8k);
    else
        wavwrite(s1_8k,fs8k,[output_dir8k C{1}{i}]); %#ok<*DWVWR>
    end

    if mod(i,10)==0
        fprintf(1,'.');
        if mod(i,200)==0
            fprintf(1,'\n');
        end
    end

end

fclose(fid);

