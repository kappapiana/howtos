#!/bin/bash
while read line; do echo -n $line|sha256sum; done < $1 |awk '{print $1}' 
