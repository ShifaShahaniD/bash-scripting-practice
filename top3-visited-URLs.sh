#!/bin/bash

# This script retrieves the top 3 most visited URLs from a web server log file.

LOG_FILE="${1}"

if [[ -z "${LOG_FILE}" ]]; then
    echo "Usage: $0 <log_file>"
    exit 1
fi

if [[ ! -f "${LOG_FILE}" ]]; then
    echo "Error: Log file '${LOG_FILE}' does not exist."
    exit 1
fi

# Extract the URLs from the log file, count their occurrences, sort them, and get the top 3
TOP_URLS=$(awk '{print $7}' "${LOG_FILE}" | sort | uniq -c | sort -rn | head -n 3)

echo "Top 3 most visited URLs:"
echo "${TOP_URLS}" | awk '{print $2 " - " $1 " visits"}'
