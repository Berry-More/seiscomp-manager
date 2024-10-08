# Seiscomp lab 572

This project consists scripts and instructions for working with **Seisomp software**. **Seiscomp** - it is big application, which allow **obtain**, **store** and **process** seismology data. **Seiscomp** developers is a GFZ German Research Centre for Geosciences. In this paper I try to explain how you can store your seismology data in Seiscomp. In our case Seiscomp consists three types of data: seismic traces (**MSEED**), metadata about seismological stations (**StationXML**) and informaton about seismic events (**QuakeML/SeiscompML**). You can find more information about this formats in [obspy](https://docs.obspy.org/index.html) documentation.


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
   
2. Log in to **Seiscomp** Linux server as `sysop` user by SSH;
   
3. Go to folder `station` in `seiscomp_scripts` by:
   
   ```
   > cd seiscomp_scripts/station
   ```

4. Add your **Station XML** file in this folder;
   
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

If you want to delete some old network inventory from **Sesicomp** you should use this instruction:

1. Log in to server
   
2. Delete old inventory file `XX_HH_stations.xml` from `/home/sysop/seiscomp/etc/inventory` folder

3. Run command `seiscomp update-config inventory`

4. Restart **Seiscomp** `seiscomp stop` -> `seiscomp start`

# MSEED

Second step - it is a transfer and storage seismological traces data to **Seiscomp** database. There is `tempstore` folder, which allowed huge block of memory for storing big data. This folder located in path `/3tb/tempstore/`. I advice to save all MSEED data in this folder dividing data on seismological networks folders. "Save MSEED to **Seiscomp**" - it is means start bash script with seiscomp commands, which process MSEED data and save it in local **Seiscomp** `archive` folder `home/sysop/seiscomp/var/lib/archive`. In `archive` folder all files have numeration by day in year (1-365).

Short instruction about storing **MSEED** data to **Seiscomp** database:

1. Log in to **Seiscomp** Linux server as `sysop` user by SSH;


2. Move **MSEED** files from your computer to Linux server, in `/3tb/tempstore/*network*` folder;


3. Go to folder `seiscomp_scripts`;

   ```
   > cd seiscomp_scripts
   ```

4. Run `seed_archive.sh` script by command:

   ```
   > bash seed_archive.sh /3tb/tempstore/*network*/MSEED
   ```

This bash script just apply **Seiscomp** command `scart` to all files in directory. This command process **MSEED** data and save it in **Seiscomp** database.

# Seiscomp XML

Our laboratory work with 'SSD' format of storing information about seismological events. This format consists information about determined earthquake parameters `#EARTHQUAKE`, information about detected amplitudes of S waves `#AMPLITUDE` and information about arrival times of P and S waves `#ARRIVAL`. 

<details>
   
<summary>There is information from 'SSD' file</summary>
   
```
#SSDREPORT=20210807152934.ssd
#EARTHQUAKE [Origin Time] 2021.08.07 15:29:34.5726
#EARTHQUAKE [Origin Error] 0.513819
#EARTHQUAKE [Latitude]	72.7576N
#EARTHQUAKE [Delta Error] 9.38492
#EARTHQUAKE [Longitude]	125.6928E
#EARTHQUAKE [Depth]	  5.434
#EARTHQUAKE [Depth Error] 6.9321
#EARTHQUAKE [Travel Times] regional.gdg
#EARTHQUAKE [Location Limits] 0;50;0;0.98
#EARTHQUAKE [Magnitude]	Ks=3.4 (8)
#CHANNEL SML00 IU HHE 1 8 " [IIRBT_BP=1:20^2^125]##03 72.3888,126.488,10,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:29:51.5600
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	1361.99
#AMPLITUDE [Amplitude]	0.0647888 [microns:second]
#AMPLITUDE [Period]	0.096
#AMPLITUDE [Magnitude]	Ks 3.04498 0
#CHANNEL SML00 IU HHN 1 8 " [IIRBT_BP=1:20^2^125]##03 72.3888,126.488,10,0"
#ARRIVAL [Phase]	P
#ARRIVAL [Time]	2021.08.07 15:29:43.8642
#ARRIVAL [Level]	-4.02259e-010
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		49.0965;146.77
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:29:51.2960
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	2395.41
#AMPLITUDE [Amplitude]	0.113948 [microns:second]
#AMPLITUDE [Period]	0.096
#AMPLITUDE [Magnitude]	Ks 3.53539 0
#CHANNEL SML00 IU HHZ 1 8 " [IIRBT_BP=1:20^2^125]##03 72.3888,126.488,10,0"
#ARRIVAL [Phase]	S
#ARRIVAL [Time]	2021.08.07 15:29:50.9428
#ARRIVAL [Level]	4.26842e-009
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		49.0965;146.77
#CHANNEL SML03 IU HHE 1 8 " [IIRBT_BP=1:20^2^125]##03 72.4023,126.794,80,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:29:53.3440
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	1464.87
#AMPLITUDE [Amplitude]	0.0696827 [microns:second]
#AMPLITUDE [Period]	0.064
#AMPLITUDE [Magnitude]	Ks 3.10587 0
#CHANNEL SML03 IU HHN 1 8 " [IIRBT_BP=1:20^2^125]##03 72.4023,126.794,80,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:29:53.1280
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	1462.16
#AMPLITUDE [Amplitude]	0.0695538 [microns:second]
#AMPLITUDE [Period]	0.08
#AMPLITUDE [Magnitude]	Ks 3.10427 0
#CHANNEL SML03 IU HHZ 1 8 " [IIRBT_BP=1:20^2^125]##03 72.4023,126.794,80,0"
#ARRIVAL [Phase]	P
#ARRIVAL [Time]	2021.08.07 15:29:45.6547
#ARRIVAL [Level]	2.65597e-008
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		54.2106;136.604
#ARRIVAL [Phase]	S
#ARRIVAL [Time]	2021.08.07 15:29:52.7232
#ARRIVAL [Level]	-1.27267e-008
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		54.2106;136.604
#CHANNEL SML07 IU HHE 1 8 " [IIRBT_BP=1:20^2^125]##03 72.075,128.325,35,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:30:10.9360
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	285.783
#AMPLITUDE [Amplitude]	0.0135945 [microns:second]
#AMPLITUDE [Period]	0.064
#AMPLITUDE [Magnitude]	Ks 3.16168 0
#CHANNEL SML07 IU HHN 1 8 " [IIRBT_BP=1:20^2^125]##03 72.075,128.325,35,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:30:11.6160
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	403.289
#AMPLITUDE [Amplitude]	0.0191841 [microns:second]
#AMPLITUDE [Period]	0.096
#AMPLITUDE [Magnitude]	Ks 3.46084 0
#CHANNEL SML07 IU HHZ 1 8 " [IIRBT_BP=1:20^2^125]##03 72.075,128.325,35,0"
#ARRIVAL [Phase]	P
#ARRIVAL [Time]	2021.08.07 15:29:54.9566
#ARRIVAL [Level]	1.26455e-009
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		117.204;129.37
#ARRIVAL [Phase]	S
#ARRIVAL [Time]	2021.08.07 15:30:10.0450
#ARRIVAL [Level]	-2.65227e-009
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		117.204;129.37
#CHANNEL SML08 IU HHE 1 8 " [IIRBT_BP=1:20^2^125]##03 72.2628,127.868,38,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:30:3.8880
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	961.462
#AMPLITUDE [Amplitude]	0.045736 [microns:second]
#AMPLITUDE [Period]	0.096
#AMPLITUDE [Magnitude]	Ks 3.71349 0
#CHANNEL SML08 IU HHN 1 8 " [IIRBT_BP=1:20^2^125]##03 72.2628,127.868,38,0"
#AMPLITUDE [Phase]	S
#AMPLITUDE [Time]	2021.08.07 15:30:4.6320
#AMPLITUDE [Pribor]	A
#AMPLITUDE [Sens]	2.1022e+010
#AMPLITUDE [Counts]	1491.13
#AMPLITUDE [Amplitude]	0.0709319 [microns:second]
#AMPLITUDE [Period]	0.064
#AMPLITUDE [Magnitude]	Ks 4.09466 0
#CHANNEL SML08 IU HHZ 1 8 " [IIRBT_BP=1:20^2^125]##03 72.2628,127.868,38,0"
#ARRIVAL [Phase]	P
#ARRIVAL [Time]	2021.08.07 15:29:51.1205
#ARRIVAL [Level]	1.78967e-009
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		91.6879;126.071
#ARRIVAL [Phase]	S
#ARRIVAL [Time]	2021.08.07 15:30:2.9752
#ARRIVAL [Level]	8.46004e-010
#ARRIVAL [Quality]	e
#ARRIVAL [Sign]		?
#ARRIVAL [Dist-Az]		91.6879;126.071
```
</details>

I created `ssd2scml.ipynb` notebook which convert `SSD` files to `QuakeML` or `SCML`. In addition, I created bash script `save_scml2db.sh`, which can move your `SCML` files in **Seiscomp** database. Thus, if you want to storage your `SSD` data to **Seiscomp** you should:

1. Convert your `SSD` files to `SCML` using `ssd2scml.ipynb` notebook.

   There are some parameters below, which relevant to our lab temporary seismological network, but you can change it for your aims.
   ```python
   resource_id = 'smi:ru.ipgg.seislab'
   event_type = 'earthquake'
   event_type_certainty = 'known'
   origin_depth_type = 'from location'
   magnitude_type = 'Mb'
   pick_polarity = 'undecidable'
   pick_evaluation_mode = 'manual'
   pick_evaluation_status = 'final'
   ```

2. Log in to **Seiscomp** Linux server as `sysop` user by SSH;

3. Move all new `SCML` files to Linux server.
   
   In my case, I move my `SCML` data to `/3tb/tempstore/*network*/events`.

4. Go to `/home/sysop/seiscomp_scripts/events` folder.
   ```
   > cd /home/sysop/seiscomp_scripts/events
   ```

5. Run `save_scml2db.sh` script indicating directory, where storage `SCML` files.

   ```
   > bash save_scml2db.sh /3tb/tempstore/*network*/events
   ```

Factually this bash script just apply `scdispatch` **Seiscomp's** command to each file in indicated folder.


# FDSNWS

You can get all your data by Seiscomp FDSNWS server. It is API which provide possible to download all seismology data.

## Getting MSEED

There is web-service which can generate requests for Seiscomp API [mseed data](http://84.237.52.214:8080/fdsnws/dataselect/1/builder).

Link to download data looks like that:
> http://84.237.52.214:8080/fdsnws/dataselect/1/query

You can add some arguments to select you data. You should add to link "?" and arguments that are separated by "&".
> http://84.237.52.214:8080/fdsnws/dataselect/1/query?network=LD&location=XX

Data downloaded by API. API takes this arguments:
1) Start time (*starttime=2021-07-31T00%3A00%3A00*);
2) End time (*endtime=2021-08-01T00%3A00%3A00*);
> time format: **year**-**month**-**day**T**hours**%3A**minutes**%3A**seconds**

