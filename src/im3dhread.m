function image = im3dhread(filename)
%im3dhread: Read image data and metadata within im3dh files.
%
%Usage: image = im3dhread(filename)
%
%Mandatory arguments:
%    filename: The file name to open, given as a string.

% Start with empty struct.
image = struct;

% Open the file.
fid = fopen(filename);

% Read the information in the header,
% located in the first 8192 bytes of the file.
header = fread(fid, 1024, 'char*1', 0, 'l');
header = string(char(header'));

% Match the parameters using regular expressions.
matches = regexp(header,'\S*:\s*[ \w:/$|.*+?-]*','match');

% Separate out each field and value, place into image struct.
for match = matches
    splitmatch = regexp(match, ':\s*', 'split');
    field = splitmatch(1);
    value = strjoin(splitmatch(2:end),':');
    image.(char(field)) = char(value);
end

% Read in the actual image data starting after the header.
offset = 8192;
fseek(fid, offset, 'bof');

% Get the image dimensions.
NX = str2double(image.NX);
NY = str2double(image.NY);
NZ = str2double(image.NZ);

% Read (as a vector) the image data (32 bit float, little-endian).
image.data = fread(fid, NX*NY*NZ, 'float', 0, 'l');
image.data = reshape(image.data, [NX, NY, NZ]);

% Close the file.
fclose(fid);
