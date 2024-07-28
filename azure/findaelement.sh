#!/bin/bash

#read the ip from a user
echo "give the server ip "

read given_ip

# Fetch JSON data from Azure CLI command
json=$(az network public-ip list -g adya-datascience --query "[].[ipAddress,ipConfiguration]" -o json)

# Declare an associative array
declare -A ipdb

# Index for keys
index=0

# Process JSON with jq and populate associative array
while IFS= read -r line; do
    # Parse each line and assign to associative array
    if [[ "$line" =~ ^public\ id\ address:\ (.*)$ ]]; then
        current_ip="${BASH_REMATCH[1]}"
        # Create unique keys for each IP
        ipdb["${index}_address"]="${current_ip}"
        elif [[ "$line" =~ ^id:\ (.*)$ ]]; then
        ipdb["${index}_id"]="${BASH_REMATCH[1]}"
        elif [[ "$line" =~ ^resourceGroup:\ (.*)$ ]]; then
        ipdb["${index}_resourceGroup"]="${BASH_REMATCH[1]}"
        # Increment index after capturing all details for one IP
        index=$((index + 1))
    fi
    done < <(echo "$json" | jq -r '
  .[] |
  "public id address: \(.[] | select(type == "string"))\n" +
  (.[] | select(type == "object") | to_entries | map("\(.key): \(.value)") | join("\n"))
')

# Print the associative array for verification
for ((i=0; i<index; i++)); do
    
    #if given IP matches the listed ip
    if [[ "$given_ip" == "${ipdb[${i}_address]}" ]];then
        network_interface_id=${ipdb[${i}_id]}
        resource_group=${ipdb[${i}_resourceGroup]}
    fi
done

#extract the nic name from the nic id
nic_name=$(echo $network_interface_id | awk -F'networkInterfaces/' '{print $2}' | awk -F'/' '{print $1}')

nsg_id=$(az network nic show --resource-group $resource_group --name $nic_name --query "networkSecurityGroup.id" --output tsv)

nsg_name=$(echo $nsg_id | awk -F'networkSecurityGroups/' '{print $2}' | awk -F'/' '{print $1}')

echo "nsg_name is : $nsg_name"

port_rule_array=$(az network nsg rule list -g $resource_group --nsg-name $nsg_name --query "[].name" -o json)

check_DB_rule="CustomDBports"

if [[ $(echo ${port_rule_array[@]}) =~ $check_DB_rule ]]
then
    echo "there is DB rule . which rule you want to update"
else
    echo "there is only ssh rule so updating it"
    src_addrss_prefixes_jsonarray=$(az network nsg rule list -g $resource_group --nsg-name $nsg_name --query "[].sourceAddressPrefixes" -o json)
    readarray -t src_addrss_prefixes_basharr < <(echo "$src_addrss_prefixes_jsonarray" | jq -r '.[0][]')
    echo "give your ip to whitelist"
    read developer_ip
    if [[ $(echo ${src_addrss_prefixes_basharr[@]}) =~ $developer_ip ]]
    then
        echo "the given ip is already whitelisted"
    else
        src_addrss_prefixes_basharr+=($developer_ip)
        rule_name="SSH"
        az network nsg rule update -g $resource_group --nsg-name $nsg_name --name $rule_name --source-address-prefixes ${src_addrss_prefixes_basharr[*]}
    fi
fi