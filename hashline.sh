#!/bin/bash
# simple one-liner script to create the hash value of a text file takes each line.
# Use case: A wants to claim they can trade with their clients but they don't want
# to release information. Client gives the hashed list. If there is any challenge
# to that, the non-revealing party just gives the name and the other party can
# verify that the clientalready is listed. That does not compromise the entire
# list.

if file $1 | grep -q 'text'; then # checks it's a text file, else it's rubbish

  while read line; do echo -n $line|sha256sum; done < $1 |awk '{print $1}'

else

  echo "this is not a text file, please only use text files"

fi


# to check a single line:
# echo -n "[hashed string]" | sha256 sum | awk '{print $1}'
# "echo -n" avoids reading the newline at the end of each line
