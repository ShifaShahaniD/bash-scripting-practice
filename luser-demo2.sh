#!/bin/bash

#This program will get username and password from the user through standard input and created the account

#Get username

read -p "Enter username for creating account: " USER_NAME

#Get the name of the person creating the account

read -p "Enter the name of the person who this account is for: " PNAME

#Get password

read -p "Enter the password to use for the account: " PASSWORD

#Create user

sudo useradd -c "$COMMENT" -m "$USER_NAME"

#Set password for the user

echo $PASSWORD | passwd --stdin $USER_NAME

#The password should expire after first usage so that the user can create a new passwprd after first login

passwd -e $USER_NAME

