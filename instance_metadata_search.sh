#!/bin/bash

KEY=$1

# Download jq for parsing json. 
curl -sLo jq https://github.com/jqlang/jq/releases/download/jq-1.6/jq-linux64

# download instance metadata and save it as metadata.json
curl -o metadata.json -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" 

# search for key 
if [ "$#" -ne 1 ]; then
    echo "usage : sh instance_metadata_search.sh vmId"
else
	Query="jq -r '..|if select(has(\"$KEY\"))? then .$KEY else empty end' metadata.json"
	search_result=$(eval $Query)
	if [ $search_result == "" ]; then
	echo "Key not found!"
	else
	echo "Search Output : $search_result"
fi
fi