3) Network code (*network=LD*);
4) Stations codes (*station=**SML01**%2C%20**SML05***). Change the comma to a "%2C%20";
5) Channel code (*channel=HHN*);
6) Specific error argument (*nodata=404*). It helps when API can't to provide data (e.g. because you set some wrong parameters). In this case API post to you error 404. If you don't set this argument you just get empty response.

You can read data dirrectly in Python.

![alt text](https://github.com/Berry-More/seiscomp-manager/blob/main/pictures/read_data.png)


## Getting Station XML

You can get fully informaton about stations in xml-format by http://84.237.52.214:8080/fdsnws/station/1/query. Also you can use "builder" like in [here](#getting-mseed) (http://84.237.52.214:8080/fdsnws/station/1/builder). Here you can recieve all information about seismological inventory. You can read this data in Python using `obspy.read_inventory` function.


## Getting Seiscomp XML

If you want to work with event data *you should understand structure of this data*. **QuakeML** (or very similar format **Seiscomp XML (SCML)**) - it is conventional XML-format consists information about seismological events. In general, I use **Seiscomp XML** format, because it can very simple add to Seiscomp data base. But you can use any of this formats, and don't worry, because **obspy** can read all this formats. 

Structure of **QuakeML** and **SCML** very similar and looks like this:

--> **Event**

----> **Origin**

------> **Arrivals**

----> **Magnitude**

----> **Picks**

----> **Amplitudes**

All classes which forming **SCML** have `resource_id` field. It is *some unique id* for each element. In **Seiscomp** manual said that base of `resource_id` should be string with information about *region*, *institute*, *lab*. I also added to this *network code*. First word should be `smi:` - it is rule. Example of base of `resource_id` that I used allow (*$*$ - variable*):

> **base_id = "smi:ru.ipgg.seislab/$network_code$"**
>
> *Example: "smi:ru.ipgg.seislab/LD"*

+ **Event class** fully described seismology event. It consists information about:
1) Type of event (`type` field);
2) Source info (`origin` class);
3) Magnitude info (`magnitude` class);
4) Picks info (list with `pick` class objects);
5) Amplitude info (list with `amplitude` class objects)

