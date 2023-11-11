#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 [xml-storage-path]"
	exit 0
fi

xml_storage_path=$1

# Save to seiscomp data base
for xml_file in $xml_storage_path/*;
do
	scdispatch -i ${xml_file} -O remove
done
