# Bash Scripting Practice

A hands-on repository documenting my learning journey in Bash scripting, Linux commands, log analysis, and system administration automation.

## Topics Covered

- Bash variables, arrays, loops, and conditional statements
- Linux commands: `find`, `grep`, `cat`, and `chmod`
- Log analysis and severity-based filtering
- Error counting and threshold-based warnings
- Practical shell scripting and automation

## Projects

### Log Analysis Script

**File:** `03-log-analysis/analyse_logs.sh`

A Bash script that:
- Finds recently modified log files
- Searches for `ERROR`, `FATAL`, and `CRITICAL` messages
- Displays matching log entries and counts
- Warns when a severity count exceeds a configured threshold

## How to Run

```bash
chmod +x 03-log-analysis/analyse_logs.sh
./03-log-analysis/analyse_logs.sh
```

Update the log directory in the script to match your local environment.

## Progress

This repository will grow as I practice new Bash commands and build practical automation scripts.
