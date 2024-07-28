#!/bin/bash

# Azure Storage account details
storage_account="adyatechstorage"
container_name="$var"

# Execute Azure CLI command to get blob count
blob_count=$(az storage blob list --container-name $container_name --account-name $storage_account --query "length(@)")

if [ $blob_count -eq 0 ];then

echo "$var" >> emptycontainers.txt

fi
