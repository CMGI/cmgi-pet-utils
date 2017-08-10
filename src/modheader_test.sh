#!/usr/bin/env bash
# This function shows test cases for the modheader function

# Example 1: Recursively modify all headers beginning with F
# by changing the calibration_factor field to 7.00806e6.
source modheader ../data/F*.hdr calibration_factor 7.00806e6 -r true

# Example 2: Recursively modify all headers beginning with D
# by changing the calibration_factor field to 6.74419e6,
# Saving backup files with appended extension .backup
source modheader ../data/D*.hdr calibration_factor 6.74419e6 -r true -b backup

# Example 3: Recursively modify all headers by changing
# the calibration_units field to 1.
# Use verbose output
source modheader ../data/*.hdr calibration_units 1 -r true -v true

