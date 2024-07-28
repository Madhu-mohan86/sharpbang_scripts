#!/bin/bash

# Loop through each bucket URL in emptybuckets.txt
while IFS= read -r bucket_url; do
    bucket_name=$(basename "$bucket_url")  # Extract bucket name from URL
    echo "Checking bucket: $bucket_name"
    
    # List the contents of the bucket
    contents=$(gsutil ls -r $bucket_url 2>/dev/null)
    
    # Check if the bucket is empty (i.e., if $contents is empty)
    if [ -z "$contents" ]; then
        echo "Bucket $bucket_name is empty. Deleting..."
        # Delete the bucket and its contents
        gsutil rm -r $bucket_url
        
        # Record the deletion in a log file
        echo "Deleted bucket: $bucket_name" >> deleted_buckets.log
    else
        echo "Bucket $bucket_name is not empty. Skipping deletion."
    fi
done < emptybuckets.txt
