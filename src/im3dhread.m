% This will read an im3db file
clear; close all; clc

filename = '../data/FOX01 studies/45005/Dynamic/FDG_MMU45005_P20170920-112454_SC-002_5min_frames_60min_NAC_CMGI-20170926T174702Z-001/FDG_MMU45005_P20170920-112454_SC-002_5min_frames_60min_NAC_CMGI/reco_300x300x288_F000.im3dh';

fid = fopen(filename);

header = fread(fid, 1024, 'char*1', 0, 'l');
header_string = string(char(header'));
char(header')
offset = 8192;
% Remember: 10 is line return
% 32 is space
    
% BBEdit Grep search pattern \S*: *.*

matches = regexp(header_string,'\S*:\s*[ \w:/$|.*+?-]*','match');

matches'

data = struct;

for match=matches
    match
    splitmatch = regexp(match, ':\s*', 'split');
    field = splitmatch(1);
    value = strjoin(splitmatch(2:end),':');
    %field = regexp(match,'(\S*):','match');
    field
    value
    data.(char(field)) = char(value);
   
end



fseek(fid, offset, 'bof');

n1 = str2num(data.NX);
n2 = str2num(data.NY);
n3 = str2num(data.NZ);

X = fread(fid, [n1*n2*n3], 'float', 0, 'l');

data.data = reshape(X, [n1, n2, n3]);

figure;imagesc(data.data(:,:,100));colormap gray;axis image

fclose(fid);


