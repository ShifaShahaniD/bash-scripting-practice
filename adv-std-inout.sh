#!/bin/bash

FILE="/Users/shifashahani/documents/bash-scripting-practice/adv-std-inout.txt"
ERR_FILE="/Users/shifashahani/documents/bash-scripting-practice/adv-std-inout.err"

#Redirect STDOUT to a file, appending to the file
echo "$RANDOM$RANDOM$RANDOM" >> "$FILE"
echo "$RANDOM$RANDOM$RANDOM" >> "$FILE"
echo

echo "Contents of the file: "
cat "$FILE"

#Redirect STDIN to a program, reading from a file using File descriptor 0
read LINE 0< "$FILE"
echo -e "\nLINE contains: $LINE"    

#Redirect STDOUT to a file using File descriptor 1
echo "Redirecting STDOUT to a file using File descriptor 1"
head -n3 /etc/hosts 1>> "$FILE"
echo

#Redirect STDERR to a file using File descriptor 2
echo "Redirecting STDERR to a file using File descriptor 2"
head -n3 /etc/hostss 2>> "$ERR_FILE"
echo

#Redirect STDOUT and STDERR to a file using File descriptor 1 and 2
echo "Redirecting STDOUT and STDERR to a file using File descriptor 1 and 2"
head -n3 /etc/hosts /etc/hosts >> "$FILE" 2>&1
echo

#Redirecting STDOUT and STDERR to different files using File descriptor 1 and 2
head -n3 /etc/hosts /etc/hostss 1>> "$FILE" 2>> "$ERR_FILE"

#Discarding STDOUTand STDERR by redirecting to /dev/null
echo "Discarding STDOUT and STDERR by redirecting to /dev/null"
head -n3 /etc/hosts /etc/hostss >& /dev/null

#Clean up
rm "$FILE" "$ERR_FILE" &> /dev/null