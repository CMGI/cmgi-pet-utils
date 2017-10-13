function verifyvois(inputfilepath, voinames, varargin)
%verifyvois: Verify order of PMOD VOIs in *.voi files
%
%Usage: verifyvois(inputfilepath, voinames)
%
%Changes the parameter to the given value in all the
%files (either given explicitly, matching whildcards, or in a
%directory) given by inputfilepath.
%
%Mandatory arguments:
%    inputfilepath: The file name, directory, or search pattern
%        of the files to modify, given as a string.
%    parameter: List of VOI names, given as a cell array of chars. 
%
%Optional arguments:
%    recursive: Search directories within inputfilepath. 
%        Options: true / false
%        Default: false
%    verbose: Display files being processed. 
%        Options: true / false
%        Default: false

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
            % Read VOI file
            voi_file = fileread(current_file_full_path);
            voi_matches = regexp(voi_file,'\S* # voi_name','match');
            voi_matches = regexp(voi_matches, ' # voi_name', 'split');
            voi_file_names = cell(1,length(voi_matches));
            for ii = 1:length(voi_matches)
                voi_file_names(ii) = voi_matches{ii}(1);
            end
            if length(voi_file_names) == length(voinames)
                if all(strcmp(voi_file_names, voinames))
                    if verbose
                        fprintf('VOI order correct in %s\n', current_file_full_path);
                    end
                else
                    fprintf('Error: VOI order incorrect in %s\n', current_file_full_path);
                end
            else
                fprintf('Error: Number of VOIs differs in %s\n', current_file_full_path)
            end
        end
    end
end