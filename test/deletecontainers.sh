#!/bin/bash

# Azure Storage account details
storage_account="adyatechstorage"

# Loop through each container name in emptybuckets.txt
while IFS= read -r container; do
    # Execute Azure CLI command to delete the container
    echo "Deleting container: $container"
    az storage container delete --account-name "$storage_account" --name "$container"
done < emptycontainers.txt
