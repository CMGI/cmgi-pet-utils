% This function shows test cases for the verifyvois function

% Example 1: Verify the VOI order in filename
% This test should PASS
filename = '../data/voi/R14-196-D03.voi';
voinames = {'HR', 'HL', 'PCR', 'PCL', 'MT', 'DLTR', 'DLTL', ...
    'CIR', 'COR', 'CIL', 'COL', 'CDR', 'CDL', 'Cerebellum'};
verifyvois(filename, voinames, 'verbose', true)

% Example 2: Verify the VOI order in filename
% This test should FAIL (the voinames are now in a different order)
voinames = {'HR', 'HL', 'PCR', 'PCL', 'CIR', 'COR', 'CIL', 'COL', ...
    'DLTR', 'DLTL', 'MT', 'CDR', 'CDL', 'Cerebellum'};
verifyvois(filename, voinames, 'verbose', true)
