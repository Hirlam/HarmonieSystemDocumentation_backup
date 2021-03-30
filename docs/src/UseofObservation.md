```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/UseofObservation?action=edit"
```
# Use of Observation

## Background Information
   * [ODBusage2.pdf](ODBusage2.pdf) Anne Fouilloux's (ECMWF) review presentation about ODB
   * [http://apps.ecmwf.int/odbgov](http://apps.ecmwf.int/odbgov) ECMWF's ODB governance pages - useful for looking up ODB and BUFR definintions
   * [http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf](http://www.ecmwf.int/research/ifsdocs/CY28r1/pdf_files/odb.pdf) The ODB bible - Sami Saarinen's ODB user guide (2004)
   * [http://www.rclace.eu/File/Data_Assimilation/2007/lace_obspp.pdf](http://www.rclace.eu/File/Data_Assimilation/2007/lace_obspp.pdf) Sandor's document about observation dataflow in ALADIN 

## Observation types
The observation types used by Harmonie (upper-air) data assimilation are defined in [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass).
### SYNOP
By default all SYNOP observation types (including SHIP) are used. 
```bash
export SYNOP_OBS=1             # All synop
```
To blacklist SYNOP observations add blacklisted "ODB observation type/ASCII type/ODB code type/ODB variable number/station identifier/date to blacklist from" to [nam/LISTE_NOIRE_DIAP](https://hirlam.org/trac/browser/Harmonie/nam/LISTE_NOIRE_DIAP). For example to blacklist 10m winds from Valentia Automatic SYNOP (03953) from the 10th of November 2012 enter the following line to LISTE_NOIRE_DIAP:
```bash
 1 SYNOP       14  41 03953    10112012
```
(Note: please don't add Valentia to your blacklist - the observations from there are pretty good!)

For further information on ODB observation types, code types, variable numbers etc see the ECMWF ODB governance page here: [http://apps.ecmwf.int/odbgov/obstype/](http://apps.ecmwf.int/odbgov/obstype/)
### SHIP
See information provided above on SYNOP observations.
### BUOY
By default all BUOY observation types are used. 
```bash
export BUOY_OBS=1              # Buoy
```
To blacklist BUOY observations add blacklisted "ODB observation type/ASCII type/ODB code type/ODB variable number/station identifier/date to blacklist from" to [nam/LISTE_NOIRE_DIAP](https://hirlam.org/trac/browser/Harmonie/nam/LISTE_NOIRE_DIAP). For example to blacklist surface temperatures from BUOY M5 (62094) from the 10th of November 2012 enter the following line to LISTE_NOIRE_DIAP:
```bash
 4 BUOY        165  11 62094    10112012
```
(Note: please don't add M4 to your blacklist - the observations from there are pretty good too!)

For further information on ODB observation types, code types, variable numbers etc see the ECMWF ODB governance page here: [http://apps.ecmwf.int/odbgov/obstype/](http://apps.ecmwf.int/odbgov/obstype/)
### AIRCRAFT
By default all AIRCRAFT observation types (including AMDAR, AIREP, ACARS) are used. 
```bash
export AIRCRAFT_OBS=1          # AMDAR, AIREP, ACARS
```
Below are lines added by Xiaohua to the  DMI dka37 LISTE_NOIRE_DIAP file to exclude problematic aircraft observations:
```bash
2 AMDAR 144 2 EU0028 08292013
2 AMDAR 144 2 EU0092 01042013
2 AMDAR 144 2 EU0079 01052013
2 AMDAR 144 2 EU0097 01052013
2 AMDAR 144 2 EU0107 01052013
2 AMDAR 144 2 EU0033 01062013
2 AMDAR 144 2 EU0118 01062013
2 AMDAR 144 2 EU0112 07052013
2 AMDAR 144 2 EU1110 08122013
2 AMDAR 144 2 EU0074 08122013
```
### TEMP
By default all TEMP observation types are used. 
```bash
export TEMP_OBS=1              # TEMP, TEMPSHIP
```
### PILOT
By default all PILOT observation types are used. 
```bash
export PILOT_OBS=1             # Pilot, Europrofiler
```

### AMSUA
By default all AMSUA observation types are not used. 
```bash
export AMSUA_OBS=0             # AMSU-A
```
To use locally received AMSUA data provided by EUMETCast set ATOVS_SOURCE to local in [scr/include.ass](https://hirlam.org/trac/browser/Harmonie/scr/include.ass):
```bash
export ATOVS_SOURCE=mars       # local: EUMETCast; 
                               # mars: data from MARS
                               # hirlam: hirlam radiance template 
```

### AMV (aka SATOB, GEOWIND)

For AMVs there is a [HOW-TO page](../HarmonieSystemDocumentation/ObservationHowto/Amv.md).

### Other observation types ...
More documentation to follow ...
```bash
export AMSUB_OBS=0             # AMSU-B, MHS
export IASI_OBS=0              # IASI  
export PAOB_OBS=0              # PAOB not defined everywhere
export SCATT_OBS=0             # Scatterometer data not defined everywhere
export LIMB_OBS=0              # LIMB observations, GPS Radio Occultations
export RADAR_OBS=0             # Radar 
```
