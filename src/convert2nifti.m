function convert2nifti(inputfilepath, varargin)
%convert2nifti: Convert the image files to NIfTI format
%
%Usage: convert2nifti(inputfilepath)
%
%Converts the image files (either given explicitly, matching whildcards, 
%or in a directory) given by inputfilepath to NIfTI format.
%
%Mandatory arguments:
%    inputfilepath: The file name, directory, or search pattern
%        of the files to modify, given as a string.
%
%Optional arguments:
%    recursive: Search directories within inputfilepath. 
%        Options: true / false
%        Default: false
%    verbose: Display files being processed. 
%        Options: true / false
%        Default: false

% Add path to NIfTI toolbox
mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath,'../bin/NIfTI_20140122/'));

% Sensible Defaults
recursive = false;
verbose = false;

% Read optional arguments
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for ii = 1:2:(length(varargin)-1)
        switch lower(varargin{ii})
            case 'verbose';             verbose             = varargin{ii+1};
            case 'recursive';           recursive           = varargin{ii+1}; %
        otherwise
            % Something wrong with the parameter string
            error(['Unrecognized option: ''', varargin{ii}, '''']);
        end
    end
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
% After the above, we have the variables
% basepath: cell array of paths, no trailing '/', 
% filename: the base of the filename with wildcards, 
%           empty if unspecified, and
% extension: the extension of the file, empty if unspecified.

% Do the conversion:
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
            if verbose
                fprintf('Processing %s\n', current_file_full_path)
            end
            % Read given image file
            image = im3dhread(current_file_full_path);
            % Make and save NIfTI
            nii = make_nii(image.data, ...
                [str2double(image.VOXX), ...
                 str2double(image.VOXY), ...
                 str2double(image.VOXZ)], [0, 0, 0], 16, '');
            [~, filebase, ~] = fileparts(current_file.name);
            % Use same filename, but with .nii extension
            nii_filename = fullfile(current_file.folder, ...
                    strcat(filebase, '.nii'));
            save_nii(nii, nii_filename)
        end
    end
end