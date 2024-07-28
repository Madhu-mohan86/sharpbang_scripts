#!/bin/bash

echo "$(/bin/date +%Y-%m-%d)"

# filelisting=*.sh

# i=0;

# for file in $filelisting;
# do
# echo " the file $((i=i+1)) is $file";
# done

filelisting=$(ls -l)

echo $filelisting | grep madhu | wc -l