> **event_id = base_id + "event/$time$"**
>
> *Example: "smi:ru.ipgg.seislab/LD/event/20210731003147"*

+ **Origin class** described event origin. It consists information about:
1) Time in origin (`time` field);
2) Latitude (`latitude` field with error field);
3) Longitude (`longitude` field with error field);
4) Depth (`depth` field with error field);
5) Info from picks (`arrivals` class)

> **origin_id = event_id + "/origin"**
>
> *Example: smi:ru.ipgg.seislab/LD/event/20210731003147/origin*

+ **Arrivals class** it is information about origin, which obtained by picking. It contains:
1) Link to pick (`pickID` field);
2) Phase (`phase` field);
3) Azimuth (`azimuth` field);
4) Distance (`distance` field)

> **arrival_id = event_id + "/arrival/$phase$/$station$/$channel$"**
>
> *Example: smi:ru.ipgg.seislab/LD/event/20210731003147/arrival/P/SML00/HHN*

+ **Magnitude class** which consists information about magnitude:
1) Magnitude value (`mag` field);
2) Magnitude type (`type` field);
3) Link to origin (`originID`, field)

> **magnitude_id = event_id + "/magnitude"**
>
> *Example: smi:ru.ipgg.seislab/LD/event/20210731003147/magnitude*

