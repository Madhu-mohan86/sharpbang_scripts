#!/bin/bash

i=0
j=0

# Iterate over each bucket returned by gsutil ls
for var in $(gsutil ls); do
    # Check if the bucket is empty
    output=$(gsutil ls "$var")
    if [ ${#output} -eq 0 ]; then
        echo "Empty buckets $((i=i+1)): $var" >> emptybuckets.txt
    else
        echo "non empty buckets $((j=j+1))"
    fi
done

echo "Total empty buckets found: $i"
