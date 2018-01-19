#!/bin/bash
# simple one-liner script to create the hash value of a text file takes each line.
# Use case: A wants to claim they can trade with their clients but they don't want
# to release information. Client gives the hashed list. If there is any challenge
# to that, the non-revealing party just gives the name and the other party can
# verify that the clientalready is listed. That does not copromise the entire
# list.

while read line; do echo -n $line|sha256sum; done < $1 |awk '{print $1}'

# to check a single line:
# echo -n "[hashed string]" | sha256 sum | awk '{print $1}' 
