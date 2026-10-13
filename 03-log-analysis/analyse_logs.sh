#!/bin/bash

# Define the directory containing the log files
log_dir="/Users/shifashahani/Documents/logs/"

# Specify the log severity levels to search for
patterns=("ERROR" "FATAL" "CRITICAL")

# Find all .log files modified within the last 24 hours
log_files=$(find "$log_dir" -name "*.log" -mtime -1)

# Loop through each log file found by the find command
for log_file in $log_files; do

    # Print a separator and display the current file being processed
    echo "******************************************************"
    echo -e "\n\nProcessing file: $log_file"

    # Loop through each severity level in the patterns array
    for error in "${patterns[@]}"; do

        # Print a separator before displaying the matching log entries
        echo "====================="
        echo -e "\n $error lines in $log_file: \n"

        # Display all lines containing the current severity level
        grep "$error" "$log_file"

        # Count and display the number of matching lines
        echo -e "\n $error count"
        grep -c "$error" "$log_file"

        # Check whether the number of matching lines exceeds 10
        if [ "$(grep -c "$error" "$log_file")" -gt 10 ]; then

            # Display a warning if the count is greater than 10
            echo "Warning: More than 10 $error logs. Please take a look"
        fi

    # Move to the next severity level
    done

# Move to the next log file
done


