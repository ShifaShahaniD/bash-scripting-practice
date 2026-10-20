#!/bin/bash

# Make sure the script is being executed with superuser privileges.

if [ ${UID} -ne 0 ] 
then
  echo "You don't have root previleges, run as root user"
  exit 1
fi

# If the user doesn't supply at least one argument, then give them help.

if [ ${#} -lt 1 ]
then
  echo "${0} Usage: [Username] [Comment]"
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

if ! useradd -c "$COMMENT" -m "$USERNAME"
then
  echo "Error creating user, try again."
  exit 1
fi

# Set the password.
# Check to see if the passwd command succeeded.

if ! echo $USERNAME:$PASSWORD | chpasswd 
then
  echo "Error setting password, try again."
  exit 1
fi

# Force password change on first login.

if ! passwd -e "$USERNAME"; then
    echo "Error expiring the password."
    unset PASSWORD
    exit 1
fi

# Get the hostname.

HOST_NAME=$(hostname)

# Display the username, password, and the host where the user was created.
echo "Username: $USERNAME"
echo -e "\nPassword: $PASSWORD"
echo -e "\nHost: $HOST_NAME"



