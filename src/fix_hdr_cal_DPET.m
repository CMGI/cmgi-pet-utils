%Recursively search all subdirectories for .hdr files
%In hdr file, change calibration_units 0 to calibration_units 1
%In hdr files, change calibration_factor to: 
%DPET calibration = 7.04074e+06


close all; clear all;
maindir = uigetdir;
paths = strread(genpath(maindir), '%s', 'delimiter', ';');

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
               fin = fopen(char(strcat(paths(i),'\',files(j).name)), 'rt');
               fout = fopen(char(strcat(paths(i),'\',fp_name,'_CALFIXED',fp_ext)), 'w+t');
               disp(strcat(paths(i),'\',fp_name,'_CALFIXED',fp_ext))
               %search through file
               while ~feof(fin)
                   s = fgetl(fin);
                   s = strrep(s,'calibration_units 0', 'calibration_units 1');
                   s = strrep(s, 'calibration_factor 1', 'calibration_factor 7.04074e+06');
                   fprintf(fout,'%s\n',s);
               end                        
                  fin = fclose(fin);
                  fout = fclose(fout);
           end
       end
    end
    
end
