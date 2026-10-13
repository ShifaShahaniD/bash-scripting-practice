#!/bin/bash

log_dir="/Users/shifashahani/documents/logs/"

patterns=("ERROR" "FATAL" "CRITICAL")

log_files=$(find $log_dir -name "*.log" -mtime -1)

for log_file in $log_files; do
  echo "******************************************************"
  echo -e "\n\nProcessing file: $log_file"
  for error in "${patterns[@]}"; do
    echo "====================="
    echo -e "\n $error lines in $log_file: \n"
    grep "$error" "$log_file"

    echo -e "\n $error count"
    grep -c "$error" "$log_file"

    if [ "$(grep -c "$error" "$log_file")" -gt 10 ]; then
       echo "⚠Warning : More than 10 $error logs. Please take a look"
    fi
  done
done



