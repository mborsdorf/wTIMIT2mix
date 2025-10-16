% create_wTIMIT2mix_normal.m
%
% Script to create the normal part of the wTIMIT2mix speech database. It 
% creates the 8 kHz version as max version. To create the min version or work 
% with 16 kHz, please uncomment/comment the script accordingly.
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
% Please define PATH3 to determine the location of the mixture_infos folder

data_type = {'tr','cv','closed_set_tt','open_set_tt'};
wTIMITroot = 'PATH1/wTIMIT/data'; 
%output_dir16k='PATH2/wTIMIT/wTIMIT2mix/normal/wav16k';
output_dir8k='PATH2/wTIMIT/wTIMIT2mix/normal/wav8k';
task_list='PATH3/mixture_infos';

%min_max = {'min','max'}; 
min_max = {'max'};

useaudioread = 0;
if exist('audioread','file')
    useaudioread = 1;
end

for i_mm = 1:length(min_max)
    for i_type = 1:length(data_type)
        %if ~exist([output_dir16k '/' min_max{i_mm} '/' data_type{i_type}],'dir')
        %    mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type}]);
        %end
        if ~exist([output_dir8k '/' min_max{i_mm} '/' data_type{i_type}],'dir')
            mkdir([output_dir8k '/' min_max{i_mm} '/' data_type{i_type}]);
        end
        status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/s1/']); %#ok<NASGU>
        status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/s2/']); %#ok<NASGU>
        status = mkdir([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/mix/']); %#ok<NASGU>
        %status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/']); %#ok<NASGU>
        %status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/']); %#ok<NASGU>
        %status = mkdir([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/']);
                
        TaskFile = [task_list '/' data_type{i_type} '_spk_mix_n.txt'];
        fid=fopen(TaskFile,'r');
        C=textscan(fid,'%s %f %s %f');
        
        Source1File = ['mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_1'];
        Source2File = ['mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_2'];
        MixFile     = ['mix_2_spk_' min_max{i_mm} '_' data_type{i_type} '_mix'];
        
        fid_s1 = fopen(Source1File,'w');
        fid_s2 = fopen(Source2File,'w');
        fid_m  = fopen(MixFile,'w');
        
        num_files = length(C{1});
        fs8k=8000;
        %fs16k=16000;
        
        %scaling_16k = zeros(num_files,2);
        scaling_8k = zeros(num_files,2);
        %scaling16bit_16k = zeros(num_files,1);
        scaling16bit_8k = zeros(num_files,1);
        fprintf(1,'%s\n',[min_max{i_mm} '_' data_type{i_type}]);
        for i = 1:num_files
            [inwav1_dir,invwav1_name,inwav1_ext] = fileparts(C{1}{i});
            [inwav2_dir,invwav2_name,inwav2_ext] = fileparts(C{3}{i});
            fprintf(fid_s1,'%s\n',C{1}{i});
            fprintf(fid_s2,'%s\n',C{3}{i});
            inwav1_snr = C{2}(i);
            inwav2_snr = C{4}(i);
            mix_name = [invwav1_name,'_',num2str(inwav1_snr),'_',invwav2_name,'_',num2str(inwav2_snr)];
            fprintf(fid_m,'%s\n',mix_name);
                        
            % get input wavs
            if useaudioread
                [s1, fs] = audioread([wTIMITroot C{1}{i}]);
                s2       = audioread([wTIMITroot C{3}{i}]);
            else                
                [s1, fs] = wavread([wTIMITroot C{1}{i}]); %#ok<*DWVRD>
                s2       = wavread([wTIMITroot C{3}{i}]);            
            end
            
            % resample, normalize 8 kHz file, save scaling factor
            s1_8k=resample(s1,fs8k,fs);
            [s1_8k,lev1]=activlev(s1_8k,fs8k,'n'); % y_norm = y /sqrt(lev);
            s2_8k=resample(s2,fs8k,fs);
            [s2_8k,lev2]=activlev(s2_8k,fs8k,'n');
                        
            weight_1=10^(inwav1_snr/20);
            weight_2=10^(inwav2_snr/20);
            
            s1_8k = weight_1 * s1_8k;
            s2_8k = weight_2 * s2_8k;
            
            switch min_max{i_mm}
                case 'max'
                    mix_8k_length = max(length(s1_8k),length(s2_8k));
                    s1_8k = cat(1,s1_8k,zeros(mix_8k_length - length(s1_8k),1));
                    s2_8k = cat(1,s2_8k,zeros(mix_8k_length - length(s2_8k),1));
                case 'min'
                    mix_8k_length = min(length(s1_8k),length(s2_8k));
                    s1_8k = s1_8k(1:mix_8k_length);
                    s2_8k = s2_8k(1:mix_8k_length);
            end
            mix_8k = s1_8k + s2_8k;
                    
            max_amp_8k = max(cat(1,abs(mix_8k(:)),abs(s1_8k(:)),abs(s2_8k(:))));
            mix_scaling_8k = 1/max_amp_8k*0.9;
            s1_8k = mix_scaling_8k * s1_8k;
            s2_8k = mix_scaling_8k * s2_8k;
            mix_8k = mix_scaling_8k * mix_8k;
            
            % added: resample to 16 kHz
            %s1_16k=resample(s1,fs16k,fs);
            %s2_16k=resample(s2,fs16k,fs);
            
            % apply same gain to 16 kHz file
            %s1_16k = weight_1 * s1_16k / sqrt(lev1);
            %s2_16k = weight_2 * s2_16k / sqrt(lev2);
            
            %switch min_max{i_mm}
            %    case 'max'
            %        mix_16k_length = max(length(s1_16k),length(s2_16k));
            %        s1_16k = cat(1,s1_16k,zeros(mix_16k_length - length(s1_16k),1));
            %        s2_16k = cat(1,s2_16k,zeros(mix_16k_length - length(s2_16k),1));
            %    case 'min'
            %        mix_16k_length = min(length(s1_16k),length(s2_16k));
            %        s1_16k = s1_16k(1:mix_16k_length);
            %        s2_16k = s2_16k(1:mix_16k_length);
            %end
            %mix_16k = s1_16k + s2_16k;
            
            %max_amp_16k = max(cat(1,abs(mix_16k(:)),abs(s1_16k(:)),abs(s2_16k(:))));
            %mix_scaling_16k = 1/max_amp_16k*0.9;
            %s1_16k = mix_scaling_16k * s1_16k;
            %s2_16k = mix_scaling_16k * s2_16k;
            %mix_16k = mix_scaling_16k * mix_16k;            
            
            % save 8 kHz and 16 kHz mixtures, as well as
            % necessary scaling factors
            
            %scaling_16k(i,1) = weight_1 * mix_scaling_16k/ sqrt(lev1);
            %scaling_16k(i,2) = weight_2 * mix_scaling_16k/ sqrt(lev2);
            scaling_8k(i,1) = weight_1 * mix_scaling_8k/ sqrt(lev1);
            scaling_8k(i,2) = weight_2 * mix_scaling_8k/ sqrt(lev2);
            
            %scaling16bit_16k(i) = mix_scaling_16k;
            scaling16bit_8k(i)  = mix_scaling_8k;
            
            if useaudioread                          
                s1_8k = int16(round((2^15)*s1_8k));
                s2_8k = int16(round((2^15)*s2_8k));
                mix_8k = int16(round((2^15)*mix_8k));
                %s1_16k = int16(round((2^15)*s1_16k));
                %s2_16k = int16(round((2^15)*s2_16k));
                %mix_16k = int16(round((2^15)*mix_16k));
                audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav'],s1_8k,fs8k);
                %audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav'],s1_16k,fs16k);
                audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav'],s2_8k,fs8k);
                %audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav'],s2_16k,fs16k);
                audiowrite([output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav'],mix_8k,fs8k);
                %audiowrite([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav'],mix_16k,fs16k);
            else
                wavwrite(s1_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav']); %#ok<*DWVWR>
                %wavwrite(s1_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s1/' mix_name '.wav']);
                wavwrite(s2_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav']);
                %wavwrite(s2_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/s2/' mix_name '.wav']);
                wavwrite(mix_8k,fs8k,[output_dir8k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav']);
                %wavwrite(mix_16k,fs16k,[output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/mix/' mix_name '.wav']);
            end
            
            if mod(i,10)==0
                fprintf(1,'.');
                if mod(i,200)==0
                    fprintf(1,'\n');
                end
            end
            
        end
        save([output_dir8k  '/' min_max{i_mm} '/' data_type{i_type} '/scaling.mat'],'scaling_8k','scaling16bit_8k');
        %save([output_dir16k '/' min_max{i_mm} '/' data_type{i_type} '/scaling.mat'],'scaling_16k','scaling16bit_16k');
        
        fclose(fid);
        fclose(fid_s1);
        fclose(fid_s2);
        fclose(fid_m);
    end
end
