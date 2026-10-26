#!/bin/bash

# Description:
# Disables or deletes local Linux user accounts based on the provided options.
# Supports removing or archiving users' home directories.
# Accepts multiple usernames and requires root privileges.
# Refuses to modify accounts with a UID below 1000.
#
# Usage: sudo ./disable-local-user.sh [-d] [-r] [-a] USER_NAME [...]
#   -d  Delete user accounts instead of disabling them.
#   -r  Remove users' home directories.
#   -a  Archive users' home directories to /archives.


# Display usage information.
usage() {
    echo "Usage: ${0} [-d] [-r] [-a] USER_NAME [USER_NAME ...]" >&2
    echo >&2
    echo "Disable or delete local Linux accounts." >&2
    echo "Options:" >&2
    echo "  -d   Delete accounts instead of disabling them." >&2
    echo "  -r   Remove the home directory associated with the account." >&2
    echo "  -a   Archive the home directory in /archives." >&2
}

# Make sure the script is executed with root privileges.
if [[ "${UID}" -ne 0 ]]
then
    echo "Error: Run this script as root or using sudo." >&2
    exit 1
fi

# Set default option values.
DELETE=false
REMOVE=false
ARCHIVE=false

# Process command-line options.
while getopts ":dra" option
do
    case "${option}" in
        d) DELETE=true ;;
        r) REMOVE=true ;;
        a) ARCHIVE=true ;;
        *) usage
           exit 1 ;;
    esac
done

# Remove the options from the positional parameters.
shift "$((OPTIND - 1))"

# Check whether at least one username was provided.
if [[ "${#}" -lt 1 ]]
then
    usage
    exit 1
fi

# Create the archive directory if archiving was requested.
if [[ "${ARCHIVE}" == true ]]
then
    if ! mkdir -p /archives >/dev/null 2>&1
    then
        echo "Error: Unable to create /archives." >&2
        exit 1
    fi
fi

# Process each username supplied to the script.
for USERNAME in "$@"
do
    echo "Processing user: ${USERNAME}"

    # Check whether the account exists.
    if ! id "${USERNAME}" >/dev/null 2>&1
    then
        echo "Error: User '${USERNAME}' does not exist." >&2
        continue
    fi

    # Get the user's UID.
    USER_UID=$(id -u "${USERNAME}")

    # Refuse to modify accounts with UID below 1000.
    if [[ "${USER_UID}" -lt 1000 ]]
    then
        echo "Error: Cannot modify '${USERNAME}' because its UID is below 1000." >&2
        continue
    fi

    # Set the user's home directory.
    HOME_DIR="/home/${USERNAME}"

    # Archive the home directory before deleting the account or files.
    if [[ "${ARCHIVE}" == true ]]
    then
        if [[ -d "${HOME_DIR}" ]]
        then
            ARCHIVE_FILE="/archives/${USERNAME}-$(date +%Y%m%d%H%M%S).tar.gz"

            if tar -czf "${ARCHIVE_FILE}" -C /home "${USERNAME}" >/dev/null 2>&1
            then
                echo "Home directory archived: ${ARCHIVE_FILE}"
            else
                echo "Error: Failed to archive ${HOME_DIR}." >&2
            fi
        else
            echo "Error: Home directory ${HOME_DIR} does not exist." >&2
        fi
    fi

    # Delete the account if -d was specified.
    if [[ "${DELETE}" == true ]]
    then
        if userdel "${USERNAME}" >/dev/null 2>&1
        then
            echo "Account deleted: ${USERNAME}"
        else
            echo "Error: Failed to delete account '${USERNAME}'." >&2
            continue
        fi
    else
        # Otherwise, disable the account.
        if usermod -L "${USERNAME}" >/dev/null 2>&1 &&
           chage -E 0 "${USERNAME}" >/dev/null 2>&1
        then
            echo "Account disabled: ${USERNAME}"
        else
            echo "Error: Failed to disable account '${USERNAME}'." >&2
            continue
        fi
    fi

    # Remove the home directory if -r was specified.
    if [[ "${REMOVE}" == true ]]
    then
        if [[ -d "${HOME_DIR}" ]]
        then
            if rm -rf "${HOME_DIR}" >/dev/null 2>&1
            then
                echo "Home directory removed: ${HOME_DIR}"
            else
                echo "Error: Failed to remove ${HOME_DIR}." >&2
            fi
        else
            echo "Home directory does not exist; nothing to remove."
        fi
    fi

    echo "Finished processing: ${USERNAME}"
    echo

done
