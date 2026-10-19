#!/bin/bash

# Make sure the script is being executed with superuser privileges.

if [ ${UID} -ne 0 ] 
then
  echo "You don't have root previleges, run as root user"
  exit 1
fi

# Get the username (login)

read -r -p "Enter the username of the account: " USERNAME

# Get the real name (contents for the description field).

read -r -p "Enter the name of the person this account is created for: " REAL_NAME

# Get the password.

read -r -s -p "Enter the password for the user account: " PASSWORD
echo

#Check if all variables have non-zero value

if [[ -z ${USERNAME} || -z ${PASSWORD} || -z ${REAL_NAME} ]]
then
  echo "All fields are required!"
  exit 1
fi

# Create the user with the password
# Check to see if the useradd command succeeded.


if ! useradd -c "$REAL_NAME" -m "$USERNAME"
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

passwd -e "$USERNAME"

HOST_NAME=$(hostname)

# Display the username, password, and the host where the user was created.
echo "Username: $USERNAME"
echo -e "\nPassword: $PASSWORD"
echo -e "\nHost: $HOST_NAME"



