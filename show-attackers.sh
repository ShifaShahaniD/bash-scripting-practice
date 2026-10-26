#!/bin/bash

# This script identifies IP addresses with more than 10 failed login attempts
# and displays their attempt counts and geographic locations in CSV format.

#Requires that a file is provided as an argument.  If a file is not provided, or it cannot be read, then the script will display an error message and exit with a status of 1.
if [ $# -ne 1 ]; then
    echo "Error: No file provided."
    exit 1
fi

# Check whether the file exists and is readable.
if [ ! -r "$1" ]; then
    echo "Error: File cannot be read."
    exit 1
fi

# Display the CSV header.
echo "Count,IP,Location"

# Extract IP addresses from failed login attempts, count them,
# sort by count in descending order, and process IPs with more than 10 attempts.
# log format: Oct 26 05:49:56 web01 sshd[91039]: Accepted publickey for shifa from 203.0.113.25 port 48175 ssh2

grep "Failed password" "$1" | awk '{print $(NF - 3)}' | sort | uniq -c | sort -nr | while read count ip; do
    if [ "$count" -gt 10 ]; then
        location=$(geoiplookup "$ip" | awk -F ', ' '{print $2}')
        echo "$count,$ip,$location"
    fi
done  








