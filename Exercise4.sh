#!/bin/bash

# Make sure the script is being executed with superuser privileges.

if [ ${UID} -ne 0 ] 
then
  echo "You don't have root previleges, run as root user" >&2
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.

if [ ${#} -lt 1 ]
then
  echo "${0} Usage: [Username] [Comment]" >&2
  echo >&2
  echo "Create an account on the local system with the name of USER_NAME" >&2
  echo "and a comments field of COMMENT." >&2
  exit 1
fi

# The first parameter is the user name.

USERNAME=${1}

# The rest of the parameters are for the account comments.
shift
COMMENT=${*}

# Generate random password.

PASSWORD=$( date +%s%N | sha256sum | head -c48 )

# Create the user with the password
# Check to see if the useradd command succeeded.

if ! useradd -c "$COMMENT" -m "$USERNAME" >/dev/null 2>&1
then
  echo "Error creating user, try again."
  exit 1
fi

# Set the password.
# Check to see if the passwd command succeeded.

if ! echo $USERNAME:$PASSWORD | chpasswd >/dev/null 2>&1
then
  echo "Error setting password, try again."
  exit 1
fi

# Force password change on first login.

if ! passwd -e "$USERNAME" >/dev/null 2>&1
then
    echo "Error expiring the password."
    unset PASSWORD
    exit 1
fi

# Get the hostname.

HOST_NAME=$(hostname)

# Display only the required account details on standard output.
echo "Username: $USERNAME"
echo -e "\nPassword: $PASSWORD"
echo -e "\nHost: $HOST_NAME"



