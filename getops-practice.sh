#!/bin/bash

#This script generates a random password
#This user can set the password length with -l option and add special characters to the password using -s flag
#Verbose mode can be enabled with -v option

#Setting a default password length
LENGTH=48

usage() {
  echo "Usage: ${0} [-l length] [-s] [-v]"
  echo "Generate a random password with the specified length and options."
  echo "  -l length   Specify the length of the password (default: 48)"
  echo "  -s          Include special characters in the password"
  echo "  -v          Enable verbose mode"
}

while getopts l:sv option
do
  case "${option}" in
    l) LENGTH=${OPTARG} ;;
    s) SPECIAL_CHARACTERS='true' ;;
    v) VERBOSE='true' ;;
    *) usage
       exit 1 ;;
  esac
done

echo "Number of arguments left after parsing options: ${#}"
echo 'All arguments: ' "$@"
echo 'first argument: ' "$1"
echo 'second argument: ' "$2"
echo 'third argument: ' "$3"

#Inspect OPTIND variable to see how many options were parsed
echo 'Number of options parsed: ' "$OPTIND"

#After the shift command, the remaining arguments will be available in $1, $2, etc.
echo 'All arguments after shift: ' "$@"
echo 'All arguments: ' "$@"
echo 'first argument: ' "$1"
echo 'second argument: ' "$2"
echo 'third argument: ' "$3

#Remove the options while leaving the remaining arguments
shift $(( OPTIND - 1 ))

#Generate the password
PASSWORD=$(date +%s%N | sha256sum | head -c${LENGTH})
if [[ "${SPECIAL_CHARACTERS}" == 'true' ]]
then
  echo 'Adding special characters to the password'
  SPECIAL_CHARACTER=$( echo '!@#$%^&*()_+' | fold -w1 | shuf | head -c1 )
  PASSWORD="${PASSWORD}${SPECIAL_CHARACTER}"
fi

echo "Generated password: ${PASSWORD}"

exit 0