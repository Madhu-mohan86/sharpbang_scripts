#!/bin/bash

# Azure Storage account details
storage_account="adyatechstorage"

# Array to hold container names
containers=($(az storage container list --account-name $storage_account --query "[].name" --output tsv))

# Output file for empty containers
output_file="emptycontainers.txt"

# Function to check if container is empty and write to file
check_and_write_empty_container() {
    local container_name="$1"
    local blob_count=$(az storage blob list --container-name $container_name --account-name $storage_account --query "length(@)")
    
    if [ "$blob_count" -eq 0 ]; then
        echo "$container_name" >> "$output_file"
        echo "\e[32m Container $container_name added to $output_file"
    fi
}

# Loop through each container and check if it's empty
for container in "${containers[@]}"; do
    check_and_write_empty_container "$container"
done

echo "Empty containers check completed."
