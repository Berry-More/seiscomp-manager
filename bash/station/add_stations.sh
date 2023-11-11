#!/bin/bash

if [ "$#" -lt 1 ]; then
	echo "Usage: $0 [station-xml-path]"
	exit 0
fi

station_xml_path=$1
seiscomp_pass=pass

bash ./setup_configs.sh
seiscomp exec bindings2cfg --debug -o config.xml
seiscomp exec scxmlmerge $station_xml_path config.xml > configuration.xml
seiscomp exec import_inv fdsnxml ${station_xml_path}
seiscomp exec scdb --debug -i configuration.xml -d postgresql://sysop:${seiscomp_pass}@localhost/seiscomp
seiscomp update-config

rm config.xml configuration.xml

seiscomp stop
seiscomp start
