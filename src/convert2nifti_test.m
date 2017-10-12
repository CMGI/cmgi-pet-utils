% This function shows test cases for the convert2nifti function
addpath('../bin/niftimatlib-1.2/matlab/')

% Example 1: Convert the data in the file in 'filename'
filename = '../data/im3dh/reco_300x300x288_F000.im3dh';
convert2nifti(filename,'verbose', true);

