#!/bin/bash

file=~/workspace/datum/size.txt;

#check whether the file has read permission or not

if [ -O $file ];
then
filename=$(basename $file);
echo "this $filename has read permissions";
else
echo "check the logic";
fi

