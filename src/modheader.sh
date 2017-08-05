# Perform in-place conversion, save original as .backup
sed -i .backup "s/^calibration_units [^\s]*/calibration_units 1/" test.hdr