+ **Pick class** consists all information about travel times of P and S waves:
1) Picked time (`time` field);
2) Info about network, location, station, channel (`waveformID` class);
3) Phase (`phaseHint` field)
Other parameters don't used.

> **pick_id = event_id + "/pick/$phase$/$station$/$channel$"**
>
> *Example: smi:ru.ipgg.seislab/LD/event/20210731003147/pick/P/SML00/HHN*

+ **Amplitude class** consists information about amplitudes:
1) Amplitude type (`type` field. In general, I set "END");
2) Amplitude value (`amplitude` field);
3) Time when this amplitude was picked (`timeWindow` class, `reference` field);
4) Period (`period` fields);
5) Amplitude unit (`unit` field. I use micron:second);
6) Info about network, location, station, channel (`waveformID` class);

> **amplitude_id = event_id + "amplitude/$station$/$channel$"**
>
> *Example: smi:ru.ipgg.seislab/LD/event/20210731003147/amplitude/SML00/HHN*


**All information** about events you can get here http://84.237.52.214:8080/fdsnws/event/1/builder. If you want to get **full** information about events, you should mark "All Origins", "All Magnitudes" and "Arrivals". After that, builder should generate link to download *XML-file*. You can read this file by function `obspy.read_events`. You can change this link as you wish.
