function fix_hdr_cal_fn(filepath, parameter, value, varargin)
% Usage
% fix_hdr_cal_fn('~/data/F*.hdr', 'calibration_factor', '6.7e6',
% 'recursive')

recursive = false;
if nargin > 3 && strcmpi(varargin{1}, 'recursive')
    recursive = true;
end

return





%function fix_hdr_cal_fn%(DPET_calibration, F120_calibration)
% Mandatory arguments: 
%   % file or path (operate on single file vs whole directory)
%   % parameter to change (e.g, 'calibration_factor'), notify user if not
%       found in filed
%   % value of the parameter (e.g., '6.74419e6'), output a successfull
%   change
%       'file.hdr: value of calibration_factor changed from 1 to 6.74419e6'
% Optional arguments:
%   -r recursive (only valid for path arguments)
%   file name filter specifier (e.g., D*.hdr vs F*.hdr for DPET vs Focus)
%   Maybe just put in the filename, because that's how unix commands work,
%   e.g., 'ls *.hdr' shows the header files. 




DPET_calibration = '6.74419e6';
F120_calibration = '7.00806e6';

%Recursively search all subdirectories for .hdr files
%In hdr file, change calibration_units 0 to calibration_units 1
%In hdr files, change calibration_factor to: 
%If hdr file starts with "D", use DPET_calibration
%If hdr file starts with "F", use F120_calibration

maindir = uigetdir;
paths = strread(genpath(maindir), '%s', 'delimiter', ':');

return
%loop over the paths list
for i=1:length(paths)
    %in current directory, get file list, 
    files = dir(paths{i});
    %loop through files in this directory
    for j=1:length(files)
       %only search for .hdr if isdir == 0
       if files(j).isdir == 0
           %look for .hdr files
           [fp_path, fp_name, fp_ext] = fileparts(files(j).name);
           if strcmpi(fp_ext, '.hdr') == 1
               %display test
               %disp(strcat(paths(i),'\',files(j).name))

               %open file
               fin = fopen(char(strcat(paths(i),filesep,files(j).name)), 'rt');
               fout = fopen(char(strcat(paths(i),filesep,fp_name,'_CALFIXED',fp_ext)), 'w+t');
               disp(strcat(paths(i),'\',fp_name,'_CALFIXED',fp_ext))
               %search through file
               while ~feof(fin)
                   s = fgetl(fin);
                   s = strrep(s,'calibration_units 0', 'calibration_units 1');
                   if strcmpi(fp_name(1),'D')
                       s = strrep(s, 'calibration_factor 1', strcat('calibration_factor ', DPET_calibration));
                   elseif strcmpi(fp_name(1), 'F')
                       s = strrep(s, 'calibration_factor 1', strcat('calibration_factor ', F120_calibration));
                   end
                   fprintf(fout,'%s\n',s);
               end                        
                  fin = fclose(fin);
                  fout = fclose(fout);
           end
       end
    end
    
end
