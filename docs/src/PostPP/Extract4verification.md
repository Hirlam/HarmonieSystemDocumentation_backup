```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/PostPP/Extract4verification?action=edit"
```

## Verification preparation
## Introduction

Before we can run the verification we need to extract data for each geographical point and produce files in a format that the verification program can use. In HARMONIE there are two programs, one fore extracting model data (fldextr_grib_api) and one for observations ( obsextr ). Both are part of the [gl_grib_api package](https://hirlam.org/trac/browser/Harmonie/util/gl_grib_api). 

  fldextr is capable of extracting data from several sources (HARMONIE/HIRLAM/IFS and produces so called vfld-files in ASCII format. The main tasks of the program is to:

   - Recalculates rh,td to be over water
   - Interpolates to geographical points according to a synop.list and temp.list
   - Does MSLP,RH2M,TD2M calculations if the are not available in the input file
   - Optional fraction of land check.
   - Interpolates to pressure levels for TEMP data.

  obsextr extracts conventional observations from BUFR data and creates a vobs file similar to the vfld file. It:

   - Reads SYNOP and TEMP
   - LUSE_LIST controls the usage of a station list

## Station lists used by verification
[Fldextr](https://hirlam.org/trac/browser/Harmonie/scr/Fldextr) links  synop.list to $HM_LIB/util/gl_grib_api/scr/allsynop.list  and temp.list to $HM_LIB/util/gl_grib_api/scr/alltemp.list. These station lists are based on information in WMO's ''Publication No. 9, Volume A, Observing Stations 
and WMO Catalogue of Radiosondes*. This is regularly updated by the WMO. allsynop.list and alltemp.list are updated less frequently. There is also scope to include local stations in these lists that are not included in WMO's*Publication No. 9''. The following 7-digit station identifiers are available to HIRLAM countries:

|Norway       |!1000000 - !1099999 |
| --- | --- |
|Sweden       |!2000000 - !2099999 |
|Estonia      |!2600000 - !2649999 |
|Lithuania    |!2650000 - !2699999 |
|Finland      |!2700000 - !2799999 |
|Ireland      |!3900000 - !3900000 |
|Iceland      |!4000000 - !4099999 |
|Greenland    |!4200000 - !4299999 |
|Denmark      |!6000000 - !6999999 |
|Netherlands  |!6200000 - !6299999 |
|Spain        |!8000000 - !8099999 |

## Field extraction

[Fldextr](https://hirlam.org/trac/browser/Harmonie/scr/Fldextr). This script goes through all forecast files and 
collects all the variables (T2m, V10m, mean sea level pressure, RH2m, Q2m, total cloudiness, precipitation + profiles) 
needed in basic verification.

 * Input parameters: none.
 * Data: Forecast files.
 * Namelists: Station lists for surface data (ewglam.list) and radiosounding data (temp.list).
 * Executables: fldextr.
 * Output: Field extraction files (vfld${EXP}${DTG}), which are placed in *EXTRARCH*.

## Extract observations

[FetchOBS](https://hirlam.org/trac/browser/Harmonie/scr/FetchOBS) scripts takes care of the observation 
extraction for verification. First, the observation BUFR-file is fetched from the MARS (**ExtractVEROBSfromMARS**), 
then all the needed data is extracted from the BUFR-files.

 * Input parameters: none.  
 * Data:  Station lists for surface data (ewglam.list) and radiosounding data (temp.list). These shoud be found from *SCRDIR*  
 * Executables: mars, obsextr.  
 * Output: Field extraction files (vobs*), which are placed in *EXTRARCH*.

For the continuous monitoring on hirlam.org the most recent data are kept online at ECMWF under `ecgb:/scratch/ms/dk/nhz/OBS`.

## A general input format

The file format for verification is a simple ascii file with a header that allows an arbitrary number of different types of point data to be included in the model vfld- or observation vobs- files.

The generalized input format is defined as 

```bash
nstation_synop nstation_temp version_flag  # written in fortran format '(1x,3I6)' )
# where version_flag == 4
# If ( nstation_synop > 0 ) we read the variables in the file, their descriptors and
# their accumulation time
#
nvar_synop
DESC_1 ACC_TIME_1
...
DESC_nvar_synop ACC_TIME_nvar_synop
# Station information and data N=nstation_synop times
stid_1 lat lon hgt val(1:nvar_synop)
...
stid_N lat lon hgt val(1:nvar_synop)

# If ( nstation_temp > 0 )
nlev_temp
nvar_temp
DESC_1 ACC_TIME_1
..
DESC_nvar_temp ACC_TIME_nvar_temp
# Station information and data nstation_temp times
# and station data nlev_temp times for each station
stid_1 lat lon hgt
pressure(1) val(1:nvar_temp)
...
pressure(nlev_temp) val(1:nvar_temp)
stid_2 lat lon hgt
...
```

The accumulation time allows us to e.g. easily include different precipitation accumulation intervals.

[Back to the main page of the HARMONIE System Documentation](../../HarmonieSystemDocumentation.md)
----


