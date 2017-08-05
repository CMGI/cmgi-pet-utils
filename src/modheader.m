function modheader(inputfilepath, parameter, value, varargin)
%Modify PET header metadata.
%
%Usage: modheader(inputfilepath, parameter, value)
%
%Changes the parameter `parameter` to the value `value` in all the 
%files (either given explicitly, matching whildcards, or in a
%directory) given by `inputfilepath`.
%Optional arguments:
%    `recursive`: Search directories within `inputfilepath`. Valid
%        options are true or false.
%    Default: false
%        `verbose`: Display files being processed. Valid options are
%        true or false.
%    Default: false
%    `backupextension`: Backup original files by copying and
%        appending this extension. Empty value `[]` does not create
%        backups. 
%        Default: []

% Sensible Defaults
recursive = false;
verbose = false;
backupextension = [];

% Read optional arguments
if (rem(length(varargin),2)==1)
    error('Optional parameters should always go by pairs');
else
    for ii = 1:2:(length(varargin)-1)
        switch lower(varargin{ii})
            case 'verbose';             verbose             = varargin{ii+1};
            case 'recursive';           recursive           = varargin{ii+1}; %
            case 'backupextension';     backupextension     = varargin{ii+1}; %
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
            if verbose
                fprintf('Processing %s\n', current_file_full_path)
            end
            % Read header file
            old_header = fileread(current_file_full_path);
            % Use regex replacement
            new_header = regexprep(old_header, ...
                            [newline, parameter,' \S*'], ...
                            [parameter,' ',value]);
            % If desired, save a backup:
            if not(isempty(backupextension))
                fid = fopen([current_file_full_path,'.',backupextension],'wt');
                fprintf(fid, '%s', old_header);
                fclose(fid);
            end
            % Overwrite existing
            fid = fopen(current_file_full_path,'wt');
            fprintf(fid, '%s', new_header);
            fclose(fid);
        end
    end
end