#!/bin/bash


#A random number as password
PASSWORD=${RANDOM}
echo $PASSWORD

#Lengthy random password
PASSWORD=${RANDOM}${RANDOM}${RANDOM}
echo $PASSWORD

#Use current data/time as the basis of randomization
PASSWORD=$(date +%s)
echo $PASSWORD

#Use nanoseconds for randomization
PASSWORD=$(date +%s%N)
echo $PASSWORD

#A better random password using SHA and date time
PASSWORD=$(date +%s%N | sha256sum | head -c32)
echo $PASSWORD

#An even better method
PASSWORD=$(date +%s%N${RANDOM}${RANDOM} | sha256sum | head -c48)
echo $PASSWORD

#Adding special characters at the end of password
SPECIAL_CHARS=$(echo "@$%^#*()_+=₹~/]:"  fold -w1 | shuf | head -c1)
echo "$PASSWORD$SPECIAL_CHARS"
