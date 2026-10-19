#!/bin/bash

#Display the UID and username of the user executing this script
#Display if the user is root user or not

# ${UID} -> special built-in variable that contains the user ID of current user

echo "Your User ID is ${UID} "

USER_NAME=$(id -un)

echo "Your User Name is $USER_NAME"

if [ "${UID}" -eq 0 ]; then
  echo 'You are a root user'
else
  echo 'Sorry, you are not a root user'
fi
 
