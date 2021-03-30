```@meta
EditURL="https://hirlam.org/trac//wiki//HarmonieSystemDocumentation/Screening?action=edit"
```


## Screening

## Introduction

Screening (configuration 002 of ARPEGE/IFS model) carries out quality control of observations. 

A useful presentation (Martin Ridal) from the "Hirlam-B Training Week on HARMONIE system" training course is available here: [MR_screenandminim.pdf](https://hirlam.org/trac/raw-attachment/wiki/HarmonieSystemTraining2014/Programme/MR_screenandminim.pdf). Most of the information on this page is based on his presentation.

## Inputs

 * First guess (the same file with 5  different names):
   * ICMSHMIN1INIT
   * ICMSHMIN1IMIN
   * ICMRFMIN10000
   * ELSCFMIN1ALBC000
   * ELSCFMIN1ALBC

 * Input/output ODB directory structure
   * ${d_DB}/ECMA
   * ${d_DB}/ECMA.${base1}

 * Constants and statistics (MAY NEED TO BE UPDATED)
   * correl.dat
   * sigmab.dat
   * rszcoef_fmt
   * errgrib
   * rt_coef_atovs_newpred_ieee.dat
   * bcor_noaa.dat
   * chanspec_noaa.dat
   * rmtberr_noaa.dat
   * cstlim_noaa.dat

 * Namelist: See *%screening* in [nam/harmonie_namelists.pm](https://hirlam.org/trac/browser/Harmonie/nam/harmonie_namelists.pm)


## Screening tasks
(Based on Martin Ridal's presentation).

 * Preliminary check of observations
   * Check of completeness of the reports
   * Check if station altitude is present
   * Check of the reporting practice for SYNOP & TEMP mass observations 
 * Blacklisting: A blacklist is applied to discard observations of known poor quality and/or that cannot be properly handled by the data assimilation. A selection of variables for assimilation is done using the data selection part of the blacklist file and the information hard-coded in Arpege/Aladin (orographic rejection limit, land-sea rejection...). Decisions based on the blacklist are feedback to the CMA. Blacklisting is defined in [src/bla/mf_blacklist.b](https://hirlam.org/trac/browser/Harmonie/src/bla/mf_blacklist.b)
 * Background quality control: flags are assigned to observations -- 1 =>  probably correct, 2 => probably incorrect, 3 => incorrect.
 * Vertical consistency of multilevel report:
   * The duplicated levels, in multi-level reports, are removed from the reports
   * If 4 consecutive layers are found to be of suspicious quality then these layers are rejected
 * Removal of duplicated reports
   * In case of co-located airep reports of the same observation types (time, position), some or all of the content of one of the reports is rejected
 * Redundancy check
   * performed for active reports that are co-located and originate from the same station
   * LAND SYNOP: the report closest to the centre of the screening time window with most active data is retained
   * SHIP SYNOP: redundant if the moving platforms are within a circle of 1^o^ radius ([src/arpifs/obs_preproc/sufglim.F90](https://hirlam.org/trac/browser/Harmonie/src/arpifs/obs_preproc/sufglim.F90): RSHIDIS = 111000._JPRB)
   * TEMP and PILOT: same stations are considered at the same time in the redundancy check
   * A SYNOP mass observation is redundant if there are any TEMP geopotential height observations (made in the same time and the same station) that are no more than 50hPa above the SYNOP mass observation
 * Thinning: High resolution data needs to be reduced to reduce correlated errors and reduce the amount of data



## Output
The quality control information will be put into the input ECMA ODB(s) and a newly created CCMA to used by the 3DVAR minimization.

A valuable summary about screening decisions can be found in HM_Date_YYYYMMDDHH.html:
 * Look for “SCREENING STATISTICS” to get:
   * STATUS summary
   * EVENT summary
   * Number of variables, departures and missing departures
   * Diagnostic JO-table
   * CCMA ODB and updated ECMA ODB


Screening Events listed under "EVENT SUMMARY OF REPORTS:"

|=  =|= Description                              =|
| --- | --- |
|  1 |NO DATA IN THE REPORT                       |
|  2 |ALL DATA REJECTED                           |
|  3 |BAD REPORTING PRACTICE                      |
|  4 |REJECTED DUE TO RDB FLAG                    |
|  5 |ACTIVATED DUE TO RDB FLAG                   |
|  6 |ACTIVATED BY WHITELIST                      |
|  7 |HORIZONTAL POSITION OUT OF RANGE            |
|  8 |VERTICAL POSITION OUT OF RANGE              |
|  9 |TIME OUT OF RANGE                           |
| 10 |REDUNDANT REPORT                            |
| 11 |REPORT OVER LAND                            |
| 12 |REPORT OVER SEA                             |
| 13 |MISSING STATION ALTITUDE                    |
| 14 |MODEL SUR. TOO FAR FROM STAT. ALT.          |
| 15 |REPORT REJECTED THROUGH THE NAMELIST        |
| 16 |FAILED QUALITY CONTROL                      |









