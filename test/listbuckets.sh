#!/bin/bash

# Run gcloud command to list buckets and capture output
buckets=$(gcloud storage buckets list --format="value(name)")

# Iterate over each bucket and write to file
for bucket in $buckets; do
    echo "$bucket" >> listallbuckets.txt
done
