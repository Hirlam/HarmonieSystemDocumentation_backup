```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/ObservationHowto/Amv?action=edit"
```

# Atmospheric Motion Vectors (AMV)

## Introduction
In this short information about the (pre-)processing, assimilation, and post-processing, as well as access to the AMV data in the Harmonie system is shown.

## AMV data
AMV data is available via EUMETCast (the [EUMETAT processed](http://www.eumetsat.int/website/wcm/idc/idcplg?IdcService=GET_FILE&dDocName=PDF_AMV_PG&RevisionSelectionMethod=LatestReleased&Rendition=Web)), the MARS archive at ECMWF (both polar and geowind) or [locally](http://www.nwcsaf.org/Downloads/GEO/2018.1/Documents/Scientific_Docs/NWC-CDOP3-GEO-AEMET-SCI-UM-Wind_v1.1.pdf) using NWCSAF software. Through the EUMETCast, both data are in BUFR format. An abstract from the 5th Winds Workshop on the quality control of EUMETSAT wind products ([S2-3_Elliott-Parallel.pdf](https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemDocumentation/ObservationHowto/Amv/S2-3_Elliott-Parallel.pdf)) provides some useful information on how AMV BUFR is encoded. We define two kinds of AMV data in the Harmonie system: Geostationary satellite based (GEOW) and polar satellite based (POLW). GEOW and POLW can be processed separately through the usual request in scr/include.ass as described below.
## HARMONIE changes
### scr/include.ass
In [source:scr/include.ass] should be edited to "switch on" the use of AMVs (SATOB/geowinds):
```bash
export GEOW_OBS=1               # Satob geowind / SAFNWC geowind
export GEOW_SOURCE=ears         # mars:MARS | else: file in $OBDIR
[[  $GEOW_OBS -eq 1  ]] && types_BASE="$types_BASE geow"

export POLW_OBS=1               # Polar winds
export POLW_SOURCE=ears         # mars:MARS | else: file in $OBDIR
[[  $POLW_OBS -eq 1  ]] && types_BASE="$types_BASE polarw"
```

**Important:** Please note that data from MARS were not yet tested!!! Roger is happy to assist if you prefer to use this option. The Harmonie system is updated with the aim to be able to use these data in operational application.
 
### param.cfg
The BUFR template used by your AMV data should be defined in the param.cfg file used by Bator. param.cfg files for Bator are in the const/bator_param directory. The geowind param.cfg template should be something like this:
```bash
BEGIN geowind
A 0 4 18
codage       1  aaaaaa
  :          :    :
codage       A  aaaaaa
offset       1      24  offset for QI_3 (eumetsat & tokyo)
offset       2      28  offset for QI_1 (NOAA)
offset       3      14  offset for QI_2 (NOAA)
offset       4      48  offset for QI_2 (eumetsat & tokyo)
values       1  001007  SATELLITE IDENTIFIER
values       2  001031  IDENTIFICATION OF ORIGINATING/GENERATING CENTRE (SEE NOTE 10)
values       4  002221  SEGMENT SIZE AT NADIR IN X DIRECTION
values       5  002222  SEGMENT SIZE AT NADIR IN Y DIRECTION
values       6  004001  YEAR
values      12  005001  LATITUDE (HIGH ACCURACY)
values      13  006001  LONGITUDE (HIGH ACCURACY)
values      14  002252  SATELLITE INSTRUMENT DATA USED IN PROCESSING
values      15  002023  SATELLITE DERIVED WIND COMPUTATION METHOD
values      16  007004  PRESSURE
values      17  011001  WIND DIRECTION
values      18  011002  WIND SPEED
values      21  012193  COLDEST CLUSTER TEMPERATURE
values      22  002231  HEIGHT ASSIGNMENT METHOD
values      23  002232  TRACER CORRELATION METHOD
values      24  008012  LAND/SEA QUALIFIER
values      25  007024  SATELLITE ZENITH ANGLE
values     211  033007  % CONFIDENCE
END geowind
```

Please be reminded that the processing of data from MARS was not yet tested.
From 43h2.1, we have the all necessary content of the param file for processing of both GEOW and POLW in const/bator_param/param_bator.cfg.geow.${GEOW_SOURCE/POLW_SOURCE}

### BATOR namelist
Depending on the satellite and channel you may have to add entries to the NADIRS namelist in the Bator script like the following:
```bash
   TS_GEOWIND(isatid)%T_SELECT%LCANAL(ichanal)=.TRUE.,
```
 * Satellite identifiers are available here: [https://software.ecmwf.int/wiki/display/ECC/WMO%3D27+code-flag+table]
 * Bator defaults for MSG AMV data are set in [src/odb/pandor/module/bator_init_mod.F90](https://hirlam.org/trac/browser/Harmonie/src/odb/pandor/module/bator_init_mod.F90#L648)
## Source code
The reading of BUFR AMVs is taken care of by the [subroutine in [source:Harmonie/src/odb/pandor/module/bator_decodbufr_mod.F90 src/odb/pandor/module/bator_decodbufr_mod.F90](https://hirlam.org/trac/browser/geowind]). This subroutine reads the following parameters defined in the param.cfg file:

|= Name            =|= Description =|
| --- | --- |
| Date and time     | derived from the tconfig(004001) - assumes month, day, hour and minute are in consecutive entries in the values array |
| Location          | latitude and longitude are read from tconfig(005001) and tconfig(006001)                                              |
| Satellite         | the satellite identifier is read from tconfig(001007)                                                                 |
| Origin. center    | the originating center (of the AMV) is read from tconfig(001031)                                                      |
| Compu. method     | the wind computation method (type of channel + cloudy/clear if WV) is read from tconfig(002023)                       |
| Derivation method | the height assignment method is read from tconfig(002163) and the tracking method from tconfig (002164)               |
| Channel frequency | the centre frequency of the satellite channel is read from tconfig(002153)                                            |
| Height (pressure) | the height of the AMV observation is read from tconfig(007004)                                                        |
| Wind              | the wind speed and direction  are read from tconfig(011002) and tconfig(011001)                                       |
| Temperature       | the coldest cluster temperature is read from tconfig(012071)                                                          |
| FG QI             | The QI (including FG consistency) for MSG AMVs is read from the first location where descriptor 033007 appears        |
| noFG-QI           | The FG-independent QI for MSG AMVs is read from the first location where 033007 appears + offset(1)=24                |
| Sat zenith angle  | the satellite zenith angle is read from tconfig(007024)                                                               |
| Land/sea/coast    | a land/sea/coast qualifier is read from tconfig(008012)                                                               |

The geowind routine was adapted to handle MSG AMVs from MARS and its module [src/odb/pandor/module/bator_decodbufr_mod.F90](https://hirlam.org/trac/browser/Harmonie/src/odb/pandor/module/bator_decodbufr_mod.F90) uploaded to the trunk (Mar 2017) .

## Blacklist
The selection/blacklist of AMVs according to channel, underlying sea/land, QI, etc. is done in [src/blacklist/mf_blacklist.b](https://hirlam.org/trac/browser/Harmonie/src/blacklist/mf_blacklist.b), section *- SATOB CONSTANT DATA SELECTION -*.
