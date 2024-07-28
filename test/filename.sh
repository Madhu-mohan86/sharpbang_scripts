#!/bin/bash
filename="sample.md"
if [ -e "$filename" ]; then
    echo "$filename already exists"
else
    touch $filename
fi
if [ -r "$filename" ]; then
    echo "you are allowed to read $filename"
else
    echo "you are not allowed to read $filename"
fi
