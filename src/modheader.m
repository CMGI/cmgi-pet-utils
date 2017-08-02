function modheader(inputfilepath, parameter, value, varargin)
%modheader Modify PET header metadata.
%   Usage:
%   Single directory: 
%   modheader(inputfilepath, parameter, value)
%   Recursive:
%   modheader(inputfilepath, parameter, value, 'recursive')
%   Note:
%   To specify all files in a directory (regardless of extension),
%   a trailing forwardslash is required (at least on macOS). E.g., 
%   use '~/directory/' instead of '~/directory', the latter is
%   interpreted as the file 'directory' in the home directory.

%%%%%% Brainstorming Notes: %%%%%
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
%Recursively search all subdirectories for .hdr files
%In hdr file, change calibration_units 0 to calibration_units 1
%In hdr files, change calibration_factor to: 
%If hdr file starts with "D", use DPET_calibration
%If hdr file starts with "F", use F120_calibration


recursive = false;
if nargin > 3 && strcmpi(varargin{1}, 'recursive')
    recursive = true;
end

% Interpret 'inputfilepath'
[basepath, filename, extension] = fileparts(inputfilepath);
if isempty(basepath)
    basepath = '.';
end
basepath = {basepath};
if recursive
    basepath = textscan(genpath(basepath{1}), '%s', 'delimiter', ':');
    basepath = basepath{1};
end
% Left with
% basepath: cell array of paths, no trailing '/'
% filename: The base of the filename with wildcards, empty if unspecified.
% extension: The extension of the file, empty if unspecified.
basepath
filename
extension

% Do the modifications:
% Loop over paths
for path_index = 1:length(basepath)
    current_path = basepath{path_index};
    % List files in current_path matching given description
    files = dir(strcat(current_path, filesep, filename, extension));
    % Loop over files
    for file_index = 1:length(files)
        current_file = files(file_index);
        % Eliminiate directories
        if not(current_file.isdir)
            current_file_full_path = ...
                fullfile(current_file.folder, current_file.name);
        end
    end
end


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
