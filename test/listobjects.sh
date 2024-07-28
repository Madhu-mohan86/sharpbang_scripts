#!/bin/bash

while IFS= read -r line; do
    echo "bucket name : $line"
    command=$(gcloud storage ls --recursive $line)
    echo "contents of $line is $command" >> ifmissed.txt
done < emptybuckets.txt