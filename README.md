# Seiscomp lab 572

This project consists scripts and instructions for working with **Seisomp software**. **Seiscomp** - it is big application, which allow **obtain**, **store** and **process** seismology data. Seiscomp developers is a GFZ German Research Centre for Geosciences. In this paper I try to explain how you can store your seismology data in Seiscomp. In our case Seiscomp consists three types of data: seismic traces (**MSEED**), metadata about seismological stations (**StationXML**) and informaton about seismic events (**QuakeML/SeiscompML**). You can find more information about this formats in [obspy](https://docs.obspy.org/index.html) documentation.


# Station XML

First step - it is creation of stations metadata in Seiscomp data base. It is very important step, because, if your set this information badly, you can face with big problems in future. In general, all information about seismological station consists in **StationXML** file. You can create this file using my notebook `station_xml.ipynb`.

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
We have temporary seismological network, which doesn't have uniqe network code, in this case obspy authors adivice use 'XX' code, but we decided use 'LD' code)
'Location' parameter should be same in all three formats for your network. If this condition don't met, you can't get data from seiscomp database.
If some parameters was changed, you can add this information in **StationXML**. (I add examples later)




