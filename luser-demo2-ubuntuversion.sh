
#!/bin/bash

# Create a Linux user account and require a password change at first login.

#Thie version is more optimised

set -e

# Get the username
read -r -p "Enter username for creating account: " USER_NAME

# Get the person's name
read -r -p "Enter the name of the person this account is for: " PNAME

# Get the initial password without displaying it
read -r -s -p "Enter the password to use for the account: " PASSWORD
echo

# Validate that the required inputs are provided
if [[ -z "$USER_NAME" || -z "$PNAME" || -z "$PASSWORD" ]]; then
    echo "Error: All fields are required."
    exit 1
fi

# Create the user account with the person's name as the comment
sudo useradd -c "$PNAME" -m "$USER_NAME"

# Set the user's initial password
echo "$USER_NAME:$PASSWORD" | sudo chpasswd

# Force the user to change the password at the next login
sudo passwd -e "$USER_NAME"

# Clear the password variable
unset PASSWORD

echo "User '$USER_NAME' created successfully."

