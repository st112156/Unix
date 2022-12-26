#!/bin/bash

 # Set default file to /etc/passwd
file="/etc/passwd"

# Parse command line arguments
while getopts ":f:u:l:" opt; do
  case $opt in
    f)
      file=$OPTARG
      ;;
    u)
      uid=$OPTARG
      login=''
      ;;
    l)
      login=$OPTARG
      uid=''
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 2
      ;;
  esac
done

# Check if either login or uid was specified
if [ -z "$login" ] && [ -z "$uid" ]; then
  echo "Error: either login or uid must be specified." >&2
  exit 2
fi

# Search the file for the specified login or uid
if [ -n "$login" ]; then
  grep "^$login:" $file > /dev/null
elif [ -n "$uid" ]; then
  grep ":$uid:" $file > /dev/null
fi

# Check the exit status of the previous command to determine if the user was found
if [ $? -eq 0 ]; then
  exit 0
else
  exit 1
fi
