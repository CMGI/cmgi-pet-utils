% This function shows test cases for the im3dhread function

% Example 1: Read the data in the file in 'filename'
filename = '../data/FOX01 studies/45005/Dynamic/FDG_MMU45005_P20170920-112454_SC-002_5min_frames_60min_NAC_CMGI-20170926T174702Z-001/FDG_MMU45005_P20170920-112454_SC-002_5min_frames_60min_NAC_CMGI/reco_300x300x288_F000.im3dh';
image = im3dhread(filename);
