#!/usr/bin/env bash
USAGE="modheader: Modify PET header metadata\n"
USAGE+="\n"
USAGE+="Usage: modheader inputfilepath parameter value [optional arguments]\n"
USAGE+="\n"
USAGE+="Changes the parameter to the given value in all the\n"
USAGE+="files (either given explicitly, matching whildcards,\n"
USAGE+="or in a directory) given by inputfilepath.\n"
USAGE+="\n"
USAGE+="Mandatory arguments:\n"
USAGE+="\tinputfilepath: The file name, directory, or search pattern\n"
USAGE+="\t\tof the files to modify.\n"
USAGE+="\tparameter: The parameter name to change.\n"
USAGE+="\tvalue: The new value of the parameter.\n"
USAGE+="\n"
USAGE+="Optional arguments:\n"
USAGE+="\t-r --recursive: Search directories within inputfilepath.\n"
USAGE+="\t\tOptions: true / false\n"
USAGE+="\t\tDefault: false\n"
USAGE+="\t-v --verbose:: Display files being processed.\n"
USAGE+="\t\tOptions: true / false\n"
USAGE+="\t\tDefault: false\n"
USAGE+="\t-b --backupextension: Backup original files by copying\n"
USAGE+="\t\tand appending this extension.\n"
USAGE+="\t\tOptions: Any string, e.g., .backup\n"
USAGE+="\t\tDefault: Do not create backups.\n"

if [ $# == 0 -o "$1" == "-h" -o "$1" == "--help" ]; then
  echo -e $USAGE
  exit 0
fi

# Sensible defaults
RECURSIVE=false
VERBOSE=false
BACKUPEXTENSION=false

# Read mandatory arguments
INPUTFILEPATH=$1
PARAMETER=$2
VALUE=$3

# Read optional arguments
shift 3
while [[ $# -gt 0 ]]
do
echo $#
key="$1"

case $key in
    -r|--recursive)
    RECURSIVE="$2"
    shift # past argument
    ;;
    -v|--verbose)
    VERBOSE="$2"
    shift # past argument
    ;;
    -b|--backupextension)
    BACKUPEXTENSION="$2"
    shift # past argument
    ;;
    *)
    shift # past argument
    ;;
esac
done

# Do the modifications

exit 0




# Perform in-place conversion, save original as .backup
sed -i .backup "s/^calibration_units [^\s]*/calibration_units 1/" test.hdr

# Use find to search for header files, recursively
# then use xargs to process them

find . -name "F*.hdr" -print0 | xargs -0 sed -i .backup "s/^calibration_units [^\s]*/calibration_units 1/"

# To not do recursively, specify maxdepth
find DirsRoot/* -maxdepth 0 -type f #This does not show hidden files
# Or:
find DirsRoot/ -maxdepth 1 -type f #This does show hidden files




