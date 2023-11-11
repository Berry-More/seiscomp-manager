#!/bin/bash

seiscomp_path='/home/sysop/seiscomp'

station_binding_config=\
"# Binding references
global:HH
scautopick:default
seedlink:fifo
"
global_binding_config=\
"# Defines the channel code of the preferred stream used by e.g. scautopick and
# scrttv. If no component code is given, the vertical component will be fetched
# from inventory. For that the channel orientation (azimuth, dip) will be used.
# If that approach fails, 'Z' will be appended and used as fallback.
detecStream = HH

# Defines the location code of the preferred stream used eg by scautopick and
# scrttv.
detecLocid = 00
"
seedlink_binding_config=\
"# Activated plugins for category sources
sources = fifo:mseedfifo
"
scautopick_binding_config=\
"# Defines the channel code of the preferred stream used by e.g. scautopick and
# scrttv. If no component code is given, the vertical component will be fetched
# from inventory. For that the channel orientation (azimuth, dip) will be used.
# If that approach fails, 'Z' will be appended and used as fallback.
detecStream = HH

# Defines the location code of the preferred stream used eg by scautopick and
# scrttv.
detecLocid = 00
"

fdsnws_config=\
'recordstream = sdsarchive:///home/sysop/seiscomp/var/lib/archive
'

keys_dir="${seiscomp_path}/etc/key"

mkdir -p ${keys_dir}

# You should write your station names below
# -------
printf "${station_binding_config}" > "${keys_dir}/station_LD_SML00"
# ------

mkdir -p "${keys_dir}/global"
printf "$global_binding_config" > "${keys_dir}/global/profile_HH"

mkdir -p "${keys_dir}/seedlink"
printf "$seedlink_binding_config" > "${keys_dir}/seedlink/profile_fifo"

mkdir -p "${keys_dir}/scautopick"
printf "$scautopick_binding_config" > "${keys_dir}/scautopick/profile_default"

printf "$fdsnws_config" > "${seiscomp_path}/etc/fdsnws.cfg"
