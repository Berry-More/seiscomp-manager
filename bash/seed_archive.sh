#!/bin/bash

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 [mseed-storage-path]"
    exit 0
fi

mseed_storage_path=$1

# Save to SDS archive
for mseed_file in $mseed_storage_path/*;
do 
	scart -I ${mseed_file}
done
