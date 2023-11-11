# Seiscomp lab 572

This project consists scripts and instructions for working with **Seisomp software**. **Seiscomp** - it is big application, which allow **obtain**, **store** and **process** seismology data. Seiscomp developers is a GFZ German Research Centre for Geosciences. In this paper I try to explain how you can store your seismology data in Seiscomp. In our case Seiscomp consists three types of data: seismic traces (**MSEED**), metadata about seismological stations (**StationXML**) and informaton about seismic events (**QuakeML/SeiscompML**). You can find more information about this formats in [obspy](https://docs.obspy.org/index.html) documentation.


# Station XML

First step - it is creation of stations metadata in **Seiscomp** database. It is very important step, because, if your set this information badly, you can face with big problems in future. In general, all information about seismological station consists in **StationXML** file. You can create this file using my notebook `station_xml.ipynb`.

You should add information about:
- station codes (names)
- network code
- latitudes
- longitudes
- altitudes
- channels codes
- location
- sampling rate
- and other...

You should describe all information about your seiscmological network, and this information must be same in all three **Seiscomp** formats.

We have temporary seismological network, which doesn't have uniqe network code, in this case **obspy** authors adivice use 'XX' code, but we decided use 'LD' code)

'Location' parameter **must be same** in all three formats for your network. If this condition don't met, you can't get data from seiscomp database.

If some parameters was changed, you can add this information in **StationXML**. (I add examples later)

Short instruction about storing **StationXML** to **Seiscomp** database:

1. Creation of **StationXML** file 'XX_HH_stations.xml' by `station_xml.ipynb`;
   
2. Log in to **Seiscomp** Linux server as `sysop` user;
   
3. Go to folder `station` in `seiscomp_scripts` by:
   
   ```
   > cd seiscomp_scripts/station
   ```

4. Add your **StationXML** file in this folder;
   
5. Edit `setup_configs.sh` script. You just should add some commands for each your station.
   
   ```bash
   # You should write your station names below
   # -------
   # Example: printf "${station_binding_config}" > "${keys_dir}/station_{network_code}_{station_name}"
   printf "${station_binding_config}" > "${keys_dir}/station_LD_SML00"
   printf "${station_binding_config}" > "${keys_dir}/station_LD_SML01"
   printf "${station_binding_config}" > "${keys_dir}/station_LD_SML02"
   ...
   # ------
   ```

6. Edit `add_stations.sh` script. Add your **Seiscomp** postgres database password to variable `seiscomp_pass`

   ```bash
   seiscomp_pass=1234abc
   ```
   
7. Start script `add_stations.sh` by:

   ```
   > bash add_stations.sh XX_HH_stations.xml
   ```

After that new metadata about your seismological network should be added to **Seiscomp** database!

# MSEED

...

# SeiscompML

